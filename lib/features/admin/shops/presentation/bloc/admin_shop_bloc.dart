import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop.dart';
import 'admin_shop_event.dart';
import 'admin_shop_state.dart';

class AdminShopBloc extends Bloc<AdminShopEvent, AdminShopState> {
  final GetAdminShop _getAdminShop;
  final ToggleShopSuspension _toggleShopSuspension;

  AdminShopBloc({
    required GetAdminShop getAdminShop,
    required ToggleShopSuspension toggleShopSuspension,
  }) : _getAdminShop = getAdminShop,
       _toggleShopSuspension = toggleShopSuspension,
       super(AdminShopInitial()) {
    on<LoadAdminShop>(_onLoadAdminShop);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterChanged>(_onFilterChanged);
    on<ToggleSuspensionRequested>(_onToggleSuspension);
  }

  Future<void> _onLoadAdminShop(
    LoadAdminShop event,
    Emitter<AdminShopState> emit,
  ) async {
    String query = '';
    String status = 'Total Shops';
    String? category;

    if (state is AdminShopLoaded) {
      final s = state as AdminShopLoaded;
      query = s.searchQuery;
      status = s.statusFilter;
      category = s.categoryFilter;
    }

    emit(AdminShopLoading());

    try {
      final response = await _getAdminShop(
        GetAdminShopParams(
          page: event.page,
          limit: event.limit,
          searchQuery: query,
          statusFilter: status,
          categoryFilter: category,
        ),
      );

      emit(
        AdminShopLoaded(
          shops: response.shops,
          totalMatchingCount: response.totalMatchingCount,
          totalShops: response.totalShops,
          activeShops: response.activeShops,
          suspendedShops: response.suspendedShops,
          availableCategories: response.availableCategories,
          currentPage: event.page,
          limit: event.limit,
          searchQuery: query,
          statusFilter: status,
          categoryFilter: category,
        ),
      );
    } catch (e) {
      emit(AdminShopError(e.toString()));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AdminShopState> emit,
  ) async {
    if (state is AdminShopLoaded) {
      final s = state as AdminShopLoaded;
      emit(AdminShopLoading());
      try {
        final response = await _getAdminShop(
          GetAdminShopParams(
            page: 1,
            limit: s.limit,
            searchQuery: event.query,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );

        emit(
          AdminShopLoaded(
            shops: response.shops,
            totalMatchingCount: response.totalMatchingCount,
            totalShops: response.totalShops,
            activeShops: response.activeShops,
            suspendedShops: response.suspendedShops,
            availableCategories: response.availableCategories,
            currentPage: 1,
            limit: s.limit,
            searchQuery: event.query,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );
      } catch (e) {
        emit(AdminShopError(e.toString()));
      }
    }
  }

  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<AdminShopState> emit,
  ) async {
    if (state is AdminShopLoaded) {
      final s = state as AdminShopLoaded;
      emit(AdminShopLoading());
      try {
        final response = await _getAdminShop(
          GetAdminShopParams(
            page: 1,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: event.statusFilter,
            categoryFilter: event.categoryFilter,
          ),
        );

        emit(
          AdminShopLoaded(
            shops: response.shops,
            totalMatchingCount: response.totalMatchingCount,
            totalShops: response.totalShops,
            activeShops: response.activeShops,
            suspendedShops: response.suspendedShops,
            availableCategories: response.availableCategories,
            currentPage: 1,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: event.statusFilter,
            categoryFilter: event.categoryFilter,
          ),
        );
      } catch (e) {
        emit(AdminShopError(e.toString()));
      }
    }
  }

  Future<void> _onToggleSuspension(
    ToggleSuspensionRequested event,
    Emitter<AdminShopState> emit,
  ) async {
    if (state is AdminShopLoaded) {
      final s = state as AdminShopLoaded;
      try {
        await _toggleShopSuspension(
          ToggleShopSuspensionParams(
            shopId: event.shopId,
            isSuspended: event.isSuspended,
          ),
        );

        final response = await _getAdminShop(
          GetAdminShopParams(
            page: s.currentPage,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );

        emit(
          AdminShopActionSuccess(
            event.isSuspended
                ? 'Shop suspended successfully'
                : 'Shop activated successfully',
          ),
        );

        emit(
          AdminShopLoaded(
            shops: response.shops,
            totalMatchingCount: response.totalMatchingCount,
            totalShops: response.totalShops,
            activeShops: response.activeShops,
            suspendedShops: response.suspendedShops,
            availableCategories: response.availableCategories,
            currentPage: s.currentPage,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );
      } catch (e) {
        emit(AdminShopError(e.toString()));
      }
    }
  }
}
