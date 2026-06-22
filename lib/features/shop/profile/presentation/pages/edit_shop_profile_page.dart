import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step1_info.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step2_address.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step3_verification.dart';
import 'package:street_cart/core/constants/profile_constants.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_payment_settings_cubit.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_categories_cubit.dart';

class EditShopProfilePage extends StatefulWidget {
  final ShopProfileModel profile;

  const EditShopProfilePage({super.key, required this.profile});

  @override
  State<EditShopProfilePage> createState() => _EditShopProfilePageState();
}

class _EditShopProfilePageState extends State<EditShopProfilePage> {
  int _currentStep = 1;
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

  String? _selectedCategory;
  String? _profileImageUrl;
  String? _businessLicenseUrl;
  String? _ownerIdUrl;

  String? _selectedDistrict;
  String? _selectedState;
  List<String> _selectedPaymentMethods = [];

  bool _isUploadingImage = false;
  bool _isUploadingLicense = false;
  bool _isUploadingOwnerId = false;

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

    _selectedCategory = p.category;
    _profileImageUrl = p.profileImageUrl;
    _businessLicenseUrl = p.businessLicenseUrl;
    _ownerIdUrl = p.ownerIdUrl;

    _selectedDistrict = ProfileConstants.districts.contains(p.district) ? p.district : null;
    _selectedState = ProfileConstants.states.contains(p.state) ? p.state : null;
    _selectedPaymentMethods = List<String>.from(p.paymentMethods);
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

