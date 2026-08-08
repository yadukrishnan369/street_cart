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
    on<ValidateCartForCheckout>(_onValidateCartForCheckout);
    on<RefreshCartAvailability>(_onRefreshCartAvailability);
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

  // Fetches items in cart and check unavailable IDs
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCart();
      final unavailableIds = items.isNotEmpty
          ? await _computeUnavailableIds(items)
          : const <String>{};
      final unviewableIds = items.isNotEmpty
          ? await _computeUnviewableIds(items)
          : const <String>{};
      emit(
        CartLoaded(
          items: items,
          unavailableItemIds: unavailableIds,
          unviewableItemIds: unviewableIds,
        ),
      );
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
    Set<String> existingUnavailableIds = {};
    Set<String> existingUnviewableIds = {};
    if (currentState is CartLoaded) {
      currentItems = currentState.items;
      existingUnavailableIds = currentState.unavailableItemIds;
      existingUnviewableIds = currentState.unviewableItemIds;
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
        emit(
          CartLoaded(
            items: updatedList,
            unavailableItemIds: existingUnavailableIds,
            unviewableItemIds: existingUnviewableIds,
          ),
        );

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
        emit(
          CartLoaded(
            items: updatedList,
            unavailableItemIds: existingUnavailableIds,
            unviewableItemIds: existingUnviewableIds,
          ),
        );

        await addToCartUsecase(newItem);
      }

      final items = await getCart();
      emit(
        CartLoaded(
          items: items,
          unavailableItemIds: existingUnavailableIds,
          unviewableItemIds: existingUnviewableIds,
        ),
      );
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
      final unavailableIds = currentState.unavailableItemIds;
      final unviewableIds = currentState.unviewableItemIds;
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
                  unavailableItemIds: unavailableIds,
                  unviewableItemIds: unviewableIds,
                ),
              );
              return;
            }
          } catch (e) {
            emit(
              CartItemUpdateError(
                items: currentItems,
                errorMessage: e.toString(),
                unavailableItemIds: unavailableIds,
                unviewableItemIds: unviewableIds,
              ),
            );
            return;
          }
        }

        final List<CartItem> updatedList = List.from(currentItems);
        updatedList[index] = updatedList[index].copyWith(
          quantity: event.quantity,
        );
        emit(
          CartLoaded(
            items: updatedList,
            isSummaryVisible: currentState.isSummaryVisible,
            unavailableItemIds: unavailableIds,
            unviewableItemIds: unviewableIds,
          ),
        );

        try {
          await updateCartQuantity(event.itemId, event.quantity);
          final items = await getCart();
          emit(
            CartLoaded(
              items: items,
              isSummaryVisible: currentState.isSummaryVisible,
              unavailableItemIds: unavailableIds,
              unviewableItemIds: unviewableIds,
            ),
          );
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
      final unavailableIds = currentState.unavailableItemIds;
      final unviewableIds = currentState.unviewableItemIds;
      final List<CartItem> updatedList = currentItems
          .where((item) => item.id != event.itemId)
          .toList();
      // remove the deleted item from unavailable/unviewable collection
      final updatedUnavailable = Set<String>.from(unavailableIds)
        ..remove(event.itemId);
      final updatedUnviewable = Set<String>.from(unviewableIds)
        ..remove(event.itemId);
      emit(
        CartLoaded(
          items: updatedList,
          isSummaryVisible: currentState.isSummaryVisible,
          unavailableItemIds: updatedUnavailable,
          unviewableItemIds: updatedUnviewable,
        ),
      );

      try {
        await removeFromCartUsecase(event.itemId);
        final items = await getCart();
        emit(
          CartLoaded(
            items: items,
            isSummaryVisible: currentState.isSummaryVisible,
            unavailableItemIds: updatedUnavailable,
            unviewableItemIds: updatedUnviewable,
          ),
        );
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

  // validates each cart item for stock/availability
  Future<void> _onValidateCartForCheckout(
    ValidateCartForCheckout event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;
    final currentItems = currentState.items;
    final bool summaryVisible = currentState.isSummaryVisible;
    final existingUnavailableIds = currentState.unavailableItemIds;

    emit(
      CartCheckoutValidating(
        items: currentItems,
        isSummaryVisible: summaryVisible,
        unavailableItemIds: existingUnavailableIds,
      ),
    );

    final List<String> invalidReasons = [];
    final Set<String> invalidItemIds = {};

    for (final item in currentItems) {
      try {
        final product = await getProductById(item.productId);

        // Product is deleted by shop or admin
        if (!product.isActive) {
          invalidReasons.add('"${item.productName}" is no longer available.');
          invalidItemIds.add(item.id);
          continue;
        }

        // Product is disabled by admin
        if (product.disabledByAdmin) {
          invalidReasons.add(
            '"${item.productName}" is currently unavailable and cannot be purchased.',
          );
          invalidItemIds.add(item.id);
          continue;
        }

        // Variant-based stock check
        if (product.hasVariants) {
          final color = item.selectedColor;
          final size = item.selectedSize;

          if (color == null || color.isEmpty) {
            invalidReasons.add(
              '"${item.productName}" requires a color selection that is no longer valid.',
            );
            invalidItemIds.add(item.id);
            continue;
          }
          if (size == null || size.isEmpty) {
            invalidReasons.add(
              '"${item.productName}" requires a size selection that is no longer valid.',
            );
            invalidItemIds.add(item.id);
            continue;
          }

          // Check if color variant still exists
          final colorExists = product.variants.any((v) => v.colorName == color);
          if (!colorExists) {
            invalidReasons.add(
              '"${item.productName}" — color "$color" is no longer available.',
            );
            invalidItemIds.add(item.id);
            continue;
          }

          final variantStock = product.stockForVariant(color, size);
          if (variantStock <= 0) {
            invalidReasons.add(
              '"${item.productName}" ($color / $size) is out of stock.',
            );
            invalidItemIds.add(item.id);
            continue;
          }

          if (item.quantity > variantStock) {
            invalidReasons.add(
              '"${item.productName}" ($color / $size) — only $variantStock left in stock.',
            );
            invalidItemIds.add(item.id);
            continue;
          }
        } else {
          // Simple stock check
          if (product.stockQuantity <= 0) {
            invalidReasons.add('"${item.productName}" is out of stock.');
            invalidItemIds.add(item.id);
            continue;
          }
          if (item.quantity > product.stockQuantity) {
            invalidReasons.add(
              '"${item.productName}" — only ${product.stockQuantity} left in stock.',
            );
            invalidItemIds.add(item.id);
            continue;
          }
        }
      } catch (_) {
        invalidReasons.add(
          '"${item.productName}" could not be verified. Please try again.',
        );
        invalidItemIds.add(item.id);
      }
    }

    final Set<String> unviewableItemIds = {};
    for (final item in currentItems) {
      try {
        final product = await getProductById(item.productId);
        if (!product.isActive || product.disabledByAdmin) {
          unviewableItemIds.add(item.id);
        }
      } catch (_) {
        unviewableItemIds.add(item.id);
      }
    }

    if (invalidReasons.isEmpty) {
      emit(
        CartCheckoutReady(
          items: currentItems,
          isSummaryVisible: summaryVisible,
          unavailableItemIds: const {},
          unviewableItemIds: const {},
        ),
      );
    } else {
      emit(
        CartCheckoutInvalid(
          items: currentItems,
          reasons: invalidReasons,
          unavailableItemIds: invalidItemIds,
          unviewableItemIds: unviewableItemIds,
          isSummaryVisible: summaryVisible,
        ),
      );
    }
  }

  // Fetch the cart item IDs that are unavailable
  Future<Set<String>> _computeUnavailableIds(List<CartItem> items) async {
    final Set<String> unavailableIds = {};
    for (final item in items) {
      try {
        final product = await getProductById(item.productId);

        if (!product.isActive || product.disabledByAdmin) {
          unavailableIds.add(item.id);
          continue;
        }

        if (product.hasVariants) {
          final color = item.selectedColor;
          final size = item.selectedSize;
          if (color == null || color.isEmpty || size == null || size.isEmpty) {
            unavailableIds.add(item.id);
            continue;
          }
          final colorExists = product.variants.any((v) => v.colorName == color);
          if (!colorExists) {
            unavailableIds.add(item.id);
            continue;
          }
          final variantStock = product.stockForVariant(color, size);
          if (variantStock <= 0 || item.quantity > variantStock) {
            unavailableIds.add(item.id);
            continue;
          }
        } else {
          if (product.stockQuantity <= 0 ||
              item.quantity > product.stockQuantity) {
            unavailableIds.add(item.id);
            continue;
          }
        }
      } catch (_) {}
    }
    return unavailableIds;
  }

  // Fetch the cart item IDs that cannot be viewed
  Future<Set<String>> _computeUnviewableIds(List<CartItem> items) async {
    final Set<String> unviewableIds = {};
    for (final item in items) {
      try {
        final product = await getProductById(item.productId);
        if (!product.isActive || product.disabledByAdmin) {
          unviewableIds.add(item.id);
        }
      } catch (_) {
        unviewableIds.add(item.id);
      }
    }
    return unviewableIds;
  }

  // For refresh cart page items
  Future<void> _onRefreshCartAvailability(
    RefreshCartAvailability event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;
    final unavailableIds = await _computeUnavailableIds(currentState.items);
    final unviewableIds = await _computeUnviewableIds(currentState.items);
    final latestState = state;
    if (latestState is CartLoaded) {
      emit(
        CartLoaded(
          items: latestState.items,
          isSummaryVisible: latestState.isSummaryVisible,
          unavailableItemIds: unavailableIds,
          unviewableItemIds: unviewableIds,
        ),
      );
    }
  }
}
