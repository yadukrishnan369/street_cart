import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/shared/components/customer_product_card.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  final List<ShopProfileModel> shops;
  final Map<String, String> shopNames;
  final Set<String> wishlistedProductIds;
  final Function(ProductModel product, bool isWishlisted) onFavoriteTap;

  const ProductsGrid({
    super.key,
    required this.products,
    required this.shops,
    required this.shopNames,
    required this.wishlistedProductIds,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isWishlisted = wishlistedProductIds.contains(product.id);
        final shopName = shopNames[product.shopId] ?? 'Unknown Shop';
        final imgUrl = product.images.isNotEmpty ? product.images.first : '';
        final price = product.offerPrice != null
            ? '₹${PriceUtils.formatPrice(product.offerPrice!)}'
            : '₹${PriceUtils.formatPrice(product.originalPrice)}';
        final isNew = product.createdAt != null &&
            DateTime.now().difference(product.createdAt!).inDays <= 2;

        final shop = shops.firstWhere(
          (s) => s.uid == product.shopId,
          orElse: () => ShopProfileModel(
            uid: product.shopId,
            ownerName: '',
            shopName: shopName,
            email: '',
            category: '',
            description: '',
            gstNumber: '',
            businessLicenseUrl: '',
            ownerIdUrl: '',
            isApproved: true,
            role: 'shop',
            isProfileCompleted: true,
            profileImageUrl: '',
            phone: '',
            deliveryRadius: 5.0,
            fullAddress: 'Address Unknown',
            landmark: '',
            city: '',
            pincode: '',
            district: '',
            state: '',
            paymentMethods: [],
          ),
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerProductDetailPage(
                  product: product,
                  shop: shop,
                ),
              ),
            );
          },
          child: ProductCard(
            imageUrl: imgUrl,
            brand: shopName,
            title: product.name,
            price: price,
            originalPrice: product.offerPrice != null
                ? '₹${PriceUtils.formatPrice(product.originalPrice)}'
                : null,
            discountPercentage: product.offerPrice != null
                ? (((product.originalPrice - product.offerPrice!) /
                            product.originalPrice) *
                        100)
                    .round()
                : null,
            isFavorite: isWishlisted,
            isNew: isNew,
            onFavoriteTap: () => onFavoriteTap(product, isWishlisted),
          ),
        );
      },
    );
  }
}
