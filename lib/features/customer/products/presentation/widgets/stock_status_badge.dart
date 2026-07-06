import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockStatusBadge extends StatelessWidget {
  final int qty;

  const StockStatusBadge({super.key, required this.qty});

  @override
  Widget build(BuildContext context) {
    final isOut = qty == 0;
    final isLow = qty > 0 && qty <= 5;

    Color bg;
    Color fg;
    String text;
    IconData icon;

    if (isOut) {
      bg = Colors.red[50]!;
      fg = Colors.red[700]!;
      text = 'Out of Stock';
      icon = Icons.remove_circle_outline_rounded;
    } else if (isLow) {
      bg = Colors.orange[50]!;
      fg = Colors.orange[700]!;
      text = 'Only $qty left!';
      icon = Icons.warning_amber_rounded;
    } else {
      bg = Colors.green[50]!;
      fg = Colors.green[700]!;
      text = 'In Stock $qty available';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
