import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_signup_ui_cubit.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_signup_form.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/verification_bottom_sheet.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopSignupPage extends StatefulWidget {
  const ShopSignupPage({super.key});

  @override
  State<ShopSignupPage> createState() => _ShopSignupPageState();
}

class _ShopSignupPageState extends State<ShopSignupPage> {
  final _ownerNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _shopNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showVerificationSheet(
    BuildContext context,
    ShopAuthVerificationWaiting state,
  ) {
    context.read<ShopSignupUiCubit>().setVerificationSheetShowing(true);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ShopAuthBloc>(),
        child: ShopVerificationBottomSheet(
          ownerName: state.ownerName,
          shopName: state.shopName,
          email: state.email,
        ),
      ),
    ).then((_) {
      if (mounted) {
        context.read<ShopSignupUiCubit>().setVerificationSheetShowing(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopSignupUiCubit(),
      child: BlocBuilder<ShopSignupUiCubit, ShopSignupUiState>(
        builder: (context, uiState) {
          return BlocListener<ShopAuthBloc, ShopAuthState>(
            listener: (context, state) {
              if (state is ShopAuthVerificationWaiting &&
                  !uiState.isVerificationSheetShowing) {
                _showVerificationSheet(context, state);
              } else if (state is ShopAuthSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopProfileSetupPage(),
                  ),
                  (route) => false,
                );
              } else if (state is ShopAuthFailure) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: Scaffold(
              backgroundColor: ShopAppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: ShopAppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Shop Signup', style: ShopAppTextStyles.heading4),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ShopSignupForm(
                  ownerNameController: _ownerNameController,
                  shopNameController: _shopNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  formKey: _formKey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
