import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

// Platform Business Settings
class PlatformBusinessSettings extends StatefulWidget {
  final AdminSettingsModel? settings;
  final bool isInProgress;

  const PlatformBusinessSettings({
    super.key,
    required this.settings,
    required this.isInProgress,
  });

  @override
  State<PlatformBusinessSettings> createState() =>
      _PlatformBusinessSettingsState();
}

class _PlatformBusinessSettingsState extends State<PlatformBusinessSettings> {
  final _commissionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    _syncCommissionText();
    _syncDraftToggles();
  }

  @override
  void didUpdateWidget(covariant PlatformBusinessSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settings != oldWidget.settings && widget.settings != null) {
      _syncCommissionText();
      _syncDraftToggles();
    }
  }

  void _syncCommissionText() {
    if (widget.settings != null) {
      _commissionController.text = widget.settings!.commissionPercentage
          .toStringAsFixed(0);
    }
  }

  void _syncDraftToggles() {
    if (widget.settings != null) {
      final bloc = context.read<AdminSettingsBloc>();
      bloc.add(UpdateDraftCodToggle(widget.settings!.enableCod));
      bloc.add(UpdateDraftOnlineToggle(widget.settings!.enableOnline));
    }
  }

  @override
  void dispose() {
    _commissionController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
      buildWhen: (prev, curr) =>
          prev.draftEnableCod != curr.draftEnableCod ||
          prev.draftEnableOnline != curr.draftEnableOnline ||
          prev.percentageError != curr.percentageError,
      builder: (context, state) {
        final bloc = context.read<AdminSettingsBloc>();
        final enableCod =
            state.draftEnableCod ?? widget.settings?.enableCod ?? true;
        final enableOnline =
            state.draftEnableOnline ?? widget.settings?.enableOnline ?? true;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AdminAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFE8E7ED),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.business_center_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Platform Business Settings',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFF0EFF5),
              ),

              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Platform Commission
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Platform Commission Percentage',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Global percentage taken from each completed transaction (0-100%).',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AdminAppColors.darkInputBackground
                                      : const Color(0xFFF9FAFC),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isDark
                                        ? AdminAppColors.borderLight
                                        : AdminAppColors.darkBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _commissionController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AdminAppColors.darkTextPrimary
                                                : AdminAppColors.textPrimary,
                                          ),
                                          onChanged: (_) {
                                            if (state.percentageError != null) {
                                              bloc.add(
                                                const SetPercentageError(null),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 48.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: isDark
                                                ? AdminAppColors.darkBorder
                                                : const Color(0xFFE8E7ED),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '%',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? AdminAppColors.darkTextSecondary
                                              : const Color(0xFF8A8A9E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (state.percentageError != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 8.h,
                                    right: 140,
                                  ),
                                  child: Text(
                                    state.percentageError!,
                                    style: TextStyle(
                                      color: AdminAppColors.errorColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 12.h),
                              ElevatedButton(
                                onPressed: widget.isInProgress
                                    ? null
                                    : () {
                                        final error =
                                            Validators.adminValidatePercentage(
                                              _commissionController.text,
                                            );
                                        bloc.add(SetPercentageError(error));

                                        if (error != null) {
                                          _errorTimer?.cancel();
                                          _errorTimer = Timer(
                                            const Duration(seconds: 2),
                                            () {
                                              if (!mounted) return;
                                              bloc.add(
                                                const SetPercentageError(null),
                                              );
                                              _commissionController.text =
                                                  widget
                                                      .settings!
                                                      .commissionPercentage
                                                      .toStringAsFixed(0);
                                            },
                                          );
                                          return;
                                        }

                                        final percentage = double.parse(
                                          _commissionController.text,
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (dialogCtx) => CustomAlertDialog(
                                            title: 'Save Commission',
                                            content:
                                                'Are you sure you want to update the platform commission percentage to ${percentage.toStringAsFixed(0)}%?',
                                            secondaryActionLabel: 'Cancel',
                                            primaryActionLabel: 'Confirm',
                                            icon: Icons.percent,
                                            iconColor:
                                                AdminAppColors.primaryColor,
                                            primaryActionColor:
                                                AdminAppColors.primaryColor,
                                            onPrimaryAction: () {
                                              Navigator.pop(dialogCtx);
                                              bloc.add(
                                                UpdatePlatformCommission(
                                                  percentage,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AdminAppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Divider(
                      height: 1,
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFF0EFF5),
                    ),
                    SizedBox(height: 25.h),

                    // Payment Method Controls
                    Text(
                      'Payment Method Controls',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // COD Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enable Cash on Delivery',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Allow customers to pay physically upon delivery.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: enableCod,
                            activeThumbColor: AdminAppColors.primaryColor,
                            onChanged: (val) =>
                                bloc.add(UpdateDraftCodToggle(val)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Online Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enable Online Payments',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Process credit cards and digital wallets.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: enableOnline,
                            activeThumbColor: AdminAppColors.primaryColor,
                            onChanged: (val) =>
                                bloc.add(UpdateDraftOnlineToggle(val)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Save Changes button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: widget.isInProgress
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (dialogCtx) => CustomAlertDialog(
                                    title: 'Save Payment Controls',
                                    content:
                                        'Are you sure you want to save the payment method settings changes?',
                                    secondaryActionLabel: 'Cancel',
                                    primaryActionLabel: 'Confirm',
                                    icon: Icons.payments_outlined,
                                    iconColor: AdminAppColors.primaryColor,
                                    primaryActionColor:
                                        AdminAppColors.primaryColor,
                                    onPrimaryAction: () {
                                      Navigator.pop(dialogCtx);
                                      bloc.add(
                                        UpdatePaymentControls(
                                          enableCod: enableCod,
                                          enableOnline: enableOnline,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminAppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
