import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/rejection_reason_modal.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class AdminDashboardHelper {
  // get registration application ID
  static String getRegistrationId(ShopProfileModel shop) {
    final year = shop.createdAt != null ? shop.createdAt!.year : 2024;
    final length = shop.uid.length;
    final sub = shop.uid.substring(0, length > 5 ? 5 : length).toUpperCase();
    return '#APP-$year-$sub';
  }

  // get submission time
  static String getSubmittedTime(ShopProfileModel shop) {
    return shop.createdAt != null
        ? DateFormatter.formatToDateTime(shop.createdAt!)
        : 'Recently';
  }

  // format OrderId
  static String formatOrderId(String orderId) {
    return orderId.length >= 4
        ? '#ORD-${orderId.substring(orderId.length - 4)}'.toUpperCase()
        : orderId.toUpperCase();
  }

  // get registration subtitle
  static String getRegistrationSubtitle(NewRegistrationModel reg) {
    final category = reg.address.split('•').first.trim();
    if (reg.createdAt != null) {
      final datePart = DateFormatter.formatToReadableDate(
        reg.createdAt!,
      ).split(',').first;
      final timePart = DateFormatter.formatToTime(reg.createdAt!);
      return '$category • $datePart, $timePart';
    }
    return '$category • Recently';
  }

  // double confirmation dialog for rejecting a shop
  static void showDoubleConfirmation({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String reason,
    required Function(String reason) onSubmit,
  }) {
    if (!formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogCtx) {
        return ConfirmationModal(
          title: 'Confirm Rejection',
          content:
              'Are you sure you want to reject this shop registration? This will notify the shop with the reason and they must resubmit to be considered again.',
          confirmText: 'Yes, Reject',
          cancelText: 'Cancel',
          confirmColor: AdminAppColors.errorColor,
          onCancel: () => Navigator.of(dialogCtx).pop(),
          onConfirm: () {
            Navigator.of(dialogCtx).pop(); // Pop confirmation
            Navigator.of(context).pop(); // Pop modal itself
            onSubmit(reason.trim());
          },
        );
      },
    );
  }

  // approve confirmation dialog
  static void showApproveConfirmation(
    BuildContext context,
    ShopProfileModel shop,
  ) {
    final bloc = context.read<AdminRegistrationDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Approve Application',
        content:
            'Are you sure you want to approve "${shop.shopName}"? They will be allowed to access their Shop portal immediately.',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Approve',
        icon: Icons.check_circle_outline,
        iconColor: AdminAppColors.primaryColor,
        primaryActionColor: AdminAppColors.primaryColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          bloc.add(ApproveShopRequested(shop.uid));
        },
      ),
    );
  }

  // reject confirmation dialog
  static void showRejectConfirmation(
    BuildContext context,
    ShopProfileModel shop,
  ) {
    final bloc = context.read<AdminRegistrationDetailsBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => RejectionReasonModal(
        onSubmit: (reason) {
          bloc.add(
            RejectShopRequested(shopId: shop.uid, rejectionReason: reason),
          );
        },
      ),
    );
  }
}
