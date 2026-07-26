import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class AdminReviewsState extends Equatable {
  const AdminReviewsState();

  @override
  List<Object?> get props => [];
}

// Reviews Initial State
class AdminReviewsInitial extends AdminReviewsState {}

// Reviews Loading State
class AdminReviewsLoading extends AdminReviewsState {}

// Reviews Loaded State
class AdminReviewsLoaded extends AdminReviewsState {
  final List<ReviewModel> reviews;
  final List<ReviewModel> filteredReviews;
  final List<ReviewModel> paginatedReviews;
  final Map<String, String> productNames;
  final Map<String, String> shopNames;
  final int totalReviews;
  final double averageRating;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final int perPage;

  const AdminReviewsLoaded({
    required this.reviews,
    required this.filteredReviews,
    required this.paginatedReviews,
    required this.productNames,
    required this.shopNames,
    required this.totalReviews,
    required this.averageRating,
    required this.searchQuery,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
  });

  AdminReviewsLoaded copyWith({
    List<ReviewModel>? reviews,
    List<ReviewModel>? filteredReviews,
    List<ReviewModel>? paginatedReviews,
    Map<String, String>? productNames,
    Map<String, String>? shopNames,
    int? totalReviews,
    double? averageRating,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    int? perPage,
  }) {
    return AdminReviewsLoaded(
      reviews: reviews ?? this.reviews,
      filteredReviews: filteredReviews ?? this.filteredReviews,
      paginatedReviews: paginatedReviews ?? this.paginatedReviews,
      productNames: productNames ?? this.productNames,
      shopNames: shopNames ?? this.shopNames,
      totalReviews: totalReviews ?? this.totalReviews,
      averageRating: averageRating ?? this.averageRating,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      perPage: perPage ?? this.perPage,
    );
  }

  @override
  List<Object?> get props => [
    reviews,
    filteredReviews,
    paginatedReviews,
    productNames,
    shopNames,
    totalReviews,
    averageRating,
    searchQuery,
    currentPage,
    totalPages,
    perPage,
  ];
}

// Reviews Error State
class AdminReviewsError extends AdminReviewsState {
  final String message;

  const AdminReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
