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
  }

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
      // Reload
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
}
