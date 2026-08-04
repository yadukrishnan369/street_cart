import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_shop_profile_form_steps.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_shop_profile_submit_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Edit Shop Profile Page
class EditShopProfilePage extends StatefulWidget {
  final ShopProfileModel profile;

  const EditShopProfilePage({super.key, required this.profile});

  @override
  State<EditShopProfilePage> createState() => _EditShopProfilePageState();
}

class _EditShopProfilePageState extends State<EditShopProfilePage> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  late TextEditingController _ownerNameController;
  late TextEditingController _shopNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _fullAddressController;
  late TextEditingController _landmarkController;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _gstController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _ownerNameController = TextEditingController(text: p.ownerName);
    _shopNameController = TextEditingController(text: p.shopName);
    _descriptionController = TextEditingController(text: p.description);
    _fullAddressController = TextEditingController(text: p.fullAddress);
    _landmarkController = TextEditingController(text: p.landmark);
    _cityController = TextEditingController(text: p.city);
    _pincodeController = TextEditingController(text: p.pincode);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phone);
    _gstController = TextEditingController(text: p.gstNumber);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProfileBloc>().add(FetchShopPaymentSettings());
      context.read<ShopAuthBloc>().add(ShopLoadCategories());
      context.read<ShopProfileBloc>().add(EditProfileInitEvent(widget.profile));
    });
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _shopNameController.dispose();
    _descriptionController.dispose();
    _fullAddressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopProfileBloc, ShopProfileState>(
      listener: (context, state) {
        if (state.status == ShopProfileStatus.imageUploaded) {
          context.read<ShopProfileBloc>().add(UpdateUploadingImageEvent(false));
          CustomSnackBar.show(context, message: 'Profile picture updated!');
        } else if (state.status == ShopProfileStatus.updateSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Profile updated successfully!',
          );
          Navigator.pop(context);
        } else if (state.status == ShopProfileStatus.error) {
          context.read<ShopProfileBloc>().add(UpdateUploadingImageEvent(false));
          CustomSnackBar.show(
            context,
            message: state.message ?? 'Operation failed',
            isError: true,
          );
        } else if (state.status == ShopProfileStatus.imageRemoved) {
          context.read<ShopProfileBloc>().add(UpdateUploadingImageEvent(false));
          CustomSnackBar.show(context, message: 'Profile picture removed!');
        }
      },
      builder: (context, uiState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? ShopAppColors.darkBackground
              : ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: isDark
                ? ShopAppColors.darkBackground
                : ShopAppColors.background,
            elevation: isDark ? null : 1.0,
            shape: Border(
              bottom: BorderSide(
                color: isDark
                    ? ShopAppColors.darkBorder
                    : ShopAppColors.border.withValues(alpha: 1.0),
                width: 0.5,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
              ),
              onPressed: () {
                if (uiState.currentStep == 3) {
                  context.read<ShopProfileBloc>().add(const UpdateStepEvent(2));
                } else if (uiState.currentStep == 2) {
                  context.read<ShopProfileBloc>().add(const UpdateStepEvent(1));
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            // Page Header
            title: Text(
              'Edit Profile',
              style: ShopAppTextStyles.heading4.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: uiState.status == ShopProfileStatus.paymentSettingsError
              // App Error View
              ? AppErrorView(
                  message: uiState.message ?? 'Failed to load configuration.',
                  onRetry: () {
                    context.read<ShopProfileBloc>().add(
                      FetchShopPaymentSettings(),
                    );
                  },
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Edit Shop Profile Form Steps
                      EditShopProfileFormSteps(
                        profile: widget.profile,
                        uiState: uiState,
                        formKeyStep1: _formKeyStep1,
                        formKeyStep2: _formKeyStep2,
                        formKeyStep3: _formKeyStep3,
                        ownerNameController: _ownerNameController,
                        shopNameController: _shopNameController,
                        descriptionController: _descriptionController,
                        fullAddressController: _fullAddressController,
                        landmarkController: _landmarkController,
                        cityController: _cityController,
                        pincodeController: _pincodeController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        gstController: _gstController,
                      ),
                      SizedBox(height: 40.h),
                      // Submit Button
                      EditShopProfileSubmitButton(
                        profile: widget.profile,
                        uiState: uiState,
                        formKeyStep1: _formKeyStep1,
                        formKeyStep2: _formKeyStep2,
                        formKeyStep3: _formKeyStep3,
                        ownerNameController: _ownerNameController,
                        shopNameController: _shopNameController,
                        descriptionController: _descriptionController,
                        fullAddressController: _fullAddressController,
                        landmarkController: _landmarkController,
                        cityController: _cityController,
                        pincodeController: _pincodeController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        gstController: _gstController,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
