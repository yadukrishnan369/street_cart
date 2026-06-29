import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/customer/products/domain/usecases/add_to_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/remove_from_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/clear_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;
  final GetWishlist getWishlist;
  final ClearWishlist clearWishlist;
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;

  WishlistBloc({
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.getWishlist,
    required this.clearWishlist,
    required FirebaseAuth auth,
  }) : _auth = auth,
       super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddProductToWishlist>(_onAddProductToWishlist);
    on<RemoveProductFromWishlist>(_onRemoveProductFromWishlist);
    on<ClearAllWishlist>(_onClearAllWishlist);
    on<ResetWishlistState>(
      (event, emit) => emit(WishlistLoaded(items: const [])),
    );

    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        add(LoadWishlist());
      } else {
        add(ResetWishlistState());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      final items = await getWishlist();
      emit(WishlistLoaded(items: items));
    } catch (e, stack) {
      AppLogger.error('Failed to load wishlist', e, stack);
      emit(WishlistError(message: 'Failed to load wishlist: $e'));
    }
  }

  Future<void> _onAddProductToWishlist(
    AddProductToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      final itemExists = currentState.items.any(
        (item) => item.product.id == event.product.id,
      );
      if (!itemExists) {
        final optimisticallyAddedItems = List<WishlistItem>.from(
          currentState.items,
        )..insert(0, WishlistItem(product: event.product, shop: event.shop));
        emit(WishlistLoaded(items: optimisticallyAddedItems));
      }

      try {
        await addToWishlist(event.product, event.shop);
        final syncedItems = await getWishlist();
        emit(WishlistLoaded(items: syncedItems));
      } catch (e, stack) {
        AppLogger.error('Failed to add product to wishlist', e, stack);
        emit(currentState);
        emit(WishlistError(message: 'Failed to add to wishlist: $e'));
      }
    } else {
      try {
        await addToWishlist(event.product, event.shop);
        add(LoadWishlist());
      } catch (e, stack) {
        AppLogger.error('Failed to add product to wishlist', e, stack);
        emit(WishlistError(message: 'Failed to add to wishlist: $e'));
      }
    }
  }

  Future<void> _onRemoveProductFromWishlist(
    RemoveProductFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      final optimisticallyRemovedItems = currentState.items
          .where((item) => item.product.id != event.productId)
          .toList();
      emit(WishlistLoaded(items: optimisticallyRemovedItems));

      try {
        await removeFromWishlist(event.productId);
      } catch (e, stack) {
        AppLogger.error('Failed to remove product from wishlist', e, stack);
        emit(currentState);
        emit(WishlistError(message: 'Failed to remove from wishlist: $e'));
      }
    } else {
      try {
        await removeFromWishlist(event.productId);
        add(LoadWishlist());
      } catch (e, stack) {
        AppLogger.error('Failed to remove product from wishlist', e, stack);
        emit(WishlistError(message: 'Failed to remove from wishlist: $e'));
      }
    }
  }

  Future<void> _onClearAllWishlist(
    ClearAllWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      await clearWishlist();
      emit(WishlistLoaded(items: const []));
    } catch (e, stack) {
      AppLogger.error('Failed to clear wishlist', e, stack);
      emit(WishlistError(message: 'Failed to clear wishlist.'));
    }
  }
}
