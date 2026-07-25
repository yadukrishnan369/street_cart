import 'dart:io';
import 'package:equatable/equatable.dart';

enum ReviewStatus { initial, submitting, success, failure }

// Review State
class ReviewState extends Equatable {
  final int rating;
  final String comment;
  final List<File> images;
  final ReviewStatus status;
  final String? errorMessage;

  const ReviewState({
    this.rating = 4,
    this.comment = '',
    this.images = const [],
    this.status = ReviewStatus.initial,
    this.errorMessage,
  });

  ReviewState copyWith({
    int? rating,
    String? comment,
    List<File>? images,
    ReviewStatus? status,
    String? errorMessage,
  }) {
    return ReviewState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [rating, comment, images, status, errorMessage];
}
