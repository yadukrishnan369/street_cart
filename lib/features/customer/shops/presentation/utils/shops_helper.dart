import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class ShopsHelper {
  // Filter Shops
  static List<ShopProfileModel> filterShops(
    List<ShopProfileModel> shops,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) return shops;
    final q = searchQuery.toLowerCase();
    return shops.where((s) {
      return s.shopName.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q) ||
          s.city.toLowerCase().contains(q);
    }).toList();
  }
}
