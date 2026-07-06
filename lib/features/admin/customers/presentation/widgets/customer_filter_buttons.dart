import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_event.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_ui_cubit.dart';

class CustomerFilterButtons extends StatelessWidget {
  final String currentFilter;

  const CustomerFilterButtons({super.key, required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Active', 'Blocked'];
    final labels = {
      'All': 'All Customers',
      'Active': 'Active',
      'Blocked': 'Blocked',
    };

    return Row(
      children: filters.map((filter) {
        final isSelected = currentFilter == filter;
        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: ChoiceChip(
            label: Text(
              labels[filter]!,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF6C6C80),
              ),
            ),
            selected: isSelected,
            selectedColor: AdminAppColors.primaryColor,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFFE8E7ED),
                width: 1.2,
              ),
            ),
            onSelected: (val) {
              if (val) {
                context.read<AdminCustomersUiCubit>().resetPage();
                context.read<AdminCustomersBloc>().add(
                  FilterCustomersStatusChanged(filter),
                );
              }
            },
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }
}
