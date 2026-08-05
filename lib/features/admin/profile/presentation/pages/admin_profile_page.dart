import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_event.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_state.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_header.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_metrics.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_security.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_logout.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/edit_profile_overlay.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/profile/presentation/utils/profile_helper.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_bio_card.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_about_card.dart';

// Admin Profile Page
class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AdminAppColors.darkBackground
          : AdminAppColors.backgroundLight,
      body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        builder: (context, state) {
          if (state is AdminProfileLoading || state is AdminProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AdminAppColors.primaryColor,
              ),
            );
          } else if (state is AdminProfileError) {
            // App Error View with retry
            return AdminErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<AdminProfileBloc>().add(LoadAdminProfile()),
            );
          } else if (state is AdminProfileLoaded) {
            final profile = state.profile;
            final initials = ProfileHelper.getInitials(profile.fullName);
            final lastLoginStr = profile.lastLogin != null
                ? DateFormatter.formatToLoginDateTime((profile.lastLogin!))
                : 'N/A';
            final lastLogoutStr = profile.lastLogout != null
                ? DateFormatter.formatToLoginDateTime((profile.lastLogout!))
                : 'N/A';

            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    final isWideHeader = constraints.maxWidth > 600;

                    final leftColumn = [
                      // Admin Profile Bio Card
                      const AdminProfileBioCard(),
                      SizedBox(height: 24.h),
                      // Admin Profile About Card
                      const AdminProfileAboutCard(),
                      SizedBox(height: 24.h),
                      // Admin Profile Metrics
                      AdminProfileMetrics(
                        approvedShopsCount: profile.approvedShopsCount,
                        ordersTrackedCount: profile.ordersTrackedCount,
                        reviewsCount: profile.reviewsCount,
                      ),
                    ];

                    final rightColumn = [
                      // Admin Profile Security
                      AdminProfileSecurity(
                        lastLoginStr: lastLoginStr,
                        lastLogoutStr: lastLogoutStr,
                      ),
                      SizedBox(height: 24.h),
                      // Admin Profile Logout
                      const AdminProfileLogout(),
                    ];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Admin Profile Header
                          AdminProfileHeader(
                            profile: profile,
                            initials: initials,
                            isWideHeader: isWideHeader,
                            onEditProfilePressed: () {
                              context.read<AdminProfileBloc>().add(
                                const ShowEditOverlay(),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: leftColumn,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: rightColumn,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...leftColumn,
                                SizedBox(height: 24.h),
                                ...rightColumn,
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
                if (state.isEditing)
                  // Edit Profile Overlay
                  EditProfileOverlay(
                    currentName: profile.fullName,
                    email: profile.email,
                    onClose: () {
                      context.read<AdminProfileBloc>().add(
                        const HideEditOverlay(),
                      );
                    },
                    onSave: (newName) {
                      context.read<AdminProfileBloc>().add(
                        const HideEditOverlay(),
                      );
                      context.read<AdminProfileBloc>().add(
                        UpdateAdminProfile(newName),
                      );
                      CustomSnackBar.show(
                        context,
                        message: 'Profile updated successfully!',
                      );
                    },
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
