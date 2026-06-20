import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_event.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_state.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_header.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_metrics.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_security.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/admin_profile_logout.dart';
import 'package:street_cart/features/admin/profile/presentation/widgets/edit_profile_overlay.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        builder: (context, state) {
          if (state is AdminProfileLoading || state is AdminProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AdminAppColors.primaryColor,
              ),
            );
          } else if (state is AdminProfileError) {
            return Center(
              child: Text(
                'Error loading profile: ${state.message}',
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  color: AdminAppColors.errorColor,
                ),
              ),
            );
          } else if (state is AdminProfileLoaded) {
            final profile = state.profile;
            final initials = _getInitials(profile.fullName);
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
                      _buildBioCard(),
                      SizedBox(height: 24.h),
                      _buildAboutCard(),
                      SizedBox(height: 24.h),
                      AdminProfileMetrics(
                        approvedShopsCount: profile.approvedShopsCount,
                      ),
                    ];

                    final rightColumn = [
                      AdminProfileSecurity(
                        lastLoginStr: lastLoginStr,
                        lastLogoutStr: lastLogoutStr,
                      ),
                      SizedBox(height: 24.h),
                      const AdminProfileLogout(),
                    ];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Profile Card
                          AdminProfileHeader(
                            profile: profile,
                            initials: initials,
                            isWideHeader: isWideHeader,
                            onEditProfilePressed: () {
                              setState(() {
                                _isEditing = true;
                              });
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
                if (_isEditing)
                  EditProfileOverlay(
                    currentName: profile.fullName,
                    email: profile.email,
                    onClose: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    onSave: (newName) {
                      setState(() {
                        _isEditing = false;
                      });
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

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'AD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      final first = parts[0];
      final second = parts[1];
      if (first.isNotEmpty && second.isNotEmpty) {
        return (first[0] + second[0]).toUpperCase();
      }
    }
    if (name.trim().length > 1) {
      return name.trim().substring(0, 2).toUpperCase();
    }
    return name.trim().toUpperCase();
  }

  Widget _buildBioCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminConstants.bioTitle,
            style: AdminAppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AdminConstants.bioContent,
            style: AdminAppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF4A4A68),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminConstants.aboutTitle,
            style: AdminAppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AdminConstants.aboutContent,
            style: AdminAppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF4A4A68),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
