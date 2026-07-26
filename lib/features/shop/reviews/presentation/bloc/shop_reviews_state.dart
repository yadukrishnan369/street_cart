import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class ShopReviewsState extends Equatable {
  const ShopReviewsState();

  @override
  List<Object?> get props => [];
}

// Reviews Initial State
class ShopReviewsInitial extends ShopReviewsState {}

// Reviews Loading State
class ShopReviewsLoading extends ShopReviewsState {}

// Reviews Loaded State
class ShopReviewsLoaded extends ShopReviewsState {
  final List<ReviewModel> reviews;
  const ShopReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

// Reviews Error State
class ShopReviewsError extends ShopReviewsState {
  final String message;

  const ShopReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
