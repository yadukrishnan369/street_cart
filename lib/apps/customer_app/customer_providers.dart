import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';

class CustomerProviders extends StatelessWidget {
  final Widget child;

  const CustomerProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<AuthBloc>())],
      child: child,
    );
  }
}
