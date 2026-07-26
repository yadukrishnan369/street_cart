import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class AdminReviewDetailState extends Equatable {
  const AdminReviewDetailState();

  @override
  List<Object?> get props => [];
}

// Review Detail Initial State
class AdminReviewDetailInitial extends AdminReviewDetailState {}

// Review Detail Loading
class AdminReviewDetailLoading extends AdminReviewDetailState {}

// Review Detail Loaded State
class AdminReviewDetailLoaded extends AdminReviewDetailState {
  final ReviewModel review;
  final String productName;
  final String shopName;

  const AdminReviewDetailLoaded({
    required this.review,
    required this.productName,
    required this.shopName,
  });

  @override
  List<Object?> get props => [review, productName, shopName];
}

// Review Detail Action Success State
class AdminReviewDetailActionSuccess extends AdminReviewDetailState {
  final String message;

  const AdminReviewDetailActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Review Detail Error State
class AdminReviewDetailError extends AdminReviewDetailState {
  final String message;

  const AdminReviewDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
