import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_login_header.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_login_form.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopLoginPage extends StatelessWidget {
  const ShopLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        if (state is ShopAuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ShopHomePage()),
            (route) => false,
          );
        } else if (state is ShopAuthFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: ShopAppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Shop Login', style: ShopAppTextStyles.heading4),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ShopLoginHeader(),
              ShopLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
