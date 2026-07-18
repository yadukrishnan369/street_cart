import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/add_address_page.dart';

// Saved Address App Bar
class SavedAddressesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SavedAddressesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomerAppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      // Title
      title: Text(
        'Saved Address',
        style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
      ),
      centerTitle: true,
      actions: [
        TextButton.icon(
          onPressed: () {
            // Navigate to Add New Address Page
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
