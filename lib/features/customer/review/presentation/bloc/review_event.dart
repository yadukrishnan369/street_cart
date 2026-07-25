import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

// Change Rating Event
class ChangeRatingEvent extends ReviewEvent {
  final int rating;

  const ChangeRatingEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}

// Change Comment Event
class ChangeCommentEvent extends ReviewEvent {
  final String comment;

  const ChangeCommentEvent(this.comment);

  @override
  List<Object?> get props => [comment];
}

// Pick Review Images Event
class PickReviewImagesEvent extends ReviewEvent {}

// Remove Review Image Event
class RemoveReviewImageEvent extends ReviewEvent {
  final int index;

  const RemoveReviewImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// Submit Review Event
class SubmitReviewEvent extends ReviewEvent {
  final String productId;
  final String shopId;

  const SubmitReviewEvent({required this.productId, required this.shopId});

  @override
  List<Object?> get props => [productId, shopId];
}
