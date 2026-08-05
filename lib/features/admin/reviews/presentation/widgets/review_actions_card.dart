import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_bloc.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_event.dart';
import 'package:street_cart/features/admin/reviews/presentation/utils/review_helper.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

// Review Actions Card
class ReviewActionsCard extends StatelessWidget {
  final ReviewModel review;
  final AdminReviewDetailBloc bloc;

  const ReviewActionsCard({
    super.key,
    required this.review,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Review Actions',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
            height: 1,
          ),
          SizedBox(height: 20.h),

          // Hide / Show Review Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // Confirmation modal
              onPressed: () {
                AdminReviewHelper.confirmToggleVisibilityByAdmin(
                  context: context,
                  isCurrentlyHidden: review.isHidden,
                  onConfirm: () {
                    bloc.add(
                      ToggleVisibility(
                        reviewId: review.id,
                        isHidden: !review.isHidden,
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                review.isHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 16.sp,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
              label: Text(
                review.isHidden ? 'Show Review' : 'Hide Review',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AdminAppColors.darkInputBackground
                    : const Color(0xFFF1F5F9),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: isDark
                        ? AdminAppColors.darkBorder
                        : AdminAppColors.borderLight,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Remove Review Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // Confirmation modal for Delete
              onPressed: () {
                AdminReviewHelper.confirmDeleteByAdmin(
                  context: context,
                  onConfirm: () {
                    bloc.add(DeleteReview(review.id));
                  },
                );
              },
              icon: Icon(
                Icons.delete_outline,
                size: 16.sp,
                color: AdminAppColors.errorColor,
              ),
              label: Text(
                'Remove Review',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.errorColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AdminAppColors.errorColor.withValues(alpha: 0.15)
                    : const Color(0xFFFEF2F2),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: AdminAppColors.errorColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
