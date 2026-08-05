import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

// Edit Profile Overlay
class EditProfileOverlay extends StatefulWidget {
  final String currentName;
  final String email;
  final VoidCallback onClose;
  final Function(String) onSave;

  const EditProfileOverlay({
    super.key,
    required this.currentName,
    required this.email,
    required this.onClose,
    required this.onSave,
  });

  @override
  State<EditProfileOverlay> createState() => _EditProfileOverlayState();
}

class _EditProfileOverlayState extends State<EditProfileOverlay> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Colors.black.withValues(alpha: 0.15),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width > 600
                ? 450.w
                : double.infinity,
            margin: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AdminAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : AdminAppColors.borderLight,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Profile',
                        style: AdminAppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AdminAppColors.darkTextPrimary
                              : AdminAppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFECEFF1),
                  height: 1,
                ),

                // Form Content
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Update your personal information below. Please note that security credentials cannot be changed directly.',
                          style: AdminAppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AdminAppColors.darkTextSecondary
                                : const Color(0xFF8A8A9E),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Name Field
                        Text(
                          'FULL NAME',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AdminAppColors.darkTextSecondary
                                : const Color(0xFF8A8A9E),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _nameController,
                          style: AdminAppTextStyles.bodyMedium.copyWith(
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter full name',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AdminAppColors.darkBorder
                                    : const Color(0xFFECEFF1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AdminAppColors.darkBorder
                                    : const Color(0xFFECEFF1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: AdminAppColors.primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Email Field Read-only / Disabled
                        Row(
                          children: [
                            Text(
                              'EMAIL ADDRESS',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AdminAppColors.darkTextSecondary
                                    : const Color(0xFF8A8A9E),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Tooltip(
                              message: 'Cannot edit email ID',
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(
                                Icons.info_outline,
                                size: 14.sp,
                                color: isDark
                                    ? AdminAppColors.darkTextSecondary
                                    : const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Email Field
                        Tooltip(
                          message: 'Cannot edit email ID',
                          triggerMode: TooltipTriggerMode.tap,
                          child: TextFormField(
                            initialValue: widget.email,
                            enabled: false,
                            style: AdminAppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AdminAppColors.darkTextSecondary
                                  : const Color(0xFF8A8A9E),
                            ),
                            decoration: InputDecoration(
                              fillColor: isDark
                                  ? AdminAppColors.darkInputBackground
                                  : const Color(0xFFF5F7F8),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? AdminAppColors.darkBorder
                                      : const Color(0xFFECEFF1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: widget.onClose,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark
                                      ? AdminAppColors.darkBorder
                                      : const Color(0xFFECEFF1),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 14.h,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Button for Save
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => ConfirmationModal(
                                      title: 'Save Changes',
                                      content:
                                          'Are you sure you want to save these changes?',
                                      confirmText: 'Save',
                                      confirmColor: AdminAppColors.primaryColor,
                                      surfaceColor: isDark
                                          ? AdminAppColors.darkSurface
                                          : Colors.white,
                                      onConfirm: () {
                                        Navigator.pop(dialogContext);
                                        widget.onSave(
                                          _nameController.text.trim(),
                                        );
                                      },
                                      onCancel: () =>
                                          Navigator.pop(dialogContext),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AdminAppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 14.h,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
