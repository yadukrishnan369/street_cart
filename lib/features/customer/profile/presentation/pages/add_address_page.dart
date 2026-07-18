import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/address_form_section.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Address Page
class AddAddressPage extends StatelessWidget {
  final AddressModel? address; // Existing Address for Editing

  const AddAddressPage({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressActionSuccess) {
          CustomSnackBar.show(
            context,
            message: state.message,
            backgroundColor: CustomerAppColors.success,
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        appBar: AppBar(
          backgroundColor: CustomerAppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          // title
          title: Text(
            address == null ? 'Add New Address' : 'Edit Address',
            style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressError) {
              // App Error View
              return AppErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<AddressBloc>().add(FetchAddresses()),
              );
            }
            if (state is AddressActionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              // Address Form Section
              child: AddressFormSection(address: address),
            );
          },
        ),
      ),
    );
  }
}
