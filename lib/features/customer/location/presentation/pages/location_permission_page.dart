import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' as Geolocator;
import 'package:street_cart/core/constants/app_constants.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/location/presentation/bloc/location_bloc.dart';
import 'package:street_cart/features/customer/location/presentation/bloc/location_event.dart';
import 'package:street_cart/features/customer/location/presentation/bloc/location_state.dart';
import 'package:street_cart/features/customer/location/presentation/widgets/location_hero_illustration.dart';

// Location Permission Page
class LocationPermissionPage extends StatefulWidget {
  final bool isProfileCompleted;
  const LocationPermissionPage({super.key, this.isProfileCompleted = false});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<LocationBloc>(),
      child: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSuccess) {
            if (state.success) {
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
          } else if (state is LocationSkipped) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HomePage(showProfileModal: !widget.isProfileCompleted),
              ),
              (route) => false,
            );
          } else if (state is LocationFailure) {
            final errorMessage = state.message;
            final isPermanentlyDenied = errorMessage.contains(
              'permanently denied',
            );

            CustomSnackBar.show(
              context,
              message: errorMessage.replaceAll("Exception: ", ""),
              isError: true,
              actionLabel: isPermanentlyDenied ? "Settings" : null,
              onActionPressed: isPermanentlyDenied
                  ? () => Geolocator.openAppSettings()
                  : null,
            );
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.defaultPadding.w),
                // Location Permission Card Section
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24.r),
                    border: isDark
                        ? Border.all(color: CustomerAppColors.darkBorder)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.3 : 0.08,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding.w,
                      vertical: 40.h,
                    ),
                    child: BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        final isLoading = state is LocationLoading;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Location Permission",
                              style: CustomerAppTextStyles.heading2.copyWith(
                                fontSize: 18.sp,
                                color: isDark
                                    ? CustomerAppColors.darkTextPrimary
                                    : CustomerAppColors.textPrimary,
                              ),
                            ),
                            40.verticalSpace,
                            const LocationHeroIllustration(),
                            40.verticalSpace,
                            Text(
                              "Enable Location Access",
                              style: CustomerAppTextStyles.heading1.copyWith(
                                color: isDark
                                    ? CustomerAppColors.darkTextPrimary
                                    : CustomerAppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "Find the best deals around you. We use your location to show nearby shops and calculate precise delivery times for your orders.",
                                textAlign: TextAlign.center,
                                style: CustomerAppTextStyles.body.copyWith(
                                  color: isDark
                                      ? CustomerAppColors.darkTextSecondary
                                      : CustomerAppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            40.verticalSpace,
                            isLoading
                                ? const CircularProgressIndicator(
                                    color: CustomerAppColors.primary,
                                  )
                                : PrimaryButton(
                                    text: "Allow Location",
                                    onPressed: () {
                                      context.read<LocationBloc>().add(
                                        RequestLocationEvent(),
                                      );
                                    },
                                  ),
                            16.verticalSpace,
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<LocationBloc>().add(
                                        SkipLocationEvent(),
                                      );
                                    },
                              child: Text(
                                "Not Now",
                                style: CustomerAppTextStyles.buttonText
                                    .copyWith(
                                      color: isLoading
                                          ? Colors.grey
                                          : isDark
                                          ? CustomerAppColors.darkTextSecondary
                                          : CustomerAppColors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
