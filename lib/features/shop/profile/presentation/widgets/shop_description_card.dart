import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

// Shop Description Card
class ShopDescriptionCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopDescriptionCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ShopProfileSectionBlock(
      // Title
      title: 'SHOP DESCRIPTION',
      // Shop Description
      child: Text(
        profile.description.isNotEmpty
            ? profile.description
            : 'No description provided.',
        style: ShopAppTextStyles.bodyMedium.copyWith(
          color: isDark
              ? ShopAppColors.darkTextPrimary
              : ShopAppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }
}
