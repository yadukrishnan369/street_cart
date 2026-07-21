import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/products/domain/usecases/get_admin_products.dart';
import 'admin_product_event.dart';
import 'admin_product_state.dart';

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  final GetAdminProducts _getAdminProducts;

  AdminProductBloc({required GetAdminProducts getAdminProducts})
    : _getAdminProducts = getAdminProducts,
      super(AdminProductInitial()) {
    on<LoadAdminProducts>(_onLoadAdminProducts);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterChanged>(_onFilterChanged);
    on<PageChanged>(_onPageChanged);
  }
  // Load Products
  Future<void> _onLoadAdminProducts(
    LoadAdminProducts event,
    Emitter<AdminProductState> emit,
  ) async {
    String query = '';
    String status = 'Total Products';
    String? category;

    if (state is AdminProductLoaded) {
      final s = state as AdminProductLoaded;
      query = s.searchQuery;
      status = s.statusFilter;
      category = s.categoryFilter;
    }

    emit(AdminProductLoading());
    try {
      final response = await _getAdminProducts(
        GetAdminProductsParams(
          page: event.page,
          limit: event.limit,
          searchQuery: query,
          statusFilter: status,
          categoryFilter: category,
        ),
      );
      emit(
        AdminProductLoaded(
          products: response.products,
          totalMatchingCount: response.totalMatchingCount,
          totalProducts: response.totalProducts,
          activeItems: response.activeItems,
          outOfStock: response.outOfStock,
          disabledItems: response.disabledItems,
          availableCategories: response.availableCategories,
          currentPage: event.page,
          limit: event.limit,
          searchQuery: query,
          statusFilter: status,
          categoryFilter: category,
        ),
      );
    } catch (e) {
      emit(AdminProductError(e.toString()));
    }
  }

  // Search Query Changed
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AdminProductState> emit,
  ) async {
    if (state is AdminProductLoaded) {
      final s = state as AdminProductLoaded;
      emit(AdminProductLoading());
      try {
        final response = await _getAdminProducts(
          GetAdminProductsParams(
            page: 1,
            limit: s.limit,
            searchQuery: event.query,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );
        emit(
          AdminProductLoaded(
            products: response.products,
            totalMatchingCount: response.totalMatchingCount,
            totalProducts: response.totalProducts,
            activeItems: response.activeItems,
            outOfStock: response.outOfStock,
            disabledItems: response.disabledItems,
            availableCategories: response.availableCategories,
            currentPage: 1,
            limit: s.limit,
            searchQuery: event.query,
            statusFilter: s.statusFilter,
            categoryFilter: s.categoryFilter,
          ),
        );
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    }
  }

  // Filter Changed
  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<AdminProductState> emit,
  ) async {
    if (state is AdminProductLoaded) {
      final s = state as AdminProductLoaded;
      emit(AdminProductLoading());
      try {
        final response = await _getAdminProducts(
          GetAdminProductsParams(
            page: 1,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: event.statusFilter,
            categoryFilter: event.categoryFilter,
          ),
        );
        emit(
          AdminProductLoaded(
            products: response.products,
            totalMatchingCount: response.totalMatchingCount,
            totalProducts: response.totalProducts,
            activeItems: response.activeItems,
            outOfStock: response.outOfStock,
            disabledItems: response.disabledItems,
            availableCategories: response.availableCategories,
            currentPage: 1,
            limit: s.limit,
            searchQuery: s.searchQuery,
            statusFilter: event.statusFilter,
            categoryFilter: event.categoryFilter,
          ),
        );
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    }
  }

  // Pagination handler
  void _onPageChanged(PageChanged event, Emitter<AdminProductState> emit) {
    if (state is AdminProductLoaded) {
      emit((state as AdminProductLoaded).copyWith(currentPage: event.page));
    }
  }
}