  Future<void> _pickProfileImage() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null && mounted) {
      context.read<ShopProfileBloc>().add(UploadShopProfileImageEvent(file));
      setState(() => _isUploadingImage = true);
    }
  }

  Future<void> _pickLicense() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null && mounted) {
      setState(() => _isUploadingLicense = true);
      try {
        final url = await context.read<ShopProfileBloc>().uploadProfileImage(
          file,
        );
        setState(() {
          _businessLicenseUrl = url;
          _isUploadingLicense = false;
        });
        CustomSnackBar.show(context, message: 'License uploaded successfully!');
      } catch (e) {
        setState(() => _isUploadingLicense = false);
        CustomSnackBar.show(
          context,
          message: 'Failed to upload license: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _pickOwnerId() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null && mounted) {
      setState(() => _isUploadingOwnerId = true);
      try {
        final url = await context.read<ShopProfileBloc>().uploadProfileImage(
          file,
        );
        setState(() {
          _ownerIdUrl = url;
          _isUploadingOwnerId = false;
        });
        CustomSnackBar.show(
          context,
          message: 'Owner ID uploaded successfully!',
        );
      } catch (e) {
        setState(() => _isUploadingOwnerId = false);
        CustomSnackBar.show(
          context,
          message: 'Failed to upload ID: $e',
          isError: true,
        );
      }
    }
  }

  void _onRemoveProfileImage() {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Remove Profile Photo',
        content: 'Are you sure you want to remove your profile photo?',
        confirmText: 'Remove',
        cancelText: 'Cancel',
        confirmColor: Colors.redAccent,
        onCancel: () {
          Navigator.pop(dialogContext);
        },
        onConfirm: () {
          Navigator.pop(dialogContext);
          context.read<ShopProfileBloc>().add(RemoveShopProfileImageEvent());
        },
      ),
    );
  }

  void _goToStep2() {
    if (_formKeyStep1.currentState!.validate()) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _goToStep3() {
    if (_formKeyStep2.currentState!.validate()) {
      if (_selectedDistrict == null) {
        CustomSnackBar.show(
          context,
          message: 'Please select a District',
          isError: true,
        );
        return;
      }
      if (_selectedState == null) {
        CustomSnackBar.show(
          context,
          message: 'Please select a State',
          isError: true,
        );
        return;
      }
      if (_selectedPaymentMethods.isEmpty) {
        CustomSnackBar.show(
          context,
          message: 'Please select at least one Payment Method',
          isError: true,
        );
        return;
      }
      setState(() {
        _currentStep = 3;
      });
    }
  }

  void _saveChanges() {
    if (!_formKeyStep3.currentState!.validate()) {
      return;
    }

    if (_businessLicenseUrl == null || _businessLicenseUrl!.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please upload business license document',
        isError: true,
      );
      return;
    }

    if (_ownerIdUrl == null || _ownerIdUrl!.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please upload owner ID document',
        isError: true,
      );
      return;
    }

    final updated = widget.profile.copyWith(
      ownerName: _ownerNameController.text.trim(),
      shopName: _shopNameController.text.trim(),
      description: _descriptionController.text.trim(),
      fullAddress: _fullAddressController.text.trim(),
      landmark: _landmarkController.text.trim(),
      city: _cityController.text.trim(),
      pincode: _pincodeController.text.trim(),
      district: _selectedDistrict ?? '',
      state: _selectedState ?? '',
      paymentMethods: _selectedPaymentMethods,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      gstNumber: _gstController.text.trim(),
      category: _selectedCategory,
      profileImageUrl: _profileImageUrl ?? '',
      businessLicenseUrl: _businessLicenseUrl ?? '',
      ownerIdUrl: _ownerIdUrl ?? '',
      isProfileCompleted: true,
      isApproved: widget.profile.isApproved,
      isRejected: widget.profile.isApproved ? false : widget.profile.isRejected,
      rejectionReason: widget.profile.isApproved ? widget.profile.rejectionReason : '',
      isReRegistered: widget.profile.isApproved ? false : (widget.profile.isRejected ? true : widget.profile.isReRegistered),
    );

    context.read<ShopProfileBloc>().add(UpdateShopProfileDataEvent(updated));
  }

  @override
  Widget build(BuildContext context) {
    final isUploadingAny =
        _isUploadingImage || _isUploadingLicense || _isUploadingOwnerId;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopPaymentSettingsCubit>(
          create: (context) => sl<ShopPaymentSettingsCubit>()..loadPaymentSettings(),
        ),
        BlocProvider<ShopCategoriesCubit>(
          create: (context) => sl<ShopCategoriesCubit>()..loadCategories(),
        ),
      ],
      child: BlocListener<ShopProfileBloc, ShopProfileState>(
        listener: (context, state) {
        if (state is ShopProfileImageUploaded) {
          setState(() {
            _profileImageUrl = state.imageUrl;
            _isUploadingImage = false;
          });
          CustomSnackBar.show(context, message: 'Profile picture updated!');
        } else if (state is ShopProfileUpdateSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Profile updated successfully!',
          );
          Navigator.pop(context);
        } else if (state is ShopProfileError) {
          setState(() {
            _isUploadingImage = false;
          });
          CustomSnackBar.show(context, message: state.message, isError: true);
        } else if (state is ShopProfileImageRemoved) {
          setState(() {
            _profileImageUrl = '';
            _isUploadingImage = false;
          });
          CustomSnackBar.show(context, message: 'Profile picture removed!');
        }
      },
      child: Scaffold(
        backgroundColor: ShopAppColors.background,
        appBar: AppBar(
          backgroundColor: ShopAppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
            onPressed: () {
              if (_currentStep == 3) {
                setState(() => _currentStep = 2);
              } else if (_currentStep == 2) {
                setState(() => _currentStep = 1);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Edit Profile',
            style: ShopAppTextStyles.heading4.copyWith(
              color: ShopAppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentStep == 1)
                BlocBuilder<ShopCategoriesCubit, ShopCategoriesState>(
                  builder: (context, state) {
                    List<String> categories = [];
                    if (state is ShopCategoriesLoaded) {
                      categories = state.categories;
                    }
                    
                    if (categories.isNotEmpty && (_selectedCategory == null || _selectedCategory!.isEmpty || !categories.contains(_selectedCategory))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedCategory = categories.first;
                          });
                        }
                      });
                    }

                    return EditStep1Info(
                      formKey: _formKeyStep1,
                      ownerNameController: _ownerNameController,
                      shopNameController: _shopNameController,
                      descriptionController: _descriptionController,
                      profileImageUrl: _profileImageUrl,
                      onPickImage: _pickProfileImage,
                      onRemoveImage: _onRemoveProfileImage,
                      isUploadingImage: _isUploadingImage,
                      selectedCategory: _selectedCategory,
                      categories: categories.isNotEmpty ? categories : (widget.profile.category.isNotEmpty ? [widget.profile.category] : []),
                      onCategoryChanged: (val) =>
                          setState(() => _selectedCategory = val),
                    );
                  },
                )
               else if (_currentStep == 2)
                BlocBuilder<ShopPaymentSettingsCubit, ShopPaymentSettingsState>(
                  builder: (context, state) {
                    bool enableCod = true;
                    bool enableOnline = true;

                    if (state is ShopPaymentSettingsLoaded) {
                      enableCod = state.settings['enable_cod'] ?? true;
                      enableOnline = state.settings['enable_online'] ?? true;
                    }

                    return EditStep2Address(
                      formKey: _formKeyStep2,
                      fullAddressController: _fullAddressController,
                      landmarkController: _landmarkController,
                      cityController: _cityController,
                      pincodeController: _pincodeController,
                      selectedDistrict: _selectedDistrict,
                      districts: ProfileConstants.districts,
                      onDistrictChanged: (val) =>
                          setState(() => _selectedDistrict = val),
                      selectedState: _selectedState,
                      states: ProfileConstants.states,
                      onStateChanged: (val) => setState(() => _selectedState = val),
                      selectedPaymentMethods: _selectedPaymentMethods,
                      enableCod: enableCod,
                      enableOnline: enableOnline,
                      onPaymentMethodChanged: (method, isSelected) {
                        setState(() {
                          if (isSelected) {
                            if (!_selectedPaymentMethods.contains(method)) {
                              _selectedPaymentMethods.add(method);
                            }
                          } else {
                            _selectedPaymentMethods.remove(method);
                          }
                        });
                      },
                    );
                  },
                )
              else
                EditStep3Verification(
                  formKey: _formKeyStep3,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  gstController: _gstController,
                  businessLicenseUrl: _businessLicenseUrl,
                  ownerIdUrl: _ownerIdUrl,
                  isUploadingLicense: _isUploadingLicense,
                  isUploadingOwnerId: _isUploadingOwnerId,
                  onPickLicense: _pickLicense,
                  onPickOwnerId: _pickOwnerId,
                  onClearLicense: () =>
                      setState(() => _businessLicenseUrl = ''),
                  onClearOwnerId: () => setState(() => _ownerIdUrl = ''),
                ),
              SizedBox(height: 40.h),
              PrimaryButton(
                text: isUploadingAny
                    ? 'Uploading...'
                    : (_currentStep == 3 ? 'Save Changes' : 'Next'),
                backgroundColor: isUploadingAny
                    ? Colors.grey
                    : ShopAppColors.primary,
                textStyle: ShopAppTextStyles.buttonText,
                suffixIcon: isUploadingAny
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : (_currentStep == 3
                          ? null
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )),
                prefixIcon: isUploadingAny
                    ? null
                    : (_currentStep == 3
                          ? const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            )
                          : null),
                onPressed: isUploadingAny
                    ? null
                    : () {
                        if (_currentStep == 1) {
                          _goToStep2();
                        } else if (_currentStep == 2) {
                          _goToStep3();
                        } else {
                          _saveChanges();
                        }
                      },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
