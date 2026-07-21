import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_state.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/color_dialogs.dart';

// Colors Tab
class ColorsTab extends StatelessWidget {
  const ColorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductConfigBloc, AdminProductConfigState>(
      builder: (context, state) {
        final config = _resolveConfig(state);
        final colors = config.colors;
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
                      'Product Colors',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${colors.length} color${colors.length == 1 ? '' : 's'} available globally',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => ColorDialogs.showAdd(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Color'),
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

            // Empty state
            if (colors.isEmpty) _emptyState() else _colorGrid(context, colors),
          ],
        );
      },
    );
  }

  Widget _colorGrid(BuildContext context, List<ColorModel> colors) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: colors.map((color) => _ColorChip(color: color)).toList(),
    );
  }

  // Empty State
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EBFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.palette_outlined,
                size: 40.sp,
                color: AdminAppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No colors yet',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Add your first product color to get started.',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF8A8A9E)),
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

// Color chip tile
class _ColorChip extends StatelessWidget {
  final ColorModel color;
  const _ColorChip({required this.color});

  Color get _parsedColor {
    try {
      final hex = color.hexCode.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (_) {}
    return AdminAppColors.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color dot
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: _parsedColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: _parsedColor == Colors.white
                    ? const Color(0xFFE8E7ED)
                    : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: _parsedColor.withOpacity(0.35),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color Name
              Text(
                color.name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              // Color HEX Code
              Text(
                color.hexCode.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF8A8A9E),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Actions
          _ActionButton(
            icon: Icons.edit_outlined,
            color: AdminAppColors.primaryColor,
            onTap: () => ColorDialogs.showEdit(context, color),
          ),
          SizedBox(width: 6.w),
          _ActionButton(
            icon: Icons.delete_outline,
            color: AdminAppColors.errorColor,
            onTap: () => ColorDialogs.showDelete(context, color),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 16.sp, color: color),
      ),
    );
  }
}
