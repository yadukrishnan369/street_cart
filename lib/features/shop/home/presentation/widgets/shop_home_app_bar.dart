import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_state.dart';
import 'package:street_cart/features/shop/notification/presentation/pages/shop_notifications_page.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Shop Home App bar
class ShopHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
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
                  size: 40.r,
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
          String shopName = 'Shop';
          if (state.status == ShopAuthStatus.authenticated) {
            shopName = state.shop?.shopName ?? 'Shop';
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Shop name
            children: [
              AppTextAnimation.scale(
                shopName,
                key: ValueKey('shop_appbar_name_$shopName'),
                style: ShopAppTextStyles.heading4.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
              ),
              Text('Street Cart Partner', style: ShopAppTextStyles.labelBold),
            ],
          );
        },
      ),
      // Notification Icon
      actions: [
        BlocBuilder<ShopNotificationsBloc, ShopNotificationsState>(
          builder: (context, state) {
            final unread = state.unreadCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: ShopAppColors.primary,
                    size: 26.sp,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      AppPageTransitions.slideFromTopRight(
                        const ShopNotificationsPage(),
                      ),
                    );
                  },
                ),
                if (unread > 0)
                  Positioned(
                    right: 8.w,
                    top: 10.h,
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        color: ShopAppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14.r,
                        minHeight: 14.r,
                      ),
                      child: Text(
                        '${unread > 9 ? '9+' : unread}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
