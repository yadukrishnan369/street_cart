import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/shared/widgets/review_card.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// All Reviews Page
class AllReviewsPage extends StatelessWidget {
  final List<ReviewModel> reviews;
  final ProductModel product;
  final ShopProfileModel shop;
  final String? selectedColor;
  final String? selectedSize;

  const AllReviewsPage({
    super.key,
    required this.reviews,
    required this.product,
    required this.shop,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        // Page Title
        title: Text(
          '${product.name} - Reviews',
          style: TextStyle(
            color: CustomerAppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        // List of Reviews
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            // Review Card
            return ReviewCard(
              review: reviews[index],
              product: product,
              shop: shop,
              currentUserId: currentUserId,
              selectedColor: selectedColor,
              selectedSize: selectedSize,
            );
          },
        ),
      ),
    );
  }
}
