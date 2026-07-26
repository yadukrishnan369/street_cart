import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/delete_review_by_admin.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/get_admin_reviews.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'admin_reviews_event.dart';
import 'admin_reviews_state.dart';

class AdminReviewsBloc extends Bloc<AdminReviewsEvent, AdminReviewsState> {
  final GetAdminReviews _getAdminReviews;
  final DeleteReviewByAdmin _deleteReviewByAdmin;
  static const int _perPage = 6;

  AdminReviewsBloc({
    required GetAdminReviews getAdminReviews,
    required DeleteReviewByAdmin deleteReviewByAdmin,
  }) : _getAdminReviews = getAdminReviews,
       _deleteReviewByAdmin = deleteReviewByAdmin,
       super(AdminReviewsInitial()) {
    on<LoadAdminReviewsRequested>(_onLoadAdminReviews);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<PageChanged>(_onPageChanged);
    on<DeleteReviewRequested>(_onDeleteReviewRequested);
  }

  // Load Reviews
  FutureOr<void> _onLoadAdminReviews(
    LoadAdminReviewsRequested event,
    Emitter<AdminReviewsState> emit,
  ) async {
    emit(AdminReviewsLoading());
    try {
      final reviews = await _getAdminReviews();
      final productNames = await _getAdminReviews.repository
          .getProductNamesMap();
      final shopNames = await _getAdminReviews.repository.getShopNamesMap();

      final total = reviews.length;
      final avg = total > 0
          ? (reviews.map((r) => r.rating).reduce((a, b) => a + b) / total)
          : 0.0;

      final totalPages = (total / _perPage).ceil();
      final paginated = _getPaginatedSlice(reviews, 1, _perPage);

      emit(
        AdminReviewsLoaded(
          reviews: reviews,
          filteredReviews: reviews,
          paginatedReviews: paginated,
          productNames: productNames,
          shopNames: shopNames,
          totalReviews: total,
          averageRating: avg,
          searchQuery: '',
          currentPage: 1,
          totalPages: totalPages == 0 ? 1 : totalPages,
          perPage: _perPage,
        ),
      );
    } catch (e) {
      emit(AdminReviewsError(e.toString()));
    }
  }

  // Review Search Query
  FutureOr<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AdminReviewsState> emit,
  ) async {
    if (state is AdminReviewsLoaded) {
      final current = state as AdminReviewsLoaded;
      emit(AdminReviewsLoading());

      // Small delay for progress indicator
      await Future.delayed(const Duration(milliseconds: 300));

      final q = event.query.toLowerCase();
      final filtered = current.reviews.where((item) {
        final matchCustomer = item.customerName.toLowerCase().contains(q);
        final productName = current.productNames[item.productId] ?? '';
        final matchProduct = productName.toLowerCase().contains(q);
        final matchComment = item.reviewText.toLowerCase().contains(q);
        return matchCustomer || matchProduct || matchComment;
      }).toList();

      final totalPages = (filtered.length / _perPage).ceil();
      final paginated = _getPaginatedSlice(filtered, 1, _perPage);

      emit(
        current.copyWith(
          filteredReviews: filtered,
          paginatedReviews: paginated,
          searchQuery: event.query,
          currentPage: 1,
          totalPages: totalPages == 0 ? 1 : totalPages,
        ),
      );
    }
  }

  // Page Changed
  FutureOr<void> _onPageChanged(
    PageChanged event,
    Emitter<AdminReviewsState> emit,
  ) {
    if (state is AdminReviewsLoaded) {
      final current = state as AdminReviewsLoaded;
      if (event.page < 1 || event.page > current.totalPages) return null;

      final paginated = _getPaginatedSlice(
        current.filteredReviews,
        event.page,
        _perPage,
      );

      emit(
        current.copyWith(currentPage: event.page, paginatedReviews: paginated),
      );
    }
  }

  // Delete Review
  FutureOr<void> _onDeleteReviewRequested(
    DeleteReviewRequested event,
    Emitter<AdminReviewsState> emit,
  ) async {
    if (state is AdminReviewsLoaded) {
      final current = state as AdminReviewsLoaded;
      emit(AdminReviewsLoading());
      try {
        await _deleteReviewByAdmin(event.reviewId);
        final reviews = await _getAdminReviews();
        final total = reviews.length;
        final avg = total > 0
            ? (reviews.map((r) => r.rating).reduce((a, b) => a + b) / total)
            : 0.0;

        // Reapply search filter
        final q = current.searchQuery.toLowerCase();
        final filtered = reviews.where((item) {
          final matchCustomer = item.customerName.toLowerCase().contains(q);
          final productName = current.productNames[item.productId] ?? '';
          final matchProduct = productName.toLowerCase().contains(q);
          final matchComment = item.reviewText.toLowerCase().contains(q);
          return matchCustomer || matchProduct || matchComment;
        }).toList();

        final totalPages = (filtered.length / _perPage).ceil();

        int targetPage = current.currentPage;
        if (targetPage > totalPages) {
          targetPage = totalPages == 0 ? 1 : totalPages;
        }

        final paginated = _getPaginatedSlice(filtered, targetPage, _perPage);

        emit(
          AdminReviewsLoaded(
            reviews: reviews,
            filteredReviews: filtered,
            paginatedReviews: paginated,
            productNames: current.productNames,
            shopNames: current.shopNames,
            totalReviews: total,
            averageRating: avg,
            searchQuery: current.searchQuery,
            currentPage: targetPage,
            totalPages: totalPages == 0 ? 1 : totalPages,
            perPage: _perPage,
          ),
        );
      } catch (e) {
        emit(AdminReviewsError(e.toString()));
      }
    }
  }

  // Get Paginated Slice
  List<ReviewModel> _getPaginatedSlice(
    List<ReviewModel> list,
    int page,
    int perPage,
  ) {
    final start = (page - 1) * perPage;
    if (start >= list.length) return [];
    final end = start + perPage;
    return list.sublist(start, end > list.length ? list.length : end);
  }
}
