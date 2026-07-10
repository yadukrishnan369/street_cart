import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

class AdminPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const AdminPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];

    list.add(
      IconButton(
        icon: Icon(Icons.chevron_left, size: 20.sp),
        color: currentPage > 1
            ? AdminAppColors.primaryColor
            : const Color(0xFF8A8A9E).withValues(alpha: 0.5),
        onPressed: currentPage > 1
            ? () => onPageChanged(currentPage - 1)
            : null,
      ),
    );

    final normalizedTotalPages = totalPages.clamp(1, double.infinity).toInt();

    for (int i = 1; i <= normalizedTotalPages; i++) {
      final isSelected = currentPage == i;
      list.add(
        InkWell(
          onTap: () => onPageChanged(i),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 36.w,
            height: 36.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AdminAppColors.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: isSelected
                  ? null
                  : Border.all(color: const Color(0xFFE8E7ED), width: 1),
            ),
            child: Text(
              '$i',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF6C6C80),
              ),
            ),
          ),
        ),
      );
      if (i != normalizedTotalPages) {
        list.add(SizedBox(width: 8.w));
      }
    }

    list.add(
      IconButton(
        icon: Icon(Icons.chevron_right, size: 20.sp),
        color: currentPage < totalPages
            ? AdminAppColors.primaryColor
            : const Color(0xFF8A8A9E).withValues(alpha: 0.5),
        onPressed: currentPage < totalPages
            ? () => onPageChanged(currentPage + 1)
            : null,
      ),
    );

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }
}
