import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

class SavedAddressesHelper {
  static bool hasDefaultAddress(List<AddressModel> addresses) {
    return addresses.any((a) => a.isDefault);
  }

  static AddressModel getSelectedAddress(List<AddressModel> addresses) {
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  static void showNoAddressSelectedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: 'No Address Selected',
        content:
            'Please select a delivery address by clicking the radio button on your preferred address card.',
        primaryActionLabel: 'Got it',
        onPrimaryAction: () => Navigator.pop(context),
        icon: Icons.location_on_outlined,
        iconColor: CustomerAppColors.primary,
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required String addressId,
    required AddressBloc addressBloc,
  }) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationModal(
        title: 'Delete Address',
        content: 'Are you sure you want to remove this address?',
        confirmText: 'Delete',
        onConfirm: () {
          addressBloc.add(DeleteAddressEvent(addressId));
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
