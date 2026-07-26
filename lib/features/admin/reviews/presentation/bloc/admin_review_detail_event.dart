import 'package:equatable/equatable.dart';

abstract class AdminReviewDetailEvent extends Equatable {
  const AdminReviewDetailEvent();

  @override
  List<Object?> get props => [];
}

// Load Review Detail Event
class LoadReviewDetail extends AdminReviewDetailEvent {
  final String reviewId;

  const LoadReviewDetail(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

// Toggle Visibility Event
class ToggleVisibility extends AdminReviewDetailEvent {
  final String reviewId;
  final bool isHidden;

  const ToggleVisibility({required this.reviewId, required this.isHidden});

  @override
  List<Object?> get props => [reviewId, isHidden];
}

// Delete Review Event
class DeleteReview extends AdminReviewDetailEvent {
  final String reviewId;

  const DeleteReview(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}
