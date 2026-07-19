import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_profile_setup_form.dart';
import 'package:street_cart/features/shop/location/presentation/pages/shop_location_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Profile Setup Page
class ShopProfileSetupPage extends StatefulWidget {
  const ShopProfileSetupPage({super.key});

  @override
  State<ShopProfileSetupPage> createState() => _ShopProfileSetupPageState();
}

class _ShopProfileSetupPageState extends State<ShopProfileSetupPage> {
  @override
  void initState() {
    super.initState();
    // Fetch business categories list
    context.read<ShopAuthBloc>().add(ShopLoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        final bool isSuccess =
            state.status == ShopAuthStatus.authenticated ||
            (state.shop != null &&
                state.shop!.isProfileCompleted &&
                !state.shop!.isRejected);

        if (isSuccess && !state.isProfileSetupNavigated) {
          context.read<ShopAuthBloc>().add(ShopMarkProfileSetupNavigated());
          // Navigate to Shop Location Permission Page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ShopLocationPermissionPage(),
            ),
            (route) => false,
          );
        } else if (state.status == ShopAuthStatus.failure &&
            state.errorMessage != null) {
          CustomSnackBar.show(context, message: state.errorMessage!);
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
          // Page Header
          title: Text('Profile Setup', style: ShopAppTextStyles.heading4),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          // Shop Profile Setup Form Section
          child: const ShopProfileSetupForm(),
        ),
      ),
    );
  }
}
