import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';

class CheckoutHelper {
  // Unique types of products
  static int getProductTypesCount(List<CartItem> items) {
    return items.length;
  }

  // Total count of all items
  static int getTotalProductsCount(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Total money amount
  static double getTotalAmount(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
