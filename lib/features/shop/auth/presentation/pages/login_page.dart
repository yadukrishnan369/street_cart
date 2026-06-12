import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/signup_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/forgot_password_page.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopLoginPage extends StatefulWidget {
  const ShopLoginPage({super.key});

  @override
  State<ShopLoginPage> createState() => _ShopLoginPageState();
}

class _ShopLoginPageState extends State<ShopLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        if (state is ShopAuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ShopHomePage()),
            (route) => false,
          );
        } else if (state is ShopAuthFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: ShopAppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Shop Login', style: ShopAppTextStyles.heading4),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                margin: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/shop_login_header.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: ShopAppTextStyles.heading1),
                      SizedBox(height: 8.h),
                      Text(
                        'Log in to manage your shop and reach millions of customers across our network.',
                        style: ShopAppTextStyles.bodyMedium,
                      ),
                      SizedBox(height: 24.h),

                      CustomTextField(
                        label: "Business Email",
                        controller: _emailController,
                        hintText: 'e.g. name@business.com',
                        validator: Validators.validateEmail,
                        labelStyle: ShopAppTextStyles.bodyMediumBold,
                        textStyle: ShopAppTextStyles.bodyMedium,
                        hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                          color: ShopAppColors.textTertiary,
                        ),
                        fillColor: ShopAppColors.surface,
                        borderColor: ShopAppColors.border,
                        focusedBorderColor: ShopAppColors.primary,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ShopAppColors.textSecondary,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      CustomTextField(
                        label: "Password",
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        isPassword: !_isPasswordVisible,
                        validator: Validators.validatePassword,
                        labelStyle: ShopAppTextStyles.bodyMediumBold,
                        textStyle: ShopAppTextStyles.bodyMedium,
                        hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                          color: ShopAppColors.textTertiary,
                        ),
                        fillColor: ShopAppColors.surface,
                        borderColor: ShopAppColors.border,
                        focusedBorderColor: ShopAppColors.primary,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: ShopAppColors.textSecondary,
                          size: 20.sp,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: ShopAppColors.textSecondary,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        labelTrailing: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 48.h),

                      BlocBuilder<ShopAuthBloc, ShopAuthState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            text: 'Login',
                            isLoading: state is ShopAuthLoading,
                            backgroundColor: ShopAppColors.primary,
                            textStyle: ShopAppTextStyles.buttonText,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ShopAuthBloc>().add(
                                  ShopLoginStarted(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New seller? ',
                            style: ShopAppTextStyles.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShopSignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Create Shop Account',
                              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                color: ShopAppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_person_outlined,
                              size: 14.sp,
                              color: ShopAppColors.textTertiary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'SECURE MERCHANT AUTHENTICATION',
                              style: ShopAppTextStyles.caption.copyWith(
                                color: ShopAppColors.textTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
