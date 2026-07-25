import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/features/customer/review/domain/usecases/submit_review.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReview submitReview;

  ReviewBloc({required this.submitReview}) : super(const ReviewState()) {
    on<ChangeRatingEvent>(_onChangeRating);
    on<ChangeCommentEvent>(_onChangeComment);
    on<PickReviewImagesEvent>(_onPickImages);
    on<RemoveReviewImageEvent>(_onRemoveImage);
    on<SubmitReviewEvent>(_onSubmitReview);
  }
  // Change Rating
  void _onChangeRating(ChangeRatingEvent event, Emitter<ReviewState> emit) {
    emit(state.copyWith(rating: event.rating));
  }

  // Change Comment
  void _onChangeComment(ChangeCommentEvent event, Emitter<ReviewState> emit) {
    emit(state.copyWith(comment: event.comment));
  }

  // Pick Images
  Future<void> _onPickImages(
    PickReviewImagesEvent event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      final images = await ImagePickerHelper.pickMultiImage(
        limit: 5 - state.images.length,
      );
      if (images.isNotEmpty) {
        final List<File> updatedList = List.from(state.images)..addAll(images);
        emit(state.copyWith(images: updatedList));
      }
    } catch (_) {}
  }

  // Remove Image
  void _onRemoveImage(RemoveReviewImageEvent event, Emitter<ReviewState> emit) {
    if (event.index >= 0 && event.index < state.images.length) {
      final List<File> updatedList = List.from(state.images)
        ..removeAt(event.index);
      emit(state.copyWith(images: updatedList));
    }
  }

  // Submit Review
  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.submitting));
    try {
      await submitReview(
        productId: event.productId,
        shopId: event.shopId,
        rating: state.rating,
        reviewText: state.comment,
        imageFiles: state.images,
        reviewId: event.reviewId,
      );
      emit(state.copyWith(status: ReviewStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ReviewStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
