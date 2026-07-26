import 'package:equatable/equatable.dart';

abstract class AdminReviewsEvent extends Equatable {
  const AdminReviewsEvent();

  @override
  List<Object?> get props => [];
}

// Load Review Event
class LoadAdminReviewsRequested extends AdminReviewsEvent {}

// Page Changed Event
class PageChanged extends AdminReviewsEvent {
  final int page;

  const PageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

// Search Query Changed Event
class SearchQueryChanged extends AdminReviewsEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Delete Review Event
class DeleteReviewRequested extends AdminReviewsEvent {
  final String reviewId;

  const DeleteReviewRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}
