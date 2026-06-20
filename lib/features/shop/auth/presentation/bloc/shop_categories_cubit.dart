import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_business_categories.dart';

part 'shop_categories_state.dart';

class ShopCategoriesCubit extends Cubit<ShopCategoriesState> {
  final GetBusinessCategories _getBusinessCategories;

  ShopCategoriesCubit({
    required GetBusinessCategories getBusinessCategories,
  })  : _getBusinessCategories = getBusinessCategories,
        super(ShopCategoriesInitial());

  Future<void> loadCategories() async {
    emit(ShopCategoriesLoading());
    try {
      final categories = await _getBusinessCategories();
      emit(ShopCategoriesLoaded(categories));
    } catch (e) {
      emit(ShopCategoriesError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
