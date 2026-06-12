import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/location/domain/usecases/request_shop_location_and_save.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/account_review_page.dart';
import 'package:get_it/get_it.dart';

class ShopLocationPermissionPage extends StatefulWidget {
  final bool isFromProfile;
  const ShopLocationPermissionPage({super.key, this.isFromProfile = false});

  @override
  State<ShopLocationPermissionPage> createState() =>
      _ShopLocationPermissionPageState();
}

class _ShopLocationPermissionPageState
    extends State<ShopLocationPermissionPage> {
  bool _isLoading = false;

  Future<void> _handlePermission() async {
    setState(() => _isLoading = true);
    try {
      final requestLocation = GetIt.I<RequestShopLocationAndSave>();
      final success = await requestLocation();

      if (success) {
        if (!mounted) return;
        if (widget.isFromProfile) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountReviewPage()),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      // Since LocationException overrides toString() to return the message property,
      // e.toString() directly yields the friendly message.
      CustomSnackBar.show(context, message: e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onSkip() async {
    if (widget.isFromProfile) {
      Navigator.pop(context);
      return;
    }
    try {
      final skipLocation = GetIt.I<SkipShopLocation>();
      await skipLocation();
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountReviewPage()),
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context, message: 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: widget.isFromProfile,
        title: Text(
          'Location Setup',
          style: TextStyle(
            color: ShopAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Map Illustration
              Container(
                height: 240.h,
                width: 240.h,
                decoration: BoxDecoration(
                  color: ShopAppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 180.h,
                        width: 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          shape: BoxShape.rectangle,
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/shop_location_map.png',
                            ), // Using existing asset as map texture placeholder
                            fit: BoxFit.cover,
                            opacity: 10,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: ShopAppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.storefront,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Reach Nearby\nCustomers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: ShopAppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Enable location to show your shop to nearby customers. This helps buyers find you more easily and increases local sales.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: ShopAppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 25.h),
              // Info Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: ShopAppColors.background,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: ShopAppColors.border.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: ShopAppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        color: ShopAppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why we need this',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: ShopAppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'We only use your location to calculate distance for delivery and to list your shop in local search results. Your privacy is our top priority.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ShopAppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              PrimaryButton(
                text: 'Allow Location Access',
                isLoading: _isLoading,
                backgroundColor: ShopAppColors.primary,
                textStyle: TextStyle(
                  color: ShopAppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
                onPressed: _handlePermission,
              ),
              if (!widget.isFromProfile) ...[
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: ShopAppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
