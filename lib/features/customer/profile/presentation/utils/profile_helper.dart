import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

// Profile Helper
class ProfileHelper {
  // Validates the Profile Form and Save
  static void saveProfile({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required ProfileModel? originalProfile,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required String? currentImageUrl,
  }) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final updatedProfile =
        (originalProfile ??
                ProfileModel(
                  fullName: '',
                  email: '',
                  phone: '',
                  locationName: 'Unknown Location',
                  profileImageUrl: '',
                ))
            .copyWith(
              fullName: nameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              profileImageUrl: currentImageUrl ?? '',
            );

    context.read<ProfileBloc>().add(UpdateProfileDataEvent(updatedProfile));
  }

  // Pick new Profile Image from Gallery
  static Future<void> pickImage(BuildContext context) async {
    final pickedFile = await ImagePickerHelper.pickImageFromGallery();
    if (pickedFile != null && context.mounted) {
      context.read<ProfileBloc>().add(UploadProfileImageEvent(pickedFile));
    }
  }

  // Show Dialog to Confirm Profile Image Removal
  static void onRemoveImage(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    showDialog(
      context: context,
      builder: (context) => ConfirmationModal(
        title: 'Remove Photo',
        content: 'Are you sure you want to remove your profile photo?',
        confirmText: 'Remove',
        onConfirm: () {
          Navigator.pop(context);
          profileBloc.add(RemoveProfileImageEvent());
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
