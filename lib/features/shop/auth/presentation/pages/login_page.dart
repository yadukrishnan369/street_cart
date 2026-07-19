import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_login_header.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/shop_login_form.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Login Page
class ShopLoginPage extends StatefulWidget {
  const ShopLoginPage({super.key});

  @override
  State<ShopLoginPage> createState() => _ShopLoginPageState();
}

class _ShopLoginPageState extends State<ShopLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        if (state.status == ShopAuthStatus.authenticated) {
          // Navigate to Shop Home Page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ShopHomePage()),
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
      child: Scaffold(
        backgroundColor: ShopAppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Page Header
          title: Text('Shop Login', style: ShopAppTextStyles.heading4),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Login Header Section
              const ShopLoginHeader(),
              // Shop Login Form Section
              ShopLoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                formKey: _formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
