import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/get_shop_orders.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_status.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_return_status.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/process_refund.dart';
import 'package:street_cart/core/services/razorpay_service.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/get_shop_profile_data.dart';
part 'shop_orders_event.dart';
part 'shop_orders_state.dart';

class ShopOrdersBloc extends Bloc<ShopOrdersEvent, ShopOrdersState> {
  final GetShopOrders getShopOrders;
  final UpdateShopOrderStatus updateShopOrderStatus;
  final UpdateShopOrderReturnStatus updateShopOrderReturnStatus;
  final ProcessRefund processRefund;
  final RazorpayService razorpayService;
  final GetShopProfileData getShopProfileData;

  ShopOrdersBloc({
    required this.getShopOrders,
    required this.updateShopOrderStatus,
    required this.updateShopOrderReturnStatus,
    required this.processRefund,
    required this.razorpayService,
    required this.getShopProfileData,
  }) : super(const ShopOrdersState()) {
    // Fetch orders
    on<FetchShopOrdersEvent>(_onFetchShopOrders);

    // Updates order status
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);

    // Updates return status
    on<UpdateOrderReturnStatusEvent>(_onUpdateOrderReturnStatus);

    // Toggles the COD cash payment received checkbox
    on<TogglePaymentReceivedEvent>((event, emit) {
      emit(state.copyWith(isPaymentReceived: event.isReceived));
    });

    // Refund handlers
    on<InitiateRefundEvent>(_onInitiateRefund);
    on<CompleteRefundEvent>(_onCompleteRefund);
    on<RefundErrorEvent>(_onRefundError);
    on<ResetRefundStatusEvent>((event, emit) {
      emit(state.copyWith(refundStatus: 'initial', refundError: null));
    });
    on<ToggleRefundViaHandEvent>((event, emit) {
      emit(state.copyWith(isRefundViaHand: event.isChecked));
    });
  }

  // Fetch Shop Orders
  Future<void> _onFetchShopOrders(
    FetchShopOrdersEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    emit(state.copyWith(status: ShopOrdersStatus.loading));
    try {
      await emit.forEach<List>(
        getShopOrders(event.shopId),
        onData: (orders) => state.copyWith(
          status: ShopOrdersStatus.loaded,
          orders: orders.cast(),
        ),
        onError: (error, _) => state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Update Order Status
  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await updateShopOrderStatus(event.orderId, event.newStatus);
      // Reset payment received state
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Update Order Return Status
  Future<void> _onUpdateOrderReturnStatus(
    UpdateOrderReturnStatusEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await updateShopOrderReturnStatus(
        event.orderId,
        event.newReturnStatus,
        refundViaHand: event.refundViaHand,
        refundAmount: event.refundAmount,
      );
      emit(state.copyWith(isRefundViaHand: false));
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Initiate Refund
  Future<void> _onInitiateRefund(
    InitiateRefundEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    emit(state.copyWith(refundStatus: 'processing', refundError: null));

    try {
      final shopProfile = await getShopProfileData();
      final prefillContact =
          (shopProfile != null && shopProfile.phone.trim().isNotEmpty)
          ? shopProfile.phone.trim()
          : '';
      final prefillEmail =
          (shopProfile != null && shopProfile.email.trim().isNotEmpty)
          ? shopProfile.email.trim()
          : 'shop@streetcart@gmail.com';
      // Initialize Razorpay listeners
      razorpayService.initialize(
        onSuccess: (response) {
          add(
            CompleteRefundEvent(
              orderId: event.orderId,
              refundAmount: event.refundAmount,
              refundStatus: 'refunded',
            ),
          );
        },
        onFailure: (response) {
          final errorMsg =
              response.message ?? 'Refund transaction failed or cancelled';
          add(RefundErrorEvent(errorMsg));
        },
        onExternalWallet: (response) {
          add(
            CompleteRefundEvent(
              orderId: event.orderId,
              refundAmount: event.refundAmount,
              refundStatus: 'refunded',
            ),
          );
        },
      );

      razorpayService.openCheckout(
        amount: event.refundAmount,
        name: 'Street Cart Refund',
        description: 'Returned Order Refund processing',
        contact: prefillContact,
        email: prefillEmail,
      );
    } catch (e) {
      emit(state.copyWith(refundStatus: 'failure', refundError: e.toString()));
    }
  }

  // Complete Refund update
  Future<void> _onCompleteRefund(
    CompleteRefundEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await processRefund(
        event.orderId,
        event.refundAmount,
        event.refundStatus,
      );
      emit(state.copyWith(refundStatus: 'success', refundError: null));
    } catch (e) {
      emit(state.copyWith(refundStatus: 'failure', refundError: e.toString()));
    }
  }

  // Handle Refund Errors
  void _onRefundError(RefundErrorEvent event, Emitter<ShopOrdersState> emit) {
    emit(
      state.copyWith(refundStatus: 'failure', refundError: event.errorMessage),
    );
  }

  @override
  Future<void> close() {
    razorpayService.clear();
    return super.close();
  }
}
