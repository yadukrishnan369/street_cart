import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/add_to_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/remove_from_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/update_cart_quantity.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/clear_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_product_by_id.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCartUsecase;
  final RemoveFromCart removeFromCartUsecase;
  final UpdateCartQuantity updateCartQuantity;
  final ClearCart clearCart;
  final GetProductById getProductById;
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;

  CartBloc({
    required this.getCart,
    required this.addToCartUsecase,
    required this.removeFromCartUsecase,
    required this.updateCartQuantity,
    required this.clearCart,
    required this.getProductById,
    required FirebaseAuth auth,
  }) : _auth = auth,
       super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItem>(_onRemoveItem);
    on<ClearAllCart>(_onClearAllCart);
    on<ClearLocalCart>(
      (event, emit) => emit(const CartLoaded(items: const [])),
    );
    on<ToggleSummaryVisibility>(_onToggleSummaryVisibility);

    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        add(LoadCart());
      } else {
        add(ClearLocalCart());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  // fetches items in cart
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCart();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // adds new product or increments existing quantity
  Future<void> _onAddProductToCart(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(const CartError(message: 'User is not logged in'));
      return;
    }

    final currentState = state;
    List<CartItem> currentItems = [];
    if (currentState is CartLoaded) {
      currentItems = currentState.items;
    }

    final product = event.product;
    final String itemId =
        '${product.id}_${event.selectedSize ?? ""}_${event.selectedColor ?? ""}';
    final existingIndex = currentItems.indexWhere((item) => item.id == itemId);

    try {
      if (existingIndex != -1) {
        final existingItem = currentItems[existingIndex];
        final updatedQty = existingItem.quantity + 1;

        final List<CartItem> updatedList = List.from(currentItems);
        updatedList[existingIndex] = existingItem.copyWith(
          quantity: updatedQty,
        );
        emit(CartLoaded(items: updatedList));

        await updateCartQuantity(itemId, updatedQty);
      } else {
        final CartItem newItem = CartItem(
          id: itemId,
          productId: product.id,
          productName: product.name,
          productImage: (event.selectedColor != null)
              ? product.imagesForColor(event.selectedColor!).firstOrNull ??
                    (product.displayImages.firstOrNull ?? '')
              : (product.displayImages.firstOrNull ?? ''),
          selectedSize: event.selectedSize,
          selectedColor: event.selectedColor,
          price: product.offerPrice ?? product.originalPrice,
          quantity: 1,
          shopId: product.shopId,
          addedAt: DateTime.now(),
        );

        final List<CartItem> updatedList = List.from(currentItems)
          ..insert(0, newItem);
        emit(CartLoaded(items: updatedList));

        await addToCartUsecase(newItem);
      }

      final items = await getCart();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
      add(LoadCart());
    }
  }

  // modifies quantity of an item
  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final currentItems = currentState.items;
      final index = currentItems.indexWhere((item) => item.id == event.itemId);
      if (index != -1) {
        final item = currentItems[index];

        if (event.quantity > item.quantity) {
          try {
            final product = await getProductById(item.productId);
            int availableStock = product.hasVariants
                ? ((item.selectedColor == null || item.selectedSize == null)
                      ? 0
                      : product.stockForVariant(
                          item.selectedColor!,
                          item.selectedSize!,
                        ))
                : product.stockQuantity;

            if (event.quantity > availableStock) {
              emit(
                CartItemUpdateError(
                  items: currentItems,
                  errorMessage:
                      'Only $availableStock items are available in stock',
                ),
              );
              return;
            }
          } catch (e) {
            emit(
              CartItemUpdateError(
                items: currentItems,
                errorMessage: e.toString(),
              ),
            );
            return;
          }
        }

        final List<CartItem> updatedList = List.from(currentItems);
        updatedList[index] = updatedList[index].copyWith(
          quantity: event.quantity,
        );
        emit(CartLoaded(items: updatedList));

        try {
          await updateCartQuantity(event.itemId, event.quantity);
          final items = await getCart();
          emit(CartLoaded(items: items));
        } catch (e) {
          emit(CartError(message: e.toString()));
          add(LoadCart());
        }
      }
    }
  }

  // deletes a specific item from the cart
  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final currentItems = currentState.items;
      final List<CartItem> updatedList = currentItems
          .where((item) => item.id != event.itemId)
          .toList();
      emit(CartLoaded(items: updatedList));

      try {
        await removeFromCartUsecase(event.itemId);
        final items = await getCart();
        emit(CartLoaded(items: items));
      } catch (e) {
        emit(CartError(message: e.toString()));
        add(LoadCart());
      }
    }
  }

  // removes all items from the customer cart
  Future<void> _onClearAllCart(
    ClearAllCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoaded(items: []));
    try {
      await clearCart();
      emit(const CartLoaded(items: []));
    } catch (e) {
      emit(CartError(message: e.toString()));
      add(LoadCart());
    }
  }

  // toggles showing order summary details
  void _onToggleSummaryVisibility(
    ToggleSummaryVisibility event,
    Emitter<CartState> emit,
  ) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isSummaryVisible: event.isVisible));
    }
  }
}
