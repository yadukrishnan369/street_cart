import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_state.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/return_additional_details_input.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/return_item_card.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/return_reason_selection_list.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/return_section_header_title.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/submit_return_request_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Return Request Page
class ReturnRequestPage extends StatefulWidget {
  final OrderModel order;
  final OrderItemModel item;

  const ReturnRequestPage({super.key, required this.order, required this.item});

  @override
  State<ReturnRequestPage> createState() => _ReturnRequestPageState();
}

class _ReturnRequestPageState extends State<ReturnRequestPage> {
  final ValueNotifier<String> _selectedReasonNotifier = ValueNotifier<String>(
    'Item is damaged',
  );
  final TextEditingController _detailsController = TextEditingController();
  // Reasons of Return
  final List<String> _returnReasons = [
    'Item is damaged',
    'Wrong size received',
    'Not as described',
    'Other reasons',
  ];

  @override
  void dispose() {
    _selectedReasonNotifier.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Return Confirming Modal
  void _onConfirmSubmit() {
    OrdersHelper.showConfirmSubmitReturnDialog(
      context: context,
      orderId: widget.order.id,
      itemId: widget.item.id,
      reason: _selectedReasonNotifier.value,
      details: _detailsController.text.trim(),
      ordersBloc: context.read<OrdersBloc>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is ReturnRequestSubmittedSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Return request submitted successfully!',
          );
          Navigator.pop(context);
        } else if (state is OrdersFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.cardColor,
          elevation: 0.5,
          centerTitle: true,
          // Page Title
          title: Text(
            'Return Request',
            style: TextStyle(
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Return Section Header Title
                const ReturnSectionHeaderTitle(title: 'RETURN ITEM'),
                SizedBox(height: 10.h),

                // Return Item Card
                ReturnItemCard(item: widget.item),
                SizedBox(height: 24.h),

                // Return Section Header Title
                const ReturnSectionHeaderTitle(title: 'REASON FOR RETURN'),
                SizedBox(height: 10.h),

                // Return Reason Selection List
                ValueListenableBuilder<String>(
                  valueListenable: _selectedReasonNotifier,
                  builder: (context, selectedReason, _) {
                    return ReturnReasonSelectionList(
                      reasons: _returnReasons,
                      selectedReason: selectedReason,
                      onSelect: (reason) =>
                          _selectedReasonNotifier.value = reason,
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Return Section Header Title
                const ReturnSectionHeaderTitle(
                  title: 'ADDITIONAL DETAILS (optional)',
                ),
                SizedBox(height: 10.h),

                // Return Additional Details Input
                ReturnAdditionalDetailsInput(controller: _detailsController),
                SizedBox(height: 32.h),

                // Submit Return Request Button
                SubmitReturnRequestButton(onSubmit: _onConfirmSubmit),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
