import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_shop_details.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/approve_shop.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/reject_shop.dart';
import 'admin_registration_details_event.dart';
import 'admin_registration_details_state.dart';

class AdminRegistrationDetailsBloc
    extends Bloc<AdminRegistrationDetailsEvent, AdminRegistrationDetailsState> {
  final GetShopDetails getShopDetails;
  final ApproveShop approveShop;
  final RejectShop rejectShop;

  AdminRegistrationDetailsBloc({
    required this.getShopDetails,
    required this.approveShop,
    required this.rejectShop,
  }) : super(AdminRegistrationDetailsInitial()) {
    // Load Shop Details
    on<LoadShopDetailsRequested>((event, emit) async {
      emit(AdminRegistrationDetailsLoading());
      try {
        final shop = await getShopDetails(event.shopId);
        emit(AdminRegistrationDetailsLoadSuccess(shop));
      } catch (e) {
        emit(AdminRegistrationDetailsLoadFailure(e.toString()));
      }
    });
    // Approve Shop Requested
    on<ApproveShopRequested>((event, emit) async {
      emit(AdminRegistrationActionInProgress());
      try {
        await approveShop(event.shopId);
        emit(
          const AdminRegistrationActionSuccess(
            'Shop approved successfully',
            approved: true,
          ),
        );
      } catch (e) {
        emit(AdminRegistrationActionFailure(e.toString()));
      }
    });
    // Reject Shop Requested
    on<RejectShopRequested>((event, emit) async {
      emit(AdminRegistrationActionInProgress());
      try {
        await rejectShop(event.shopId, event.rejectionReason);
        emit(
          const AdminRegistrationActionSuccess(
            'Shop application rejected successfully',
            approved: false,
          ),
        );
      } catch (e) {
        emit(AdminRegistrationActionFailure(e.toString()));
      }
    });
  }
}
