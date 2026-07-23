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

    final List<dynamic> pages = [];
    if (normalizedTotalPages <= 4) {
      for (int i = 1; i <= normalizedTotalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      pages.add(2);
      pages.add(3);
      pages.add('...');
      pages.add(normalizedTotalPages);
    }

    for (int idx = 0; idx < pages.length; idx++) {
      final pageItem = pages[idx];
      if (pageItem == '...') {
        list.add(
          Container(
            width: 36.w,
            height: 36.h,
            alignment: Alignment.center,
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6C6C80),
              ),
            ),
          ),
        );
      } else {
        final pageNum = pageItem as int;
        final isSelected = currentPage == pageNum;
        list.add(
          InkWell(
            onTap: () => onPageChanged(pageNum),
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
                '$pageNum',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF6C6C80),
                ),
              ),
            ),
          ),
        );
      }
      if (idx != pages.length - 1) {
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
