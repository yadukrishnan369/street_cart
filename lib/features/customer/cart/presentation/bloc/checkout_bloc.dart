import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_shop_by_id.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetShopById getShopById;

  CheckoutBloc({required this.getShopById}) : super(CheckoutInitial()) {
    on<LoadCheckout>(_onLoadCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
  }

  Future<void> _onLoadCheckout(
    LoadCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      if (event.cartItems.isEmpty) {
        emit(
          const CheckoutLoaded(
            allowedPaymentMethods: ['UPI', 'COD'],
            selectedPaymentMethod: 'UPI',
          ),
        );
        return;
      }

      // Fetch shops for all items to check allowed payment methods
      final uniqueShopIds = event.cartItems
          .map((item) => item.shopId)
          .toSet()
          .toList();
      final List<List<String>> shopsPaymentMethods = [];

      for (final shopId in uniqueShopIds) {
        final shop = await getShopById(shopId);
        shopsPaymentMethods.add(
          shop.paymentMethods.map((e) => e.toUpperCase()).toList(),
        );
      }

      // If we cannot find any specific methods, using default to both as a fallback
      bool supportsCOD = true;
      bool supportsUPI = true;

      if (shopsPaymentMethods.isNotEmpty) {
        supportsCOD = shopsPaymentMethods.every(
          (methods) =>
              methods.isEmpty ||
              methods.any((m) => m.contains('COD') || m.contains('CASH')),
        );
        supportsUPI = shopsPaymentMethods.every(
          (methods) =>
              methods.isEmpty ||
              methods.any(
                (m) =>
                    m.contains('UPI') ||
                    m.contains('ONLINE') ||
                    m.contains('GPAY') ||
                    m.contains('GOOGLE'),
              ),
        );
      }

      final List<String> allowed = [];
      if (supportsUPI) allowed.add('UPI');
      if (supportsCOD) allowed.add('COD');

      // If both are disabled, default to at least COD so checkout is possible
      if (allowed.isEmpty) {
        allowed.addAll(['COD']);
      }

      emit(
        CheckoutLoaded(
          allowedPaymentMethods: allowed,
          selectedPaymentMethod: allowed.first,
        ),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<CheckoutState> emit,
  ) {
    if (state is CheckoutLoaded) {
      final loadedState = state as CheckoutLoaded;
      emit(loadedState.copyWith(selectedPaymentMethod: event.method));
    }
  }
}
