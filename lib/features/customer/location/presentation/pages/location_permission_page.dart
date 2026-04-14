import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' as Geolocator;
import 'package:street_cart/core/constants/app_constants.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/location/domain/usecases/request_location_and_save.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class LocationPermissionPage extends StatefulWidget {
  final bool isProfileCompleted;
  const LocationPermissionPage({super.key, this.isProfileCompleted = false});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  late RequestLocationAndSave requestLocation;
  late SkipLocation skipLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    requestLocation = sl<RequestLocationAndSave>();
    skipLocation = sl<SkipLocation>();
  }

  Future<void> _requestLocation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await requestLocation();

      if (!context.mounted) return;

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HomePage(showProfileModal: !widget.isProfileCompleted),
          ),
          (route) => false,
        );
      } else {
        CustomSnackBar.show(
          context,
          message:
              "We couldn't get your location. Please try again or skip for now.",
          backgroundColor: CustomerAppColors.warning,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      final errorMessage = e.toString();
      final isPermanentlyDenied = errorMessage.contains('permanently denied');

      CustomSnackBar.show(
        context,
        message: e.runtimeType.toString().contains('LocationException')
            ? e.toString().replaceFirst('LocationException: ', '')
            : "An unexpected error occurred while requesting location.",
        isError: true,
        actionLabel: isPermanentlyDenied ? "Settings" : null,
        onActionPressed:
            isPermanentlyDenied ? () => Geolocator.openAppSettings() : null,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skip(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await skipLocation();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(showProfileModal: !widget.isProfileCompleted),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(
        context,
        message: "An error occurred. Please try again.",
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.defaultPadding.w),
            child: Card(
              elevation: 4,
              color: CustomerAppColors.surface,
              shadowColor: Colors.black.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding.w,
                  vertical: 40.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Location Permission",
                      style: CustomerAppTextStyles.heading2.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    40.verticalSpace,
                    _buildHeroIllustration(),
                    40.verticalSpace,
                    Text(
                      "Enable Location Access",
                      style: CustomerAppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "Find the best deals around you. We use your location to show nearby shops and calculate precise delivery times for your orders.",
                        textAlign: TextAlign.center,
                        style: CustomerAppTextStyles.body.copyWith(
                          color: CustomerAppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    40.verticalSpace,
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: CustomerAppColors.primary,
                          )
                        : PrimaryButton(
                            text: "Allow Location",
                            onPressed: () => _requestLocation(context),
                          ),
                    16.verticalSpace,
                    TextButton(
                      onPressed: _isLoading ? null : () => _skip(context),
                      child: Text(
                        "Not Now",
                        style: CustomerAppTextStyles.buttonText.copyWith(
                          color: _isLoading
                              ? Colors.grey
                              : CustomerAppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return SizedBox(
      height: 240.w,
      width: 240.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withOpacity(0.05),
            ),
          ),
          Container(
            width: 176.w,
            height: 176.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withOpacity(0.12),
            ),
          ),
          Container(
            width: 112.w,
            height: 112.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withOpacity(0.2),
            ),
          ),

          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary,
            ),
            child: Center(
              child: Icon(Icons.location_on, color: Colors.white, size: 32.w),
            ),
          ),

          Positioned(bottom: 20, child: _circleIcon(Icons.store)),

          Positioned(
            bottom: 40,
            left: 40,
            child: _circleIcon(Icons.shopping_bag),
          ),

          Positioned(
            bottom: 40,
            right: 40,
            child: _circleIcon(Icons.local_shipping),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomerAppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Icon(icon, size: 20.w, color: CustomerAppColors.primary),
    );
  }
}
