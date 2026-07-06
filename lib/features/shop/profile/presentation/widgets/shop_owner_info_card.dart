import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

class ShopOwnerInfoCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopOwnerInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ShopProfileSectionBlock(
      title: 'OWNER INFO',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ShopProfileGridItem(
                  label: 'Shop Owner',
                  value: profile.ownerName.isNotEmpty
                      ? profile.ownerName
                      : 'Not provided',
                ),
              ),
              Expanded(
                child: ShopProfileGridItem(
                  label: 'Business Phone',
                  value: profile.phone.isNotEmpty
                      ? profile.phone
                      : 'Not provided',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ShopProfileGridItem(
            label: 'Business Email',
            value: profile.email.isNotEmpty ? profile.email : 'Not provided',
            valueColor: ShopAppColors.primary,
          ),
        ],
      ),
    );
  }
}
