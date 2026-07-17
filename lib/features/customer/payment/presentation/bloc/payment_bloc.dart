import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:street_cart/core/services/razorpay_service.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/payment/domain/usecases/place_customer_order.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'package:street_cart/core/utils/delivery_validator.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PlaceCustomerOrder placeCustomerOrder;
  final RazorpayService razorpayService;
  final GetProfileData getProfileData;
  final DeliveryValidator deliveryValidator;

  List<CartItem>? _currentItems;
  AddressModel? _currentAddress;
  double? _currentTotalAmount;

  PaymentBloc({
    required this.placeCustomerOrder,
    required this.razorpayService,
    required this.getProfileData,
    required this.deliveryValidator,
  }) : super(PaymentInitial()) {
    on<InitiateRazorpayPayment>(_onInitiateRazorpayPayment);
    on<CompleteOrderWithCOD>(_onCompleteOrderWithCOD);
    on<PaymentCompletedInternal>(_onPaymentCompletedInternal);
    on<ProcessPaymentPlacement>(_onProcessPaymentPlacement);
    on<UpdatePaymentOverlayPhase>(_onUpdateOverlayPhase);

    // Initialize Razorpay listeners
    razorpayService.initialize(
      onSuccess: (response) => _onSuccessfulOnlinePayment(),
      onFailure: _handlePaymentFailure,
      onExternalWallet: (response) => _onSuccessfulOnlinePayment(),
    );
  }

  // Initiate Razorpay payment
  Future<void> _onInitiateRazorpayPayment(
    InitiateRazorpayPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    _currentItems = event.items;
    _currentAddress = event.address;
    _currentTotalAmount = event.totalAmount;

    try {
      final shopIds = event.items.map((e) => e.shopId).toSet().toList();
      final validatedAddress = await deliveryValidator.validateAddress(
        address: event.address,
        shopIds: shopIds,
      );
      _currentAddress = validatedAddress;

      final profile = await getProfileData();
      final email = (profile != null && profile.email.isNotEmpty)
          ? profile.email
          : 'customer@streetcart.com';
      // Open Razorpay Checkout Overlay
      razorpayService.openCheckout(
        amount: event.totalAmount,
        name: 'Street Cart',
        description:
            'Secure payment for your multi-vendor marketplace purchase.',
        contact: event.contact,
        email: email,
      );
    } catch (e) {
      emit(PaymentFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Complete Order via Cash on Delivery
  Future<void> _onCompleteOrderWithCOD(
    CompleteOrderWithCOD event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    try {
      final shopIds = event.items.map((e) => e.shopId).toSet().toList();
      final validatedAddress = await deliveryValidator.validateAddress(
        address: event.address,
        shopIds: shopIds,
      );

      emit(const PaymentOrderCreating('Cash on Delivery'));

      final orderId = await placeCustomerOrder(
        items: event.items,
        address: validatedAddress,
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
      // place order
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

  void _onUpdateOverlayPhase(
    UpdatePaymentOverlayPhase event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentOverlayPhase(isLoading: event.isLoading, phase: event.phase));
  }

  void _onSuccessfulOnlinePayment() {
    add(
      const ProcessPaymentPlacement(
        paymentMethod: 'Online Payment',
        paymentStatus: 'Paid',
      ),
    );
  }

  // Handle Razorpay Failure and Cancelled
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
