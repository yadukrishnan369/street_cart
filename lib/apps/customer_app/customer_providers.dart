import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';

class CustomerProviders extends StatelessWidget {
  final Widget child;

  const CustomerProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<WishlistBloc>()..add(LoadWishlist())),
        BlocProvider(create: (_) => sl<CartBloc>()),
        BlocProvider(
          create: (_) => sl<SettingsBloc>()..add(FetchSettingsData()),
        ),
        BlocProvider(create: (_) => sl<CustomerNotificationsBloc>()),
      ],
      child: child,
    );
  }
}
