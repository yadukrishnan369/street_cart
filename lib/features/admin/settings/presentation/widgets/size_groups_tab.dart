import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_state.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/size_group_dialogs.dart';

// Size Groups Tab
class SizeGroupsTab extends StatelessWidget {
  const SizeGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AdminProductConfigBloc, AdminProductConfigState>(
      builder: (context, state) {
        final config = _resolveConfig(state);
        final groups = config.sizeGroups;
        final isLoading = state is ProductConfigActionInProgress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Size Groups',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${groups.length} group${groups.length == 1 ? '' : 's'} configured',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => SizeGroupDialogs.showAdd(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminAppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // List or empty
            if (groups.isEmpty)
              _emptyState(context)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) =>
                    _SizeGroupCard(group: groups[index]),
              ),
          ],
        );
      },
    );
  }

  // Empty State
  Widget _emptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                    : const Color(0xFFF4EBFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.straighten_outlined,
                size: 40.sp,
                color: AdminAppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No size groups yet',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Create reusable size groups like Clothing, Shoes, Pants.',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark
                    ? AdminAppColors.darkTextSecondary
                    : const Color(0xFF8A8A9E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ProductConfigModel _resolveConfig(AdminProductConfigState state) {
    if (state is ProductConfigLoaded) return state.config;
    if (state is ProductConfigActionInProgress) return state.config;
    if (state is ProductConfigActionSuccess) return state.config;
    if (state is ProductConfigActionFailure) return state.config;
    return const ProductConfigModel();
  }
}

// Size group card
class _SizeGroupCard extends StatelessWidget {
  final SizeGroupModel group;
  const _SizeGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                        : const Color(0xFFF4EBFF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.straighten_outlined,
                    size: 18.sp,
                    color: AdminAppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AdminAppColors.darkTextPrimary
                              : AdminAppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${group.sizes.length} size${group.sizes.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                _iconBtn(
                  Icons.add,
                  AdminAppColors.primaryColor,
                  () => SizeGroupDialogs.showAddSize(context, group),
                  'Add size',
                ),
                SizedBox(width: 4.w),
                _iconBtn(
                  Icons.edit_outlined,
                  isDark
                      ? AdminAppColors.darkTextSecondary
                      : const Color(0xFF8A8A9E),
                  () => SizeGroupDialogs.showEdit(context, group),
                  'Edit group',
                ),
                SizedBox(width: 4.w),
                _iconBtn(
                  Icons.delete_outline,
                  AdminAppColors.errorColor,
                  () => SizeGroupDialogs.showDelete(context, group),
                  'Delete group',
                ),
              ],
            ),
          ),

          // Sizes wrap
          if (group.sizes.isNotEmpty) ...[
            Divider(
              height: 1,
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFE8E7ED),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: group.sizes
                    .map((size) => _SizeChip(size: size, group: group))
                    .toList(),
              ),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14.sp,
                    color: isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFFB0B0C0),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'No sizes yet. Tap + to add.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? AdminAppColors.darkTextSecondary
                          : const Color(0xFFB0B0C0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBtn(
    IconData icon,
    Color color,
    VoidCallback onTap,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }
}

// Individual size chip
class _SizeChip extends StatelessWidget {
  final String size;
  final SizeGroupModel group;
  const _SizeChip({required this.size, required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark
            ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
            : const Color(0xFFF4EBFF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AdminAppColors.primaryColor.withValues(alpha: 0.3)
              : const Color(0xFFE1BEE7),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            size,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.primaryDark,
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () {
              context.read<AdminProductConfigBloc>().add(
                RemoveSizeFromGroup(groupId: group.id, size: size),
              );
            },
            borderRadius: BorderRadius.circular(4.r),
            child: Icon(
              Icons.close,
              size: 13.sp,
              color: AdminAppColors.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
