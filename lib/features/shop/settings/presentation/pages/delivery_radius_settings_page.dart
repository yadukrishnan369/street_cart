import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';

class GreenBorderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const GreenBorderThumbShape({this.thumbRadius = 10});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paintBorder = Paint()
      ..color = ShopAppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.r;

    final paintFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, paintFill);
    canvas.drawCircle(center, thumbRadius, paintBorder);
  }
}

class DeliveryRadiusSettingsPage extends StatefulWidget {
  final ShopProfileModel profile;
  final ShopProfileBloc profileBloc;

  const DeliveryRadiusSettingsPage({
    super.key,
    required this.profile,
    required this.profileBloc,
  });

  @override
  State<DeliveryRadiusSettingsPage> createState() =>
      _DeliveryRadiusSettingsPageState();
}

class _DeliveryRadiusSettingsPageState
    extends State<DeliveryRadiusSettingsPage> {
  late double _radius;

  @override
  void initState() {
    super.initState();
    _radius = widget.profile.deliveryRadius;
  }

  void _saveSettings() {
    widget.profileBloc.add(
      UpdateShopProfileDataEvent(
        widget.profile.copyWith(deliveryRadius: _radius),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String shopName = widget.profile.shopName.isNotEmpty
        ? widget.profile.shopName
        : 'Malabar Fashion Store';
    final String address = widget.profile.fullAddress.isNotEmpty
        ? widget.profile.fullAddress
        : 'SM Street';

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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Location header
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

                    // Map preview card
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFECEFF1),
                          width: 0.8,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Static Map Background
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/shop_location_map.png',
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Dynamic Radius Circle representing the range
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: 30.h + (_radius / 500.0) * 150.h,
                              height: 30.h + (_radius / 500.0) * 150.h,
                              decoration: BoxDecoration(
                                color: ShopAppColors.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ShopAppColors.primary,
                                  width: 2.r,
                                ),
                              ),
                            ),

                            // Center Marker (Shop Pin / Storefront Icon)
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: ShopAppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.storefront,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Delivery Radius title and value
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Radius',
                              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                fontSize: 16.sp,
                                color: ShopAppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Set the maximum distance for orders',
                              style: ShopAppTextStyles.bodySmall.copyWith(
                                color: ShopAppColors.textSecondary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: ShopAppColors.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${_radius.toStringAsFixed(1)} km',
                            style: ShopAppTextStyles.bodyMediumBold.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Slider custom styling
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.h,
                        activeTrackColor: ShopAppColors.primary,
                        inactiveTrackColor: const Color(0xFFD2E7E2),
                        thumbShape: GreenBorderThumbShape(thumbRadius: 10.r),
                        overlayColor: ShopAppColors.primary.withOpacity(0.12),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20.r,
                        ),
                      ),
                      child: Slider(
                        value: _radius,
                        min: 0.0,
                        max: 500.0,
                        onChanged: (value) {
                          setState(() {
                            _radius = value;
                          });
                        },
                      ),
                    ),

                    // Slider labels
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0 KM',
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                          Text(
                            '250 KM',
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                          Text(
                            '500 KM',
                            style: ShopAppTextStyles.bodySmallBold.copyWith(
                              color: ShopAppColors.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Info box description
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: ShopAppColors.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ShopAppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: ShopAppTextStyles.bodyMedium.copyWith(
                                  color: ShopAppColors.textSecondary,
                                  height: 1.4,
                                  fontSize: 12.sp,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'Your shop is currently visible to customers within ',
                                  ),
                                  TextSpan(
                                    text: '${_radius.toStringAsFixed(1)}km',
                                    style: ShopAppTextStyles.bodyMediumBold
                                        .copyWith(
                                          color: ShopAppColors.primary,
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ' of your location. Adjust the slider to expand or narrow your market reach.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save settings button at bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _saveSettings,
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
  }
}
