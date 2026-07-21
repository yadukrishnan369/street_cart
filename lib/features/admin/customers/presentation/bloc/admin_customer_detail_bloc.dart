import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customer_details.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/toggle_customer_status.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/delete_customer.dart';
import 'admin_customer_detail_event.dart';
import 'admin_customer_detail_state.dart';

class AdminCustomerDetailBloc
    extends Bloc<AdminCustomerDetailEvent, AdminCustomerDetailState> {
  final GetAdminCustomerDetails _getCustomerDetails;
  final ToggleCustomerBlockStatus _toggleBlockStatus;
  final DeleteCustomer _deleteCustomer;

  AdminCustomerDetailBloc({
    required GetAdminCustomerDetails getCustomerDetails,
    required ToggleCustomerBlockStatus toggleBlockStatus,
    required DeleteCustomer deleteCustomer,
  }) : _getCustomerDetails = getCustomerDetails,
       _toggleBlockStatus = toggleBlockStatus,
       _deleteCustomer = deleteCustomer,
       super(AdminCustomerDetailInitial()) {
    on<LoadCustomerDetailRequested>(_onLoadCustomerDetail);
    on<ToggleBlockStatusRequested>(_onToggleBlockStatus);
    on<DeleteCustomerRequested>(_onDeleteCustomer);
    on<ChangePastOrdersPageRequested>(_onChangePastOrdersPage);
  }

  // Fetching customer profile details
  Future<void> _onLoadCustomerDetail(
    LoadCustomerDetailRequested event,
    Emitter<AdminCustomerDetailState> emit,
  ) async {
    emit(AdminCustomerDetailLoading());
    try {
      final response = await _getCustomerDetails(event.uid);
      emit(
        AdminCustomerDetailLoaded(
          customer: response.customer,
          addresses: response.addresses,
          orders: response.orders,
        ),
      );
    } catch (e) {
      emit(AdminCustomerDetailError(e.toString()));
    }
  }

  // Updating the customer block/unblock status
  Future<void> _onToggleBlockStatus(
    ToggleBlockStatusRequested event,
    Emitter<AdminCustomerDetailState> emit,
  ) async {
    emit(AdminCustomerDetailActionInProgress());
    try {
      await _toggleBlockStatus(
        ToggleCustomerBlockStatusParams(
          uid: event.uid,
          isBlocked: event.isBlocked,
        ),
      );
      emit(
        AdminCustomerDetailActionSuccess(
          event.isBlocked
              ? 'Customer blocked successfully'
              : 'Customer unblocked successfully',
        ),
      );
      // Reload updated info
      final response = await _getCustomerDetails(event.uid);
      emit(
        AdminCustomerDetailLoaded(
          customer: response.customer,
          addresses: response.addresses,
          orders: response.orders,
        ),
      );
    } catch (e) {
      emit(AdminCustomerDetailError(e.toString()));
    }
  }

  // Customer profile Delete
  Future<void> _onDeleteCustomer(
    DeleteCustomerRequested event,
    Emitter<AdminCustomerDetailState> emit,
  ) async {
    emit(AdminCustomerDetailActionInProgress());
    try {
      await _deleteCustomer(event.uid);
      emit(AdminCustomerDetailActionSuccess('Customer deleted successfully'));
    } catch (e) {
      emit(AdminCustomerDetailError(e.toString()));
    }
  }

  // Changing the current page number
  void _onChangePastOrdersPage(
    ChangePastOrdersPageRequested event,
    Emitter<AdminCustomerDetailState> emit,
  ) {
    final currentState = state;
    if (currentState is AdminCustomerDetailLoaded) {
      emit(currentState.copyWith(currentPage: event.page));
    }
  }
}
