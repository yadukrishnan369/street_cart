import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProductImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.iconSize,
    this.borderRadius,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: iconColor ?? Colors.grey[400],
          size: iconSize ?? 30.sp,
        ),
      ),
    );
  }
}
