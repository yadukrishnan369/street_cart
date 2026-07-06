import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_event.dart';
import 'package:uuid/uuid.dart';

class SizeGroupDialogs {
  // Add Group
  static void showAdd(BuildContext context) {
    _showGroupForm(context, existing: null);
  }

  // Edit Group
  static void showEdit(BuildContext context, SizeGroupModel group) {
    _showGroupForm(context, existing: group);
  }

  // Delete Group
  static void showDelete(BuildContext context, SizeGroupModel group) {
    final blocRef = context.read<AdminProductConfigBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Size Group',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1E2F),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${group.name}" and all its sizes?',
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
              blocRef.add(DeleteSizeGroup(group.id));
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

  // Add Size to Group
  static void showAddSize(BuildContext context, SizeGroupModel group) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final blocRef = context.read<AdminProductConfigBloc>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Add Size to "${group.name}"',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1E2F),
          ),
        ),
        content: SizedBox(
          width: 340.w,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  decoration: _inputDecoration('e.g. XL, 42, 10.5'),
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? 'Size cannot be empty'
                      : group.sizes
                            .map((s) => s.toLowerCase())
                            .contains(val.trim().toLowerCase())
                      ? 'Size already exists'
                      : null,
                ),
              ],
            ),
          ),
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
              if (!formKey.currentState!.validate()) return;
              blocRef.add(
                AddSizeToGroup(groupId: group.id, size: controller.text.trim()),
              );
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: const Text('Add Size'),
          ),
        ],
      ),
    );
  }

  // Shared form
  static void _showGroupForm(BuildContext context, {SizeGroupModel? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final formKey = GlobalKey<FormState>();
    final blocRef = context.read<AdminProductConfigBloc>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          existing == null ? 'Add Size Group' : 'Edit Size Group',
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
                Text(
                  'Group Name',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: _inputDecoration('e.g. Clothing, Shoes, Pants'),
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? 'Group name is required'
                      : null,
                ),
                SizedBox(height: 8.h),
                Text(
                  'You can add sizes after creating the group.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                ),
              ],
            ),
          ),
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
              if (!formKey.currentState!.validate()) return;
              final name = nameController.text.trim();

              if (existing == null) {
                blocRef.add(
                  AddSizeGroup(
                    SizeGroupModel(
                      id: const Uuid().v4(),
                      name: name,
                      sizes: [],
                    ),
                  ),
                );
              } else {
                blocRef.add(EditSizeGroup(existing.copyWith(name: name)));
              }
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(existing == null ? 'Create Group' : 'Save Changes'),
          ),
        ],
      ),
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
}
