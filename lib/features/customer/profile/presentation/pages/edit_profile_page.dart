import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_state.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/edit_profile_header.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/edit_profile_form.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/edit_profile_ui_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileModel? profile;

  const EditProfilePage({super.key, this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.profile?.fullName ?? '',
    );
    _emailController = TextEditingController(text: widget.profile?.email ?? '');
    _phoneController = TextEditingController(text: widget.profile?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await ImagePickerHelper.pickImageFromGallery();
    if (pickedFile != null && mounted) {
      context.read<ProfileBloc>().add(UploadProfileImageEvent(pickedFile));
    }
  }

  void _onRemoveImage(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    final uiCubit = context.read<EditProfileUiCubit>();
    showDialog(
      context: context,
      builder: (context) => ConfirmationModal(
        title: 'Remove Photo',
        content: 'Are you sure you want to remove your profile photo?',
        confirmText: 'Remove',
        onConfirm: () {
          Navigator.pop(context);
          profileBloc.add(RemoveProfileImageEvent());
          uiCubit.clearImageUrl();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedProfile =
        (widget.profile ??
                ProfileModel(
                  fullName: '',
                  email: '',
                  phone: '',
                  locationName: 'Unknown Location',
                  profileImageUrl: '',
                ))
            .copyWith(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              profileImageUrl:
                  context.read<EditProfileUiCubit>().state.currentImageUrl ??
                  '',
            );

    context.read<ProfileBloc>().add(UpdateProfileDataEvent(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = EditProfileUiCubit();
        cubit.init(widget.profile?.profileImageUrl, _nameController.text);
        _nameController.addListener(() {
          cubit.updateActiveName(_nameController.text);
        });
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              final uiCubit = context.read<EditProfileUiCubit>();
              if (state is ProfileLoaded) {
                if (_nameController.text.isEmpty) {
                  _nameController.text = state.profile.fullName;
                  uiCubit.updateActiveName(state.profile.fullName);
                }
                if (_emailController.text.isEmpty) {
                  _emailController.text = state.profile.email;
                }
                if (_phoneController.text.isEmpty) {
                  _phoneController.text = state.profile.phone;
                }
                if (uiCubit.state.currentImageUrl == null) {
                  uiCubit.finishUploading(state.profile.profileImageUrl);
                }
              } else if (state is ProfileUpdateSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Profile updated successfully!',
                );
                Navigator.pop(context);
              } else if (state is ProfileError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              } else if (state is ProfileImageUploading) {
                uiCubit.startUploading();
              } else if (state is ProfileImageUploaded) {
                uiCubit.finishUploading(state.imageUrl);
                CustomSnackBar.show(
                  context,
                  message: 'Image uploaded successfully!',
                );
              }
            },
            child: BlocBuilder<EditProfileUiCubit, EditProfileUiState>(
              builder: (context, uiState) {
                final isUploading = uiState.isUploadingProfilePic;

                return Scaffold(
                  backgroundColor: CustomerAppColors.background,
                  appBar: AppBar(
                    backgroundColor: CustomerAppColors.background,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditProfileHeader(
                            profile:
                                (widget.profile ??
                                        ProfileModel(
                                          fullName: '',
                                          email: '',
                                          phone: '',
                                          locationName: '',
                                          profileImageUrl: '',
                                        ))
                                    .copyWith(
                                      profileImageUrl: uiState.currentImageUrl,
                                    ),
                            activeName: uiState.activeName,
                            onPickImage: isUploading
                                ? null
                                : () => _pickImage(context),
                            onRemoveImage: isUploading
                                ? null
                                : () => _onRemoveImage(context),
                            isUploading: isUploading,
                          ),
                          SizedBox(height: 32.h),
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              return EditProfileForm(
                                formKey: _formKey,
                                nameController: _nameController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                onSave: () => _saveProfile(context),
                                isLoading: state is ProfileLoading,
                                isImageUploading: isUploading,
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
