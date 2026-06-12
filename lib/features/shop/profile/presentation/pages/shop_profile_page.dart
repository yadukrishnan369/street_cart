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
import 'package:street_cart/features/shop/profile/presentation/pages/edit_shop_profile_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/shop_settings_page.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_profile_header_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_owner_info_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_description_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_delivery_radius_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_payment_methods_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_location_details_card.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/shop_verification_docs_card.dart';

class ShopProfilePage extends StatelessWidget {
  final ShopAuthBloc authBloc;

  const ShopProfilePage({super.key, required this.authBloc});

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          authBloc.add(ShopLogoutRequested());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ShopLoginPage()),
            (route) => false,
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ShopProfileBloc>()..add(FetchShopProfileData()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
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
              title: Text(
                'Shop Profile',
                style: ShopAppTextStyles.heading4.copyWith(
                  color: ShopAppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: ShopAppColors.textPrimary,
                  ),
                  onPressed: () {
                    final profileBloc = context.read<ShopProfileBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: profileBloc),
                            BlocProvider(create: (_) => sl<ShopSettingsBloc>()),
                          ],
                          child: ShopSettingsPage(authBloc: authBloc),
                        ),
                      ),
                    ).then((_) {
                      if (context.mounted) {
                        context.read<ShopProfileBloc>().add(FetchShopProfileData());
                      }
                    });
                  },
                ),
              ],
            ),
            body: BlocBuilder<ShopProfileBloc, ShopProfileState>(
              builder: (context, state) {
                if (state is ShopProfileLoading || state is ShopProfileInitial) {
                  return const Center(child: CircularProgressIndicator(color: ShopAppColors.primary));
                } else if (state is ShopProfileError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        state.message,
                        style: ShopAppTextStyles.bodyMedium.copyWith(color: Colors.redAccent),
                      ),
                    ),
                  );
                } else if (state is ShopProfileLoaded || state is ShopProfileUpdateSuccess) {
                  final profile = state is ShopProfileLoaded
                      ? state.profile
                      : (state as ShopProfileUpdateSuccess).profile;

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
                          ShopProfileHeaderCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopOwnerInfoCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopDescriptionCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopDeliveryRadiusCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopPaymentMethodsCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopLocationDetailsCard(profile: profile),
                          SizedBox(height: 8.h),
                          ShopVerificationDocsCard(profile: profile),
                          SizedBox(height: 24.h),

                          // Action Buttons
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final profileBloc = context.read<ShopProfileBloc>();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: profileBloc,
                                            child: EditShopProfilePage(profile: profile),
                                          ),
                                        ),
                                      ).then((_) {
                                        if (context.mounted) {
                                          context.read<ShopProfileBloc>().add(FetchShopProfileData());
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.edit_note_outlined, size: 20.sp, color: Colors.white),
                                    label: Text(
                                      'Edit Profile Details',
                                      style: ShopAppTextStyles.buttonText.copyWith(fontSize: 15.sp),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ShopAppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24.r),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _onLogout(context),
                                    icon: Icon(Icons.logout, size: 18.sp, color: ShopAppColors.primary),
                                    label: Text(
                                      'Logout',
                                      style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                        color: ShopAppColors.primary,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF4F7F6),
                                      side: const BorderSide(color: Color(0xFFE2EBE9), width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            bottomNavigationBar: const ShopBottomNavigation(currentIndex: 3),
          );
        },
      ),
    );
  }
}
