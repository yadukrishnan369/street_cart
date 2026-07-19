import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

// Shop Location Details Card
class ShopLocationDetailsCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopLocationDetailsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ShopProfileSectionBlock(
      // Title
      title: 'LOCATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Full Address
          ShopProfileGridItem(
            label: 'Full Address',
            value: profile.fullAddress.isNotEmpty
                ? profile.fullAddress
                : 'Not provided',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                // Shop Landmark
                child: ShopProfileGridItem(
                  label: 'Landmark',
                  value: profile.landmark.isNotEmpty
                      ? profile.landmark
                      : 'Not provided',
                ),
              ),
              Expanded(
                // Shop City
                child: ShopProfileGridItem(
                  label: 'City',
                  value: profile.city.isNotEmpty
                      ? profile.city
                      : 'Not provided',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                // Shop District
                child: ShopProfileGridItem(
                  label: 'District',
                  value: profile.district.isNotEmpty
                      ? profile.district
                      : 'Not provided',
                ),
              ),
              Expanded(
                // Shop State
                child: ShopProfileGridItem(
                  label: 'State',
                  value: profile.state.isNotEmpty
                      ? profile.state
                      : 'Not provided',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Shop PIN Code
          ShopProfileGridItem(
            label: 'Pincode',
            value: profile.pincode.isNotEmpty
                ? profile.pincode
                : 'Not provided',
          ),
        ],
      ),
    );
  }
}
