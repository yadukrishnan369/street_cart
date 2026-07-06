import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class SettingSectionCard extends StatelessWidget {
  final List<Widget> children;

  const SettingSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(children: children),
    );
  }
}

class SettingRowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconBgColor;
  final Color? iconColor;
  final Color? titleColor;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingRowItem({
    super.key,
    required this.icon,
    required this.title,
    this.iconBgColor,
    this.iconColor,
    this.titleColor,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: iconColor ?? ShopAppColors.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: titleColor ?? ShopAppColors.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SettingRowDivider extends StatelessWidget {
  const SettingRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: const Color(0xFFECEFF1),
      height: 1,
      thickness: 0.8,
      indent: 56.w,
    );
  }
}

class SettingSectionHeader extends StatelessWidget {
  final String title;

  const SettingSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
      child: Text(
        title,
        style: ShopAppTextStyles.bodySmall.copyWith(
          color: ShopAppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
          letterSpacing: 0.5.sp,
        ),
      ),
    );
  }
}

class SettingCustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingCustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Transform.scale(
        scale: 0.75,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: ShopAppColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCFD8DC),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
