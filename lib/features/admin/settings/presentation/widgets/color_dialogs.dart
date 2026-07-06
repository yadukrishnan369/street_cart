import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_event.dart';
import 'package:uuid/uuid.dart';

class ColorDialogs {
  // Add Color
  static void showAdd(BuildContext context) {
    _showColorForm(context, existing: null);
  }

  // Edit Color
  static void showEdit(BuildContext context, ColorModel color) {
    _showColorForm(context, existing: color);
  }

  // Delete Color
  static void showDelete(BuildContext context, ColorModel color) {
    final blocRef = context.read<AdminProductConfigBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Color',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1E2F),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${color.name}"? This cannot be undone.',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF8A8A9E)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: const Color(0xFF8A8A9E), fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              blocRef.add(DeleteColor(color.id));
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppColors.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Shared form
  static void _showColorForm(BuildContext context, {ColorModel? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final hexController = TextEditingController(text: existing?.hexCode ?? '#');
    final formKey = GlobalKey<FormState>();
    final blocRef = context.read<AdminProductConfigBloc>();

    Color previewColor = _hexToColor(existing?.hexCode ?? '#8E24AA');

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                existing == null ? 'Add Color' : 'Edit Color',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              content: SizedBox(
                width: 380.w,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      Text(
                        'Color Name',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration('e.g. Crimson Red'),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      SizedBox(height: 16.h),

                      // Hex code
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hex Code',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E2F),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '''Don't know the hex code? Simply search the color name on Google''',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: hexController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[#0-9a-fA-F]'),
                                ),
                                LengthLimitingTextInputFormatter(7),
                              ],
                              onChanged: (val) {
                                if (val.length == 7 && val.startsWith('#')) {
                                  setDialogState(() {
                                    previewColor = _hexToColor(val);
                                  });
                                }
                              },
                              decoration: _inputDecoration('#FF5733'),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Hex code is required';
                                }
                                final cleaned = val.trim();
                                if (!RegExp(
                                  r'^#[0-9A-Fa-f]{6}$',
                                ).hasMatch(cleaned)) {
                                  return 'Enter a valid hex (e.g. #FF5733)';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Color preview circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: previewColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AdminAppColors.borderLight,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: previewColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Quick color presets
                      SizedBox(height: 16.h),
                      Text(
                        'Quick Presets',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8A9E),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: AdminConstants.colorPresets.map((preset) {
                          return GestureDetector(
                            onTap: () {
                              hexController.text = preset['hex']!;
                              if (nameController.text.isEmpty) {
                                nameController.text = preset['name']!;
                              }
                              setDialogState(() {
                                previewColor = _hexToColor(preset['hex']!);
                              });
                            },
                            child: Tooltip(
                              message: preset['name']!,
                              child: Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: _hexToColor(preset['hex']!),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AdminAppColors.borderLight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color(0xFF8A8A9E),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final name = nameController.text.trim();
                    final hex = hexController.text.trim().toUpperCase();

                    if (existing == null) {
                      blocRef.add(
                        AddColor(
                          ColorModel(
                            id: const Uuid().v4(),
                            name: name,
                            hexCode: hex,
                          ),
                        ),
                      );
                    } else {
                      blocRef.add(
                        EditColor(existing.copyWith(name: name, hexCode: hex)),
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminAppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(existing == null ? 'Add Color' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFB0B0C0)),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFFE8E7ED)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFFE8E7ED)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(
          color: AdminAppColors.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AdminAppColors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AdminAppColors.errorColor),
      ),
    );
  }

  static Color _hexToColor(String hex) {
    try {
      final cleaned = hex.replaceAll('#', '');
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
    } catch (_) {}
    return AdminAppColors.primaryColor;
  }
}
