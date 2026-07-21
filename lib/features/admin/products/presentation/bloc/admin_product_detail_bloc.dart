import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/products/domain/usecases/get_admin_product_details.dart';
import 'package:street_cart/features/admin/products/domain/usecases/disable_product.dart';
import 'package:street_cart/features/admin/products/domain/usecases/admin_delete_product.dart';
import 'admin_product_detail_event.dart';
import 'admin_product_detail_state.dart';

class AdminProductDetailBloc
    extends Bloc<AdminProductDetailEvent, AdminProductDetailState> {
  final GetAdminProductDetails _getProductDetails;
  final DisableProduct _disableProduct;
  final AdminDeleteProduct _deleteProduct;

  AdminProductDetailBloc({
    required GetAdminProductDetails getProductDetails,
    required DisableProduct disableProduct,
    required AdminDeleteProduct deleteProduct,
  }) : _getProductDetails = getProductDetails,
       _disableProduct = disableProduct,
       _deleteProduct = deleteProduct,
       super(AdminProductDetailInitial()) {
    on<LoadProductDetailRequested>(_onLoadProductDetailRequested);
    on<ToggleDisableProductRequested>(_onToggleDisableProductRequested);
    on<DeleteProductRequested>(_onDeleteProductRequested);
  }
  // Load Product Detail
  Future<void> _onLoadProductDetailRequested(
    LoadProductDetailRequested event,
    Emitter<AdminProductDetailState> emit,
  ) async {
    emit(AdminProductDetailLoading());
    try {
      final item = await _getProductDetails(event.productId);
      emit(AdminProductDetailLoaded(item));
    } catch (e) {
      emit(AdminProductDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Toggle Disable Product
  Future<void> _onToggleDisableProductRequested(
    ToggleDisableProductRequested event,
    Emitter<AdminProductDetailState> emit,
  ) async {
    final currentState = state;
    emit(AdminProductDetailActionInProgress());
    try {
      await _disableProduct(event.productId, event.disable);
      final msg = event.disable
          ? 'Product disabled successfully'
          : 'Product enabled successfully';
      emit(AdminProductDetailActionSuccess(msg));

      // Reload product details
      final item = await _getProductDetails(event.productId);
      emit(AdminProductDetailLoaded(item));
    } catch (e) {
      emit(AdminProductDetailError(e.toString().replaceAll('Exception: ', '')));
      if (currentState is AdminProductDetailLoaded) {
        emit(currentState);
      }
    }
  }

  // Delete Product
  Future<void> _onDeleteProductRequested(
    DeleteProductRequested event,
    Emitter<AdminProductDetailState> emit,
  ) async {
    emit(AdminProductDetailActionInProgress());
    try {
      await _deleteProduct(event.productId);
      emit(
        const AdminProductDetailActionSuccess('Product deleted successfully'),
      );
    } catch (e) {
      emit(AdminProductDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
