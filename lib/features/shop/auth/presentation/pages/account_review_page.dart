import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/rejection_review_body.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/normal_review_body.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Account Review Page
class AccountReviewPage extends StatefulWidget {
  const AccountReviewPage({super.key});

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopAuthBloc>().add(ShopStatusSubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Page Header
        title: Text(
          'Account Status',
          style: ShopAppTextStyles.heading4.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
        ),
      ),
      body: BlocListener<ShopAuthBloc, ShopAuthState>(
        listener: (context, state) {
          if (state.status == ShopAuthStatus.initial) {
            // Navigate to Shop Login Page
            Navigator.pushAndRemoveUntil(
              context,
              AppPageTransitions.slide(const ShopLoginPage()),
              (route) => false,
            );
          } else if (state.status == ShopAuthStatus.failure &&
              state.errorMessage != null) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage!,
              isError: true,
            );
          }
        },
        child: BlocBuilder<ShopAuthBloc, ShopAuthState>(
          builder: (context, state) {
            final shop = state.shop;
            final bool isApproved = shop?.isApproved ?? false;
            final bool isRejected = shop?.isRejected ?? false;

            if (isRejected && shop != null) {
              // Rejection Review Body Part
              return RejectionReviewBody(shop: shop);
            }
            // Normal Review Body Part (Waiting for Approval)
            return NormalReviewBody(isApproved: isApproved);
          },
        ),
      ),
    );
  }
}
