import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/delete_review_by_admin.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/get_admin_review_details.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/toggle_review_visibility.dart';
import 'admin_review_detail_event.dart';
import 'admin_review_detail_state.dart';

class AdminReviewDetailBloc
    extends Bloc<AdminReviewDetailEvent, AdminReviewDetailState> {
  final GetAdminReviewDetails _getAdminReviewDetails;
  final ToggleReviewVisibility _toggleReviewVisibility;
  final DeleteReviewByAdmin _deleteReviewByAdmin;

  AdminReviewDetailBloc({
    required GetAdminReviewDetails getAdminReviewDetails,
    required ToggleReviewVisibility toggleReviewVisibility,
    required DeleteReviewByAdmin deleteReviewByAdmin,
  }) : _getAdminReviewDetails = getAdminReviewDetails,
       _toggleReviewVisibility = toggleReviewVisibility,
       _deleteReviewByAdmin = deleteReviewByAdmin,
       super(AdminReviewDetailInitial()) {
    on<LoadReviewDetail>(_onLoadReviewDetail);
    on<ToggleVisibility>(_onToggleVisibility);
    on<DeleteReview>(_onDeleteReview);
  }

  // Load Review Detail
  FutureOr<void> _onLoadReviewDetail(
    LoadReviewDetail event,
    Emitter<AdminReviewDetailState> emit,
  ) async {
    emit(AdminReviewDetailLoading());
    try {
      final review = await _getAdminReviewDetails(event.reviewId);
      final productNames = await _getAdminReviewDetails.repository
          .getProductNamesMap();
      final shopNames = await _getAdminReviewDetails.repository
          .getShopNamesMap();

      final productName = productNames[review.productId] ?? 'Unknown Product';
      final shopName = shopNames[review.shopId] ?? 'Unknown Shop';

      emit(
        AdminReviewDetailLoaded(
          review: review,
          productName: productName,
          shopName: shopName,
        ),
      );
    } catch (e) {
      emit(AdminReviewDetailError(e.toString()));
    }
  }

  // Hide/Show Toggle Visibility
  FutureOr<void> _onToggleVisibility(
    ToggleVisibility event,
    Emitter<AdminReviewDetailState> emit,
  ) async {
    emit(AdminReviewDetailLoading());
    try {
      await _toggleReviewVisibility(event.reviewId, event.isHidden);
      final review = await _getAdminReviewDetails(event.reviewId);
      final productNames = await _getAdminReviewDetails.repository
          .getProductNamesMap();
      final shopNames = await _getAdminReviewDetails.repository
          .getShopNamesMap();

      final productName = productNames[review.productId] ?? 'Unknown Product';
      final shopName = shopNames[review.shopId] ?? 'Unknown Shop';

      emit(
        AdminReviewDetailActionSuccess(
          event.isHidden ? 'Review is now hidden.' : 'Review is now visible.',
        ),
      );
      emit(
        AdminReviewDetailLoaded(
          review: review,
          productName: productName,
          shopName: shopName,
        ),
      );
    } catch (e) {
      emit(AdminReviewDetailError(e.toString()));
    }
  }

  // Delete Review
  FutureOr<void> _onDeleteReview(
    DeleteReview event,
    Emitter<AdminReviewDetailState> emit,
  ) async {
    emit(AdminReviewDetailLoading());
    try {
      await _deleteReviewByAdmin(event.reviewId);
      emit(
        const AdminReviewDetailActionSuccess('Review deleted successfully.'),
      );
    } catch (e) {
      emit(AdminReviewDetailError(e.toString()));
    }
  }
}
