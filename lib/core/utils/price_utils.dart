import 'package:intl/intl.dart';

class PriceUtils {
  static int calculateOfferPercentage(double originalPrice, double offerPrice) {
    if (originalPrice <= 0) return 0;
    if (offerPrice >= originalPrice) return 0;
    final discount = originalPrice - offerPrice;
    final percentage = (discount / originalPrice) * 100;
    return percentage.round();
  }

  static String formatPrice(num price) {
    return NumberFormat('#,##,##0', 'en_IN').format(price);
  }
}
