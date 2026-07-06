import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/delivery_radius_ui_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_map_preview.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_slider_section.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_info_box.dart';

class DeliveryRadiusSettingsPage extends StatelessWidget {
  final ShopProfileModel profile;
  final ShopProfileBloc profileBloc;

  const DeliveryRadiusSettingsPage({
    super.key,
    required this.profile,
    required this.profileBloc,
  });

  @override
  Widget build(BuildContext context) {
    final String shopName = profile.shopName.isNotEmpty
        ? profile.shopName
        : 'Malabar Fashion Store';
    final String address = profile.fullAddress.isNotEmpty
        ? profile.fullAddress
        : 'SM Street';

    return BlocProvider(
      create: (_) => DeliveryRadiusUiCubit(profile.deliveryRadius),
      child: BlocBuilder<DeliveryRadiusUiCubit, DeliveryRadiusUiState>(
        builder: (context, uiState) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: Padding(
                padding: EdgeInsets.all(8.r),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: ShopAppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Delivery Settings',
                style: ShopAppTextStyles.heading4.copyWith(
                  color: ShopAppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop Location',
                            style: ShopAppTextStyles.bodyMediumBold.copyWith(
                              fontSize: 18.sp,
                              color: ShopAppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '$shopName • $address',
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          RadiusMapPreview(radius: uiState.radius),
                          SizedBox(height: 28.h),
                          RadiusSliderSection(
                            radius: uiState.radius,
                            onChanged: (val) => context
                                .read<DeliveryRadiusUiCubit>()
                                .updateRadius(val),
                          ),
                          SizedBox(height: 28.h),
                          RadiusInfoBox(radius: uiState.radius),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () {
                          profileBloc.add(
                            UpdateShopProfileDataEvent(
                              profile.copyWith(deliveryRadius: uiState.radius),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ShopAppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          elevation: 1,
                        ),
                        child: Text(
                          'Save Settings',
                          style: ShopAppTextStyles.bodyMediumBold.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
