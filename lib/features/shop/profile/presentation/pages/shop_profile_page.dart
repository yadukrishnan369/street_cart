import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/shop_settings_page.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/utils/edit_shop_profile_helper.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_profile_header_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_owner_info_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_description_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_delivery_radius_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_payment_methods_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_location_details_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_verification_docs_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_profile_action_buttons.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shimmer/shop_profile_shimmer.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Shop Profile Page
class ShopProfilePage extends StatelessWidget {
  final ShopAuthBloc authBloc;

  const ShopProfilePage({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<ShopProfileBloc>()..add(FetchShopProfileData()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: isDark
                ? ShopAppColors.darkBackground
                : const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: isDark
                  ? ShopAppColors.darkBackground
                  : Colors.white,
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
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ShopHomePage(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              // Page Header
              title: Text(
                'Shop Profile',
                style: ShopAppTextStyles.heading4.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                  onPressed: () {
                    final profileBloc = context.read<ShopProfileBloc>();
                    // Navigate to Shop Settings Page
                    Navigator.push(
                      context,
                      AppPageTransitions.slide(
                        MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: profileBloc),
                            BlocProvider(
                              create: (_) =>
                                  sl<ShopSettingsBloc>()
                                    ..add(FetchSettingsDataEvent()),
                            ),
                          ],
                          child: ShopSettingsPage(authBloc: authBloc),
                        ),
                      ),
                    ).then((_) {
                      if (context.mounted) {
                        context.read<ShopProfileBloc>().add(
                          FetchShopProfileData(),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
            body: BlocBuilder<ShopProfileBloc, ShopProfileState>(
              builder: (context, state) {
                if (state.profile == null) {
                  if (state.status == ShopProfileStatus.loading ||
                      state.status == ShopProfileStatus.initial) {
                    return const ShopProfileShimmer();
                  } else if (state.status == ShopProfileStatus.error) {
                    // App Error View
                    return AppErrorView(
                      message: state.message ?? 'An error occurred',
                      onRetry: () {
                        context.read<ShopProfileBloc>().add(
                          FetchShopProfileData(),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                }

                final profile = state.profile!;
                // Refresh Indicator
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ShopProfileBloc>().add(FetchShopProfileData());
                  },
                  color: ShopAppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Profile Header Card
                        SizedBox(height: 8.h),
                        ShopProfileHeaderCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Owner Info Card
                        ShopOwnerInfoCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Description Card
                        ShopDescriptionCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Delivery Radius Card
                        ShopDeliveryRadiusCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Payment Methods Card
                        ShopPaymentMethodsCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Location Details Card
                        ShopLocationDetailsCard(profile: profile),
                        SizedBox(height: 8.h),
                        // Shop Verification Docs Card
                        ShopVerificationDocsCard(profile: profile),
                        SizedBox(height: 24.h),
                        // Button for Logout
                        ShopProfileActionButtons(
                          profile: profile,
                          onLogout: () => EditShopProfileHelper.onLogout(
                            context: context,
                            authBloc: authBloc,
                          ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Bottom Navigation Bar
            bottomNavigationBar: const ShopBottomNavigation(currentIndex: 3),
          );
        },
      ),
    );
  }
}
