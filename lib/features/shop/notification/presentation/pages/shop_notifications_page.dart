import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_event.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_state.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_returned_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/products/presentation/pages/product_detail_page.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/widgets/shop_notification_list.dart';

// Shop Notifications Page
class ShopNotificationsPage extends StatelessWidget {
  const ShopNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark
        ? ShopAppColors.darkTextPrimary
        : ShopAppColors.textPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () => Navigator.pop(context),
        ),
        // Page Title
        title: Text(
          'Notifications',
          style: ShopAppTextStyles.heading3.copyWith(color: titleColor),
        ),
        actions: [
          // Read all notification
          BlocBuilder<ShopNotificationsBloc, ShopNotificationsState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () {
                    context.read<ShopNotificationsBloc>().add(
                      MarkAllShopAsReadEvent(state.shopId),
                    );
                  },
                  icon: const Icon(
                    Icons.done_all,
                    size: 16,
                    color: ShopAppColors.primary,
                  ),
                  label: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: ShopAppColors.primary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<ShopNotificationsBloc, ShopNotificationsState>(
        listenWhen: (previous, current) =>
            previous.selectedOrder != current.selectedOrder ||
            previous.selectedProduct != current.selectedProduct ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == ShopNotificationsStatus.orderLoaded &&
              state.selectedOrder != null) {
            final order = state.selectedOrder!;
            final isReturn = state.isReturnOrder;
            final notifId = state.selectedNotificationId;
            if (notifId != null) {
              context.read<ShopNotificationsBloc>().add(
                MarkShopAsReadEvent(
                  shopId: state.shopId,
                  notificationId: notifId,
                ),
              );
              context.read<ShopNotificationsBloc>().add(
                DeleteShopNotificationEvent(
                  shopId: state.shopId,
                  notificationId: notifId,
                ),
              );
            }
            context.read<ShopNotificationsBloc>().add(
              const ClearShopSelectedOrderEvent(),
            );
            final ordersBloc = sl<ShopOrdersBloc>();
            ordersBloc.add(FetchShopOrdersEvent(state.shopId));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: ordersBloc,
                  child: isReturn
                      // Navigate to Shop Order Returned Details Page
                      ? ShopOrderReturnedDetailsPage(
                          order: order,
                          shopId: state.shopId,
                        )
                      // Navigate to Shop Order Details Page
                      : ShopOrderDetailsPage(
                          order: order,
                          shopId: state.shopId,
                          isCancelledView: false,
                        ),
                ),
              ),
              (route) => route.isFirst,
            );
          } else if (state.status == ShopNotificationsStatus.productLoaded &&
              state.selectedProduct != null) {
            final product = state.selectedProduct!;
            final notifId = state.selectedNotificationId;
            if (notifId != null) {
              context.read<ShopNotificationsBloc>().add(
                MarkShopAsReadEvent(
                  shopId: state.shopId,
                  notificationId: notifId,
                ),
              );
              context.read<ShopNotificationsBloc>().add(
                DeleteShopNotificationEvent(
                  shopId: state.shopId,
                  notificationId: notifId,
                ),
              );
            }
            context.read<ShopNotificationsBloc>().add(
              const ClearShopSelectedProductEvent(),
            );
            final productsBloc = sl<ShopProductsBloc>();
            Navigator.push(
              context,
              MaterialPageRoute(
                // Navigate to Product Detail Page
                builder: (_) => ProductDetailPage(
                  product: product,
                  shopId: state.shopId,
                  productsBloc: productsBloc,
                ),
              ),
            );
          } else if ((state.status == ShopNotificationsStatus.orderError ||
                  state.status == ShopNotificationsStatus.productError) &&
              state.errorMessage != null) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage!,
              isError: true,
            );
          }
        },
        // Shop Notification List
        child: const ShopNotificationList(),
      ),
    );
  }
}
