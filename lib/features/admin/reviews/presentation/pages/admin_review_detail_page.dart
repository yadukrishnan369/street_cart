import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_bloc.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_event.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_state.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/review_actions_card.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/review_details_card.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/shimmer/review_detail_shimmer.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Admin Review Detail Page
class AdminReviewDetailPage extends StatelessWidget {
  final String reviewId;

  const AdminReviewDetailPage({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminReviewDetailBloc>()..add(LoadReviewDetail(reviewId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocConsumer<AdminReviewDetailBloc, AdminReviewDetailState>(
            listener: (context, state) {
              if (state is AdminReviewDetailActionSuccess) {
                CustomSnackBar.show(context, message: state.message);
                if (state.message.contains('deleted')) {
                  context.pop(true);
                }
              } else if (state is AdminReviewDetailError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              // Showing Shimmer
              if (state is AdminReviewDetailLoading) {
                return const ReviewDetailShimmer();
              }
              // Error View
              if (state is AdminReviewDetailError) {
                return AdminErrorView(
                  message: state.message,
                  onRetry: () => context.read<AdminReviewDetailBloc>().add(
                    LoadReviewDetail(reviewId),
                  ),
                );
              }

              if (state is AdminReviewDetailLoaded) {
                final review = state.review;
                final productName = state.productName;
                final shopName = state.shopName;
                final bloc = context.read<AdminReviewDetailBloc>();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40.w : 20.w,
                        vertical: 32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back to Reviews
                          InkWell(
                            onTap: () => context.pop(false),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 16.sp,
                                  color: AdminAppColors.primaryColor,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Back to Reviews',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AdminAppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Main content
                          isWide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Review Details Card
                                    Expanded(
                                      child: ReviewDetailsCard(
                                        review: review,
                                        productName: productName,
                                        shopName: shopName,
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    // Review Actions Card
                                    SizedBox(
                                      width: 320.w,
                                      child: ReviewActionsCard(
                                        review: review,
                                        bloc: bloc,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Review Details Card
                                    ReviewDetailsCard(
                                      review: review,
                                      productName: productName,
                                      shopName: shopName,
                                    ),
                                    SizedBox(height: 24.h),
                                    // Review Actions Card
                                    ReviewActionsCard(
                                      review: review,
                                      bloc: bloc,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
