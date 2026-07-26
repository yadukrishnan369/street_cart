import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/reviews/domain/usecases/get_shop_product_reviews.dart';
import 'shop_reviews_event.dart';
import 'shop_reviews_state.dart';

class ShopReviewsBloc extends Bloc<ShopReviewsEvent, ShopReviewsState> {
  final GetShopProductReviews _getShopProductReviews;

  ShopReviewsBloc({required GetShopProductReviews getShopProductReviews})
    : _getShopProductReviews = getShopProductReviews,
      super(ShopReviewsInitial()) {
    on<LoadShopReviewsEvent>(_onLoadShopReviews);
  }
  // Load Shop Product Reviews
  FutureOr<void> _onLoadShopReviews(
    LoadShopReviewsEvent event,
    Emitter<ShopReviewsState> emit,
  ) async {
    emit(ShopReviewsLoading());
    try {
      final reviews = await _getShopProductReviews(event.productId);
      emit(ShopReviewsLoaded(reviews));
    } catch (e) {
      emit(ShopReviewsError(e.toString()));
    }
  }
}
