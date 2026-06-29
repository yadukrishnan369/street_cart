import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

class ShopsPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const ShopsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
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
        onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
      ),
    );

    for (int i = 1; i <= totalPages; i++) {
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
              color: isSelected ? AdminAppColors.primaryColor : Colors.transparent,
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
      if (i != totalPages) {
        list.add(SizedBox(width: 8.w));
      }
    }

    list.add(
      IconButton(
        icon: Icon(Icons.chevron_right, size: 20.sp),
        color: currentPage < totalPages
            ? AdminAppColors.primaryColor
            : const Color(0xFF8A8A9E).withValues(alpha: 0.5),
        onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
      ),
    );

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }
}
