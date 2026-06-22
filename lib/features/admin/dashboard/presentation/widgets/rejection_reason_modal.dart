import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class RejectionReasonModal extends StatefulWidget {
  final Function(String reason) onSubmit;

  const RejectionReasonModal({super.key, required this.onSubmit});

  @override
  State<RejectionReasonModal> createState() => _RejectionReasonModalState();
}

class _RejectionReasonModalState extends State<RejectionReasonModal> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showDoubleConfirmation() {
    if (!_formKey.currentState!.validate()) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationModal(
          title: 'Confirm Rejection',
          content: 'Are you sure you want to reject this shop registration? This will notify the shop with the reason and they must resubmit to be considered again.',
          confirmText: 'Yes, Reject',
          cancelText: 'Cancel',
          confirmColor: AdminAppColors.errorColor,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop(); // Pop confirmation
            Navigator.of(context).pop(); // Pop modal itself
            widget.onSubmit(_reasonController.text.trim());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reject Registration',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Color(0xFF8A8A9E)),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Please provide the reason for rejecting this application. The owner will see this and will be prompted to correct the errors and resubmit their details.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AdminAppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Rejection Reason',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AdminAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _reasonController,
                maxLines: 5,
                maxLength: 500,
                style: TextStyle(fontSize: 14.sp, color: AdminAppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g., Business License is expired or Owner ID proof is blurry.',
                  hintStyle: TextStyle(color: const Color(0xFF8A8A9E), fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AdminAppColors.primaryColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AdminAppColors.errorColor, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AdminAppColors.errorColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid rejection reason';
                  }
                  if (value.trim().length < 10) {
                    return 'Please provide a more detailed reason (at least 10 characters)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      side: const BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: const Color(0xFF8A8A9E), fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: _showDoubleConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminAppColors.errorColor,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Send Rejection',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
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
