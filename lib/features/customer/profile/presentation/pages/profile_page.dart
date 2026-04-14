import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_state.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/profile_header.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/account_settings_section.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/support_section.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/about_section.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/logout_button.dart';
import 'package:street_cart/features/customer/settings/presentation/pages/settings_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(FetchProfileData()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: CustomerAppColors.background,
              appBar: AppBar(
                backgroundColor: CustomerAppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomePage(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      ).then((_) {
                        if (context.mounted) {
                          context.read<ProfileBloc>().add(FetchProfileData());
                        }
                      });
                    },
                  ),
                ],
              ),
              body: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading || state is ProfileInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileError) {
                    return Center(child: Text(state.message));
                  } else if (state is ProfileLoaded ||
                      state is ProfileUpdateSuccess) {
                    final profile = state is ProfileLoaded
                        ? state.profile
                        : (state as ProfileUpdateSuccess).profile;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileHeader(profile: profile),
                          SizedBox(height: 8.h),
                          const AccountSettingsSection(),
                          SizedBox(height: 24.h),
                          const SupportSection(),
                          SizedBox(height: 24.h),
                          const AboutSection(),
                          SizedBox(height: 32.h),
                          const LogoutButton(),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 4),
            );
          }
        ),
      ),
    );
  }
}
