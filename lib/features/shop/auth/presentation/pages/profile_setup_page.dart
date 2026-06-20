import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_categories_cubit.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_profile_setup_form.dart';
import 'package:street_cart/features/shop/location/presentation/pages/shop_location_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';

class ShopProfileSetupPage extends StatelessWidget {
  const ShopProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopCategoriesCubit>(
      create: (context) => sl<ShopCategoriesCubit>()..loadCategories(),
      child: BlocListener<ShopAuthBloc, ShopAuthState>(
        listener: (context, state) {
          if (state is ShopAuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ShopLocationPermissionPage(),
              ),
              (route) => false,
            );
          } else if (state is ShopAuthFailure) {
            CustomSnackBar.show(context, message: state.message);
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
            title: Text(
              'Profile Setup',
              style: ShopAppTextStyles.heading4,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const ShopProfileSetupForm(),
          ),
        ),
      ),
    );
  }
}
