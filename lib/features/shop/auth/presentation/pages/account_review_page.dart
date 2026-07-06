import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/rejection_review_body.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/normal_review_body.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

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
    return Scaffold(
      backgroundColor: ShopAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Account Status', style: ShopAppTextStyles.heading4),
      ),
      body: BlocListener<ShopAuthBloc, ShopAuthState>(
        listener: (context, state) {
          if (state is ShopAuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ShopLoginPage()),
              (route) => false,
            );
          } else if (state is ShopAuthFailure) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: BlocBuilder<ShopAuthBloc, ShopAuthState>(
          builder: (context, state) {
            final shop = state is ShopStatusLoaded ? state.shop : null;
            final bool isApproved = shop?.isApproved ?? false;
            final bool isRejected = shop?.isRejected ?? false;

            if (isRejected && shop != null) {
              return RejectionReviewBody(shop: shop);
            }

            return NormalReviewBody(isApproved: isApproved);
          },
        ),
      ),
    );
  }
}
