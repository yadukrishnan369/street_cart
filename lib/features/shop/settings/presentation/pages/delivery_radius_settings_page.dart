import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_map_preview.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_slider_section.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/radius_info_box.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Delivery Radius Settings Page
class DeliveryRadiusSettingsPage extends StatefulWidget {
  final ShopProfileModel profile;
  final ShopProfileBloc profileBloc;
  final ShopSettingsBloc settingsBloc;

  const DeliveryRadiusSettingsPage({
    super.key,
    required this.profile,
    required this.profileBloc,
    required this.settingsBloc,
  });

  @override
  State<DeliveryRadiusSettingsPage> createState() =>
      _DeliveryRadiusSettingsPageState();
}

class _DeliveryRadiusSettingsPageState
    extends State<DeliveryRadiusSettingsPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the current delivery radius
    widget.settingsBloc.add(
      UpdateDeliveryRadiusEvent(widget.profile.deliveryRadius),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String shopName = widget.profile.shopName.isNotEmpty
        ? widget.profile.shopName
        : 'Store...';
    final String address = widget.profile.fullAddress.isNotEmpty
        ? widget.profile.fullAddress
        : '...';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.settingsBloc,
      child: BlocBuilder<ShopSettingsBloc, ShopSettingsState>(
        builder: (context, uiState) {
          return Scaffold(
            backgroundColor: isDark
                ? ShopAppColors.darkBackground
                : Colors.white,
            appBar: AppBar(
              backgroundColor: isDark
                  ? ShopAppColors.darkBackground
                  : Colors.white,
              elevation: isDark ? null : 1.5,
              shape: Border(
                bottom: BorderSide(
                  color: isDark
                      ? ShopAppColors.darkBorder
                      : ShopAppColors.border.withValues(alpha: 1.5),
                  width: 0.5,
                ),
              ),
              // Page Header
              title: Text(
                'Delivery Settings',
                style: ShopAppTextStyles.heading4.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
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
                              color: isDark
                                  ? ShopAppColors.darkTextPrimary
                                  : ShopAppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Shop Name and Address
                          Text(
                            '$shopName • $address',
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Radius Map Image Preview
                          RadiusMapPreview(radius: uiState.deliveryRadius),
                          SizedBox(height: 28.h),
                          // Radius Slider Section
                          RadiusSliderSection(
                            radius: uiState.deliveryRadius,
                            onChanged: (val) => context
                                .read<ShopSettingsBloc>()
                                .add(UpdateDeliveryRadiusEvent(val)),
                          ),
                          SizedBox(height: 28.h),
                          // Radius Info Box
                          RadiusInfoBox(radius: uiState.deliveryRadius),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    // Button for Saving Delivery Radius
                    child: PrimaryButton(
                      text: 'Save Settings',
                      backgroundColor: ShopAppColors.primary,
                      textStyle: ShopAppTextStyles.bodyMediumBold.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      onPressed: () {
                        widget.profileBloc.add(
                          UpdateShopProfileDataEvent(
                            widget.profile.copyWith(
                              deliveryRadius: uiState.deliveryRadius,
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
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
