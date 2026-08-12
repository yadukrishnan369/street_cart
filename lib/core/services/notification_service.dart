import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/order_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/customer/notification/presentation/pages/customer_notifications_page.dart';
import 'package:street_cart/features/shop/notification/presentation/pages/shop_notifications_page.dart';
import 'package:street_cart/features/admin/notification/presentation/pages/admin_notifications_page.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Silent handler for incoming background messages
}

class NotificationService {
  NotificationService._privateConstructor();

  // Singleton pattern instance
  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Global navigator key used to redirect users on notification tap
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // High importance channel configuration for Android devices
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // Broadcast stream controller to notify internal UI pages of foreground alerts
  final StreamController<RemoteMessage> _foregroundStreamController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onForegroundMessage =>
      _foregroundStreamController.stream;

  // Initializes notification handlers, hooks local channels, and sets up tap callbacks
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set launcher icon as default target icon for Android notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Wire tap response logic when user clicks local alert banner
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        final orderId = details.payload;
        if (orderId != null && orderId.isNotEmpty) {
          _handleNotificationTap(orderId);
        } else {
          _navigateToNotificationsPage();
        }
      },
    );

    // Register high-priority channel details in native platform settings
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Intercept active incoming FCM payloads while app is currently in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        // Trigger local OS alert banner since Android doesn't show them by default in foreground
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data.toString(),
        );
      }

      _foregroundStreamController.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Background message tap hook
    });
  }

  // Ask permissions for alert banners, sounds, and badges on iOS and Android
  Future<void> requestPermissions() async {
    try {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  // Helper utility to manually trigger an immediate local heads-up display banner
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _localNotifications.show(
        title.hashCode ^ body.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: payload,
      );
    } catch (_) {}
  }

  // Retrieves device token from Firebase Messaging registry
  Future<String?> getDeviceToken() async {
    try {
      return await _fcm.getToken(
        vapidKey:
            "BB8YAXp4ylnyc85bm0IwWMr7WBNkp8Y12oUJApK5SYUbQKDlhnfgCVlIT2vr5t5hJY6R_6R0jQSXAsYS6ngDmKY",
      );
    } catch (_) {
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  StreamSubscription<QuerySnapshot>? _firestoreSubscription;
  String? _currentUserType;

  // Saves FCM token to user document and initializes Firestore database listeners
  Future<void> saveTokenToFirestore(String userId, String userType) async {
    try {
      _currentUserType = userType;
      _listenToFirestoreNotifications(userId, userType);

      final token = await getDeviceToken();
      if (token == null) return;

      String collectionPath;
      if (userType == 'customer') {
        collectionPath = 'customers';
      } else if (userType == 'shop') {
        collectionPath = 'shops';
      } else if (userType == 'admin') {
        collectionPath = 'admins';
      } else {
        return;
      }

      // Update token in Firestore to target correct device for push messaging
      await _firestore.collection(collectionPath).doc(userId).set({
        'fcm_token': token,
        'last_token_update': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  // Real-time listener that watches database notifications and triggers local notifications
  void _listenToFirestoreNotifications(String userId, String userType) {
    _firestoreSubscription?.cancel();

    String collectionPath;
    if (userType == 'customer') {
      collectionPath = 'customers';
    } else if (userType == 'shop') {
      collectionPath = 'shops';
    } else if (userType == 'admin') {
      collectionPath = 'admins';
    } else {
      return;
    }

    bool isFirstLoad = true;

    _firestoreSubscription = _firestore
        .collection(collectionPath)
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
          // Ignore pre-existing past database records on startup
          if (isFirstLoad) {
            isFirstLoad = false;
            return;
          }

          // Loop through new notification changes.
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();
              if (data != null && data['is_read'] == false) {
                // Fetch preferences dynamically before displaying the local banner
                _firestore
                    .collection(collectionPath)
                    .doc(userId)
                    .get()
                    .then((userDoc) {
                      if (userDoc.exists && userDoc.data() != null) {
                        final userData = userDoc.data()!;
                        final type = data['type'] as String?;
                        bool enabled = true;

                        // Match preference toggles based on current user account type
                        if (userType == 'customer') {
                          if (type == 'order_status') {
                            enabled = userData['orderAlertsEnabled'] ?? true;
                          } else {
                            enabled =
                                userData['generalNotificationsEnabled'] ?? true;
                          }
                        } else if (userType == 'shop') {
                          if (type == 'new_order' || type == 'order_status') {
                            enabled = userData['orderAlertsEnabled'] ?? true;
                          } else {
                            enabled =
                                userData['generalNotificationsEnabled'] ?? true;
                          }
                        } else if (userType == 'admin') {
                          if (type == 'order') {
                            enabled = userData['orderAlertsEnabled'] ?? true;
                          } else if (type == 'shop_registration') {
                            enabled =
                                userData['registrationAlertsEnabled'] ?? true;
                          }
                        }

                        // Cancel banner display if alert channel is disabled in user settings
                        if (!enabled) return;
                      }

                      showLocalNotification(
                        title: data['title'] ?? 'Notification',
                        body: data['body'] ?? '',
                        payload: data['related_id'],
                      );
                    })
                    .catchError((e) {
                      // Fallback banner trigger in case user preference query fails
                      showLocalNotification(
                        title: data['title'] ?? 'Notification',
                        body: data['body'] ?? '',
                        payload: data['related_id'],
                      );
                    });
              }
            }
          }
        }, onError: (_) {});
  }

  // Deletes active device token from database on logout to prevent ghost notifications
  Future<void> deleteTokenFromFirestore(String userId, String userType) async {
    try {
      _firestoreSubscription?.cancel();
      _currentUserType = null;

      String collectionPath;
      if (userType == 'customer') {
        collectionPath = 'customers';
      } else if (userType == 'shop') {
        collectionPath = 'shops';
      } else if (userType == 'admin') {
        collectionPath = 'admins';
      } else {
        return;
      }

      await _firestore.collection(collectionPath).doc(userId).set({
        'fcm_token': FieldValue.delete(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  // Parses navigation destinations depending on details matching the notification tap payload
  Future<void> _handleNotificationTap(String payloadId) async {
    try {
      // Check if payload matches an Order.
      final doc = await _firestore.collection('orders').doc(payloadId).get();
      if (doc.exists && doc.data() != null) {
        final order = OrderModel.fromMap(doc.data()!, doc.id);

        if (_currentUserType == 'shop') {
          // Route shop owner to order detail page
          final bloc = sl<ShopOrdersBloc>();
          bloc.add(FetchShopOrdersEvent(order.items.first.shopId));
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: ShopOrderDetailsPage(
                  order: order,
                  shopId: order.items.first.shopId,
                  isCancelledView: false,
                ),
              ),
            ),
            (route) => route.isFirst,
          );
        } else {
          // Route customer to order detail page
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<OrdersBloc>()..add(FetchOrders()),
                child: OrderDetailsPage(order: order),
              ),
            ),
            (route) => route.isFirst,
          );
        }
        return;
      }

      // Check if payload matches a Product (e.g. wishlist restocks)
      final productDoc = await _firestore
          .collection('products')
          .doc(payloadId)
          .get();
      if (productDoc.exists && productDoc.data() != null) {
        final product = ProductModel.fromMap(productDoc.data()!, productDoc.id);
        final shopDoc = await _firestore
            .collection('shops')
            .doc(product.shopId)
            .get();
        if (shopDoc.exists && shopDoc.data() != null) {
          final shop = ShopProfileModel.fromMap(shopDoc.data()!, shopDoc.id);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) =>
                  CustomerProductDetailPage(product: product, shop: shop),
            ),
            (route) => route.isFirst,
          );
          return;
        }
      }

      _navigateToNotificationsPage();
    } catch (_) {
      _navigateToNotificationsPage();
    }
  }

  // Fallback router matching user profiles when payload structure is not standard
  void _navigateToNotificationsPage() {
    try {
      if (_currentUserType == 'shop') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ShopNotificationsPage()),
        );
      } else if (_currentUserType == 'customer') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const CustomerNotificationsPage()),
        );
      } else if (_currentUserType == 'admin') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<AdminNotificationsBloc>(),
              child: const AdminNotificationsPage(),
            ),
          ),
        );
      }
    } catch (_) {}
  }
}
