import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/add_address_page.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/address_card.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/address_empty_state.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/shimmer/address_card_shimmer.dart';
import 'package:street_cart/features/customer/profile/presentation/utils/saved_addresses_helper.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AddressBloc>()..add(FetchAddresses()),
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        appBar: AppBar(
          backgroundColor: CustomerAppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Saved Address',
            style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
          ),
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AddressBloc>(),
                      child: const AddAddressPage(),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add_location_alt_outlined, size: 18.sp),
              label: Text(
                'Add New',
                style: CustomerAppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const AddressCardShimmer(itemCount: 3);
            }

            if (state is AddressError) {
              return Center(child: Text(state.message));
            }

            if (state is AddressesLoaded) {
              final addresses = state.addresses;

              if (addresses.isEmpty) {
                return AddressEmptyState(
                  onAddAddress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AddressBloc>(),
                          child: const AddAddressPage(),
                        ),
                      ),
                    );
                  },
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Text(
                      'SAVED ADDRESSES',
                      style: CustomerAppTextStyles.body.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return AddressCard(
                          address: address,
                          isSelected: address.isDefault,
                          onSelect: () => _toggleDefault(context, address.id),
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AddressBloc>(),
                                  child: AddAddressPage(address: address),
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            SavedAddressesHelper.showDeleteConfirmation(
                              context: context,
                              addressId: address.id,
                              addressBloc: context.read<AddressBloc>(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      if (state is AddressesLoaded &&
                          state.addresses.isNotEmpty) {
                        final hasDefault =
                            SavedAddressesHelper.hasDefaultAddress(
                              state.addresses,
                            );
                        final selectedAddress =
                            SavedAddressesHelper.getSelectedAddress(
                              state.addresses,
                            );
                        return Padding(
                          padding: EdgeInsets.all(24.w),
                          child: PrimaryButton(
                            text: 'Deliver to this Address',
                            suffixIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            onPressed: hasDefault
                                ? () => Navigator.pop(context, selectedAddress)
                                : () =>
                                      SavedAddressesHelper.showNoAddressSelectedDialog(
                                        context,
                                      ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _toggleDefault(BuildContext context, String id) {
    context.read<AddressBloc>().add(ToggleDefaultAddressEvent(id));
  }
}
