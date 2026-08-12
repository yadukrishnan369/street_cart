import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/saved_addresses_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Checkout Address Section
class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    BlocProvider.value(
                      value: context.read<AddressBloc>(),
                      child: const SavedAddressesPage(),
                    ),
                  ),
                );
              },
              child: Text(
                'Change',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AddressesLoaded && state.addresses.isNotEmpty) {
              final defaultAddress = state.addresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => state.addresses.first,
              );

              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? CustomerAppColors.darkSurface
                      : CustomerAppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? CustomerAppColors.darkBorder
                        : Colors.grey.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? CustomerAppColors.primary.withValues(alpha: 0.15)
                            : CustomerAppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: CustomerAppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            defaultAddress.fullName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? CustomerAppColors.darkTextPrimary
                                  : CustomerAppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${defaultAddress.addressLine1}${defaultAddress.addressLine2.isNotEmpty ? ", ${defaultAddress.addressLine2}" : ""}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? CustomerAppColors.darkTextSecondary
                                  : CustomerAppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${defaultAddress.district.isNotEmpty ? defaultAddress.district : defaultAddress.city}'
                            '${defaultAddress.state.isNotEmpty ? ", ${defaultAddress.state}" : ""} - ${defaultAddress.pincode}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? CustomerAppColors.darkTextSecondary
                                  : CustomerAppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark
                    ? CustomerAppColors.darkSurface
                    : CustomerAppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? CustomerAppColors.darkBorder
                      : Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    color: isDark ? Colors.grey[500] : Colors.grey,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'No delivery address found.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : CustomerAppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        AppPageTransitions.slide(
                          BlocProvider.value(
                            value: context.read<AddressBloc>(),
                            child: const SavedAddressesPage(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add New Address',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomerAppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
