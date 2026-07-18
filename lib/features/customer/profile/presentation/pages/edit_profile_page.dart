import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_state.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/edit_profile_header.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/edit_profile_form.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/presentation/utils/profile_helper.dart';

// Edit Profile Page
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(
          UpdateActiveNameEvent(_nameController.text),
        );
      }
    });

    // Update Active Name
    _nameController.addListener(() {
      context.read<ProfileBloc>().add(
        UpdateActiveNameEvent(_nameController.text),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (_nameController.text.isEmpty) {
            _nameController.text = state.profile.fullName;
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = state.profile.email;
          }
          if (_phoneController.text.isEmpty) {
            _phoneController.text = state.profile.phone;
          }
        } else if (state is ProfileUpdateSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Profile updated successfully!',
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        } else if (state is ProfileImageUploaded) {
          CustomSnackBar.show(context, message: 'Image uploaded successfully!');
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profileState = state is ProfileLoaded ? state : null;
          final currentImageUrl = profileState?.editImageUrl;
          final activeName = profileState?.editActiveName ?? '';
          final isUploading = profileState?.isUploadingImage ?? false;

          return Scaffold(
            backgroundColor: CustomerAppColors.background,
            appBar: AppBar(
              backgroundColor: CustomerAppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              // Page Header
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Header
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
                              .copyWith(profileImageUrl: currentImageUrl),
                      activeName: activeName,
                      onPickImage: isUploading
                          ? null
                          : () => ProfileHelper.pickImage(context),
                      onRemoveImage: isUploading
                          ? null
                          : () => ProfileHelper.onRemoveImage(context),
                      isUploading: isUploading,
                    ),
                    SizedBox(height: 32.h),
                    // Form Fields Section
                    EditProfileForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      onSave: () => ProfileHelper.saveProfile(
                        context: context,
                        formKey: _formKey,
                        originalProfile: widget.profile,
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        currentImageUrl: currentImageUrl,
                      ),
                      isLoading: state is ProfileLoading,
                      isImageUploading: isUploading,
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
  }
}
