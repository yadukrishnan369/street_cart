import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Variant Unavailable Warning Banner
class VariantWarningBanner extends StatelessWidget {
  final String warningMessage;

  const VariantWarningBanner({super.key, required this.warningMessage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.red[900]! : Colors.red[50]!,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? Colors.red[700]! : Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: isDark ? Colors.red[300]! : Colors.red[700]!,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            // Warning Message
            child: Text(
              warningMessage,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.red[300]! : Colors.red[700]!,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
