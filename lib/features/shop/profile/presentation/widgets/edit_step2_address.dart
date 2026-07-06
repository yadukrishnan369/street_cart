import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

class EditStep2Address extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullAddressController;
  final TextEditingController landmarkController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;

  final String? selectedDistrict;
  final List<String> districts;
  final ValueChanged<String?> onDistrictChanged;

  final String? selectedState;
  final List<String> states;
  final ValueChanged<String?> onStateChanged;

  final List<String> selectedPaymentMethods;
  final Function(String, bool) onPaymentMethodChanged;
  final bool enableCod;
  final bool enableOnline;

  const EditStep2Address({
    super.key,
    required this.formKey,
    required this.fullAddressController,
    required this.landmarkController,
    required this.cityController,
    required this.pincodeController,
    required this.selectedDistrict,
    required this.districts,
    required this.onDistrictChanged,
    required this.selectedState,
    required this.states,
    required this.onStateChanged,
    required this.selectedPaymentMethods,
    required this.onPaymentMethodChanged,
    required this.enableCod,
    required this.enableOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Details',
            style: ShopAppTextStyles.heading1.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please provide the physical location of your business for customers to find you.',
            style: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          CustomTextField(
            label: "Full Address (Building No, Street, Area)",
            controller: fullAddressController,
            hintText: 'e.g. 12/456, Textile Street, SM Street',
            maxLines: 3,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "Landmark",
            controller: landmarkController,
            hintText: 'e.g. Near Old Mosque',
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Landmark is required';
              }
              return null;
            },
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  label: "City",
                  controller: cityController,
                  hintText: 'Kozhikode',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                  labelStyle: ShopAppTextStyles.bodyMediumBold,
                  textStyle: ShopAppTextStyles.bodyMedium,
                  hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                    color: ShopAppColors.textTertiary,
                  ),
                  fillColor: ShopAppColors.surface,
                  borderColor: ShopAppColors.border,
                  focusedBorderColor: ShopAppColors.primary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomTextField(
                  label: "Pincode",
                  controller: pincodeController,
                  hintText: '673001',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Pincode is required';
                    }
                    return null;
                  },
                  labelStyle: ShopAppTextStyles.bodyMediumBold,
                  textStyle: ShopAppTextStyles.bodyMedium,
                  hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                    color: ShopAppColors.textTertiary,
                  ),
                  fillColor: ShopAppColors.surface,
                  borderColor: ShopAppColors.border,
                  focusedBorderColor: ShopAppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'District',
                        style: ShopAppTextStyles.bodyMediumBold,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedDistrict,
                      decoration: _buildDropdownDecoration(),
                      items: districts.map((String district) {
                        return DropdownMenuItem<String>(
                          value: district,
                          child: Text(
                            district,
                            style: ShopAppTextStyles.bodyMedium,
                          ),
                        );
                      }).toList(),
                      onChanged: onDistrictChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'State',
                        style: ShopAppTextStyles.bodyMediumBold,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedState,
                      decoration: _buildDropdownDecoration(),
                      items: states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(
                            state,
                            style: ShopAppTextStyles.bodyMedium,
                          ),
                        );
                      }).toList(),
                      onChanged: onStateChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          if (enableCod || enableOnline) ...[
            Text(
              'Payment Methods',
              style: ShopAppTextStyles.heading1.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
          ],
          if (enableOnline) ...[
            _buildPaymentOption(
              title: 'Google Pay',
              icon: Icons.account_balance_wallet_outlined,
              value: 'Google Pay',
            ),
            SizedBox(height: 8.h),
          ],
          if (enableCod) ...[
            _buildPaymentOption(
              title: 'Cash on Delivery',
              icon: Icons.money_outlined,
              value: 'Cash on Delivery',
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _buildDropdownDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      fillColor: ShopAppColors.surface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ShopAppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ShopAppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ShopAppColors.primary),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedPaymentMethods.contains(value);

    return InkWell(
      onTap: () {
        onPaymentMethodChanged(value, !isSelected);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ShopAppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? ShopAppColors.primary : ShopAppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ShopAppColors.primary
                  : ShopAppColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: isSelected
                      ? ShopAppColors.primary
                      : ShopAppColors.textPrimary,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? ShopAppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? ShopAppColors.primary
                      : ShopAppColors.border,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : const SizedBox(width: 16, height: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
