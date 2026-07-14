import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:street_cart/core/services/razorpay_service.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/payment/domain/usecases/place_customer_order.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PlaceCustomerOrder placeCustomerOrder;
  final RazorpayService razorpayService;
  final GetProfileData getProfileData;

  List<CartItem>? _currentItems;
  AddressModel? _currentAddress;
  double? _currentTotalAmount;

  PaymentBloc({
    required this.placeCustomerOrder,
    required this.razorpayService,
    required this.getProfileData,
  }) : super(PaymentInitial()) {
    on<InitiateRazorpayPayment>(_onInitiateRazorpayPayment);
    on<CompleteOrderWithCOD>(_onCompleteOrderWithCOD);
    on<PaymentCompletedInternal>(_onPaymentCompletedInternal);
    on<ProcessPaymentPlacement>(_onProcessPaymentPlacement);

    // Initialize Razorpay listeners
    razorpayService.initialize(
      onSuccess: (response) => _onSuccessfulOnlinePayment(),
      onFailure: _handlePaymentFailure,
      onExternalWallet: (response) => _onSuccessfulOnlinePayment(),
    );
  }

  Future<void> _onInitiateRazorpayPayment(
    InitiateRazorpayPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    _currentItems = event.items;
    _currentAddress = event.address;
    _currentTotalAmount = event.totalAmount;

    try {
      final profile = await getProfileData();
      final email = (profile != null && profile.email.isNotEmpty)
          ? profile.email
          : 'customer@streetcart.com';

      razorpayService.openCheckout(
        amount: event.totalAmount,
        name: 'Street Cart',
        description:
            'Secure payment for your multi-vendor marketplace purchase.',
        contact: event.contact,
        email: email,
      );
    } catch (e) {
      emit(PaymentFailure('Failed to open payment gateway: $e'));
    }
  }

  Future<void> _onCompleteOrderWithCOD(
    CompleteOrderWithCOD event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentOrderCreating('Cash on Delivery'));
    try {
      final orderId = await placeCustomerOrder(
        items: event.items,
        address: event.address,
        paymentMethod: 'Cash on Delivery',
        paymentStatus: 'Pending',
        totalAmount: event.totalAmount,
      );

      emit(
        PaymentSuccess(
          paymentMethod: 'Cash on Delivery',
          paymentStatus: 'Pending',
          orderId: orderId,
        ),
      );
    } catch (e) {
      emit(PaymentFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onProcessPaymentPlacement(
    ProcessPaymentPlacement event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentOrderCreating(event.paymentMethod));
    if (_currentItems == null ||
        _currentAddress == null ||
        _currentTotalAmount == null) {
      emit(
        const PaymentFailure(
          'Payment session checkout parameters are missing.',
        ),
      );
      return;
    }

    try {
      final orderId = await placeCustomerOrder(
        items: _currentItems!,
        address: _currentAddress!,
        paymentMethod: event.paymentMethod,
        paymentStatus: event.paymentStatus,
        totalAmount: _currentTotalAmount!,
      );
      emit(
        PaymentSuccess(
          paymentMethod: event.paymentMethod,
          paymentStatus: event.paymentStatus,
          orderId: orderId,
        ),
      );
    } catch (e) {
      emit(PaymentFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onPaymentCompletedInternal(
    PaymentCompletedInternal event,
    Emitter<PaymentState> emit,
  ) async {
    if (event.errorMessage != null) {
      emit(PaymentFailure(event.errorMessage!));
    }
  }

  void _onSuccessfulOnlinePayment() {
    add(
      const ProcessPaymentPlacement(
        paymentMethod: 'Online Payment',
        paymentStatus: 'Paid',
      ),
    );
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    String errorMsg = response.message ?? 'Payment failed or cancelled';
    if (errorMsg.trim().toLowerCase() == 'undefined' ||
        errorMsg.trim().isEmpty) {
      errorMsg = 'Your Payment was cancelled';
    }
    add(
      PaymentCompletedInternal(
        paymentMethod: 'Online Payment',
        paymentStatus: 'Failed',
        errorMessage: errorMsg,
      ),
    );
  }

  @override
  Future<void> close() {
    razorpayService.clear();
    return super.close();
  }
}
