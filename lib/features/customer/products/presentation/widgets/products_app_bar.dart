import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/wishlist_page.dart';

// Products Page App Bar
class ProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      centerTitle: true,
      title: Text(
        'Products',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      actions: [
        // Navigate to Wishlist Page
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WishlistPage()),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  size: 20.sp,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Wishlist',
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
