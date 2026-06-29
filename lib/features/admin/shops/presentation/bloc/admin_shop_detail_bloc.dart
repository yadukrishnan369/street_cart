import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop_details.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/delete_shop.dart';
import 'admin_shop_detail_event.dart';
import 'admin_shop_detail_state.dart';

class AdminShopDetailBloc
    extends Bloc<AdminShopDetailEvent, AdminShopDetailState> {
  final GetAdminShopDetails _getAdminShopDetails;
  final ToggleShopSuspension _toggleShopSuspension;
  final DeleteShop _deleteShop;
  final IAdminShopRepository _shopRepository;

  AdminShopDetailBloc({
    required GetAdminShopDetails getAdminShopDetails,
    required ToggleShopSuspension toggleShopSuspension,
    required DeleteShop deleteShop,
    required IAdminShopRepository shopRepository,
  }) : _getAdminShopDetails = getAdminShopDetails,
       _toggleShopSuspension = toggleShopSuspension,
       _deleteShop = deleteShop,
       _shopRepository = shopRepository,
       super(AdminShopDetailInitial()) {
    on<LoadShopDetailRequested>(_onLoadShopDetail);
    on<ToggleShopSuspensionRequested>(_onToggleShopSuspension);
    on<DeleteShopRequested>(_onDeleteShop);
  }

  Future<void> _onLoadShopDetail(
    LoadShopDetailRequested event,
    Emitter<AdminShopDetailState> emit,
  ) async {
    emit(AdminShopDetailLoading());
    try {
      final results = await Future.wait([
        _getAdminShopDetails(event.shopId),
        _shopRepository.getShopProducts(event.shopId),
      ]);
      emit(AdminShopDetailLoaded(results[0] as dynamic, results[1] as dynamic));
    } catch (e) {
      emit(AdminShopDetailError(e.toString()));
    }
  }

  Future<void> _onToggleShopSuspension(
    ToggleShopSuspensionRequested event,
    Emitter<AdminShopDetailState> emit,
  ) async {
    emit(AdminShopDetailActionInProgress());
    try {
      await _toggleShopSuspension(
        ToggleShopSuspensionParams(
          shopId: event.shopId,
          isSuspended: event.isSuspended,
        ),
      );
      emit(
        AdminShopDetailActionSuccess(
          event.isSuspended
              ? 'Shop suspended successfully'
              : 'Shop activated successfully',
        ),
      );
      // Reload shop details + products
      final results = await Future.wait([
        _getAdminShopDetails(event.shopId),
        _shopRepository.getShopProducts(event.shopId),
      ]);
      emit(AdminShopDetailLoaded(results[0] as dynamic, results[1] as dynamic));
    } catch (e) {
      emit(AdminShopDetailError(e.toString()));
    }
  }

  Future<void> _onDeleteShop(
    DeleteShopRequested event,
    Emitter<AdminShopDetailState> emit,
  ) async {
    emit(AdminShopDetailActionInProgress());
    try {
      await _deleteShop(event.shopId);
      emit(AdminShopDetailActionSuccess('Shop deleted successfully'));
    } catch (e) {
      emit(AdminShopDetailError(e.toString()));
    }
  }
}
