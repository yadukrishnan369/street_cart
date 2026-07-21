import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Add Edit Category Dialog
class AddEditCategoryDialog extends StatefulWidget {
  final String title;
  final String description;
  final String? initialName;
  final List<String> existingNames;
  final Function(String) onConfirm;

  const AddEditCategoryDialog({
    super.key,
    required this.title,
    required this.description,
    this.initialName,
    required this.existingNames,
    required this.onConfirm,
  });

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _validationError = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _controller.text = widget.initialName!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _validationError.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      _validationError.value = 'Category Name cannot be empty';
      return;
    }

    // Duplicate check
    final isDuplicate = widget.existingNames.any((existingName) {
      if (widget.initialName != null &&
          existingName.toLowerCase() == widget.initialName!.toLowerCase()) {
        return false;
      }
      return existingName.toLowerCase() == name.toLowerCase();
    });

    if (isDuplicate) {
      _validationError.value = 'Category already exists.';
      return;
    }

    _validationError.value = null;
    Navigator.pop(context);
    widget.onConfirm(name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AdminAppColors.surfaceWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4EBFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    // Title
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Description
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A8A9E),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),

              // Text Field
              TextFormField(
                controller: _controller,
                autofocus: true,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF1E1E2F),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                  fillColor: const Color(0xFFF9FAFC),
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE8E7ED)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AdminAppColors.primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onChanged: (_) {
                  if (_validationError.value != null) {
                    _validationError.value = null;
                  }
                },
                onFieldSubmitted: (_) => _validateAndSubmit(),
              ),

              ValueListenableBuilder<String?>(
                valueListenable: _validationError,
                builder: (_, error, __) {
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      error,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AdminAppColors.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminAppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.initialName != null
                          ? 'Save Changes'
                          : 'Add Category',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
