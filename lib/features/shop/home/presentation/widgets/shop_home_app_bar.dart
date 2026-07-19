import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';

// Shop Home App bar
class ShopHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: 70.w,
      leading: Builder(
        builder: (context) {
          // Open Drawer
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 10.w),
              child: Center(
                child: AppLogo(
                  size: 40,
                  backgroundColor: ShopAppColors.primary,
                  logoColor: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      title: BlocBuilder<ShopAuthBloc, ShopAuthState>(
        builder: (context, state) {
          String shopName = "My Shop";
          if (state.status == ShopAuthStatus.authenticated) {
            shopName = state.shop?.shopName ?? "My Shop";
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Shop name
            children: [
              Text(shopName, style: ShopAppTextStyles.heading4),
              Text('Street Cart Partner', style: ShopAppTextStyles.labelBold),
            ],
          );
        },
      ),
      // Notification Icon
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: ShopAppColors.textSecondary,
                size: 26.sp,
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 12.w,
              top: 12.h,
              child: Container(
                height: 8.r,
                width: 8.r,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
