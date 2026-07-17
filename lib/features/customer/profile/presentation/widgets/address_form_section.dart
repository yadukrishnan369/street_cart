import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/profile/presentation/widgets/address_type_selector.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Address Form section
class AddressFormSection extends StatefulWidget {
  final AddressModel? address;

  const AddressFormSection({super.key, this.address});

  @override
  State<AddressFormSection> createState() => _AddressFormSectionState();
}

class _AddressFormSectionState extends State<AddressFormSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _line1Controller;
  late TextEditingController _line2Controller;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _line1Controller = TextEditingController(
      text: widget.address?.addressLine1,
    );
    _line2Controller = TextEditingController(
      text: widget.address?.addressLine2,
    );
    _districtController = TextEditingController(
      text: widget.address?.district ?? widget.address?.city,
    );
    _stateController = TextEditingController(text: widget.address?.state);
    _pincodeController = TextEditingController(text: widget.address?.pincode);

    // Initialize Selected type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AddressBloc>().add(
          SelectAddressTypeEvent(widget.address?.type ?? 'HOME'),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  // Validate Fields and Add/Update address
  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        id: widget.address?.id ?? '',
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _line1Controller.text.trim(),
        addressLine2: _line2Controller.text.trim(),
        city: _districtController.text.trim(),
        district: _districtController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: context.read<AddressBloc>().state.selectedType,
        isDefault: widget.address?.isDefault ?? false,
        latitude: widget.address?.latitude,
        longitude: widget.address?.longitude,
      );

      if (widget.address == null) {
        context.read<AddressBloc>().add(AddAddressEvent(address));
      } else {
        context.read<AddressBloc>().add(UpdateAddressEvent(address));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          CustomTextField(
            label: 'Full Name',
            hintText: 'e.g., Rahul Nair',
            controller: _nameController,
            validator: Validators.validateName,
          ),
          SizedBox(height: 20.h),
          // Phone Field
          CustomTextField(
            label: 'Phone Number',
            hintText: 'e.g., 9876543210',
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            validator: Validators.validateAddressPhone,
          ),
          SizedBox(height: 20.h),
          // Primary Address
          CustomTextField(
            label: 'Address Line 1',
            hintText: 'House No., Building Name',
            controller: _line1Controller,
            validator: Validators.validateAddress1,
          ),
          SizedBox(height: 20.h),
          // Secondary Address
          CustomTextField(
            label: 'Address Line 2',
            hintText: 'Street Name, Locality - e.g., Mavoor Road',
            controller: _line2Controller,
            validator: Validators.validateAddress2,
          ),
          SizedBox(height: 20.h),
          // District Field
          CustomTextField(
            label: 'District',
            hintText: 'Kozhikode',
            controller: _districtController,
            validator: Validators.validateDistrict,
          ),
          SizedBox(height: 20.h),
          // State and Pincode Fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'State',
                  hintText: 'Kerala',
                  controller: _stateController,
                  validator: Validators.validateState,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomTextField(
                  label: 'Pincode',
                  hintText: '673001',
                  keyboardType: TextInputType.number,
                  controller: _pincodeController,
                  validator: Validators.validatePincode,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          // Type Selector- HOME, WORK, OTHER
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              return AddressTypeSelector(
                selectedType: state.selectedType,
                onTypeChanged: (type) => context.read<AddressBloc>().add(
                  SelectAddressTypeEvent(type),
                ),
              );
            },
          ),
          SizedBox(height: 48.h),
          // Primary Button
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              return PrimaryButton(
                text: widget.address == null
                    ? 'Save Address'
                    : 'Update Address',
                isLoading: state is AddressActionLoading,
                onPressed: _saveAddress,
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
