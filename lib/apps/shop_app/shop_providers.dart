import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';

class ShopProviders extends StatelessWidget {
  final Widget child;

  const ShopProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ShopThemeCubit>()),
        BlocProvider(create: (_) => sl<ShopAuthBloc>()),
      ],
      child: child,
    );
  }
}
