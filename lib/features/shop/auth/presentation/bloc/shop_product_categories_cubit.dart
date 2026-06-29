import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_product_categories.dart';

part 'shop_product_categories_state.dart';

class ShopProductCategoriesCubit extends Cubit<ShopProductCategoriesState> {
  final GetProductCategories _getProductCategories;

  ShopProductCategoriesCubit({
    required GetProductCategories getProductCategories,
  })  : _getProductCategories = getProductCategories,
        super(ShopProductCategoriesInitial());

  Future<void> loadCategories() async {
    emit(ShopProductCategoriesLoading());
    try {
      final categories = await _getProductCategories();
      emit(ShopProductCategoriesLoaded(categories));
    } catch (e) {
      emit(ShopProductCategoriesError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
