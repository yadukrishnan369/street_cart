import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_bloc.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_event.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_state.dart';
import 'package:street_cart/features/customer/review/presentation/utils/review_helper.dart';
import 'package:street_cart/features/customer/review/presentation/widgets/product_info_card.dart';
import 'package:street_cart/features/customer/review/presentation/widgets/rating_selector.dart';
import 'package:street_cart/features/customer/review/presentation/widgets/review_comment_field.dart';
import 'package:street_cart/features/customer/review/presentation/widgets/review_photo_picker.dart';
import 'package:street_cart/features/customer/review/presentation/widgets/submit_review_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Review Page
class ReviewPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final String shopId;
  final String? selectedSize;
  final String? selectedColor;
  final double? price;
  final ReviewModel? existingReview;

  const ReviewPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.shopId,
    this.selectedSize,
    this.selectedColor,
    this.price,
    this.existingReview,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _commentController.text = widget.existingReview!.reviewText;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ReviewBloc>().add(
          ChangeRatingEvent(widget.existingReview!.rating),
        );
        context.read<ReviewBloc>().add(
          ChangeCommentEvent(widget.existingReview!.reviewText),
        );
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.status == ReviewStatus.success) {
          CustomSnackBar.show(
            context,
            message: widget.existingReview != null
                ? 'Review updated successfully!'
                : 'Review submitted successfully!',
          );
          Navigator.pop(context, true);
        } else if (state.status == ReviewStatus.failure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage ?? 'Submission failed',
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ReviewStatus.submitting;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            // Page Title
            title: Text(
              widget.existingReview != null ? 'Edit Review' : 'Write a Review',
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info Card
                    ProductInfoCard(
                      productName: widget.productName,
                      productImage: widget.productImage,
                      size: widget.selectedSize,
                      color: widget.selectedColor,
                      price: widget.price,
                    ),
                    SizedBox(height: 24.h),
                    // Rating Selector
                    Center(
                      child: RatingSelector(
                        rating: state.rating,
                        onRatingChanged: (val) {
                          context.read<ReviewBloc>().add(
                            ChangeRatingEvent(val),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Review Comment Field
                    ReviewCommentField(
                      controller: _commentController,
                      onChanged: (val) {
                        context.read<ReviewBloc>().add(ChangeCommentEvent(val));
                      },
                      validator: Validators.validateReviewComment,
                    ),
                    SizedBox(height: 24.h),
                    // Review Photo Picker
                    ReviewPhotoPicker(
                      selectedImages: state.images,
                      onPickImages: () {
                        context.read<ReviewBloc>().add(PickReviewImagesEvent());
                      },
                      onRemoveImage: (index) {
                        context.read<ReviewBloc>().add(
                          RemoveReviewImageEvent(index),
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    // Submit Review Button
                    SubmitReviewButton(
                      isLoading: isLoading,
                      onPressed: () {
                        ReviewHelper.submitReview(
                          context: context,
                          formKey: _formKey,
                          productId: widget.productId,
                          shopId: widget.shopId,
                          reviewId: widget.existingReview?.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
