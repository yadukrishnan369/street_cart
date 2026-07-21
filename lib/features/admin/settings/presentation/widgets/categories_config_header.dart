import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_dialogs.dart';

// Categories Config Header
class CategoriesConfigHeader extends StatelessWidget {
  final AdminSettingsModel currentSettings;
  final List<SizeGroupModel> allSizeGroups;

  const CategoriesConfigHeader({
    super.key,
    required this.currentSettings,
    required this.allSizeGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Category Configuration',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
            SizedBox(height: 4.h),
            // Subtitle
            Text(
              'Configure business categories, link sub product categories, and select matching size standards.',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF8A8A9E)),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => CategoryDialogs.showAdd(
            context: context,
            settings: currentSettings,
            allSizeGroups: allSizeGroups,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminAppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Configuration'),
        ),
      ],
    );
  }
}
