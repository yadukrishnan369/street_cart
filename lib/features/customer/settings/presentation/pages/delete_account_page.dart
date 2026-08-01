import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_state.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/delete_account_form.dart';
import 'package:street_cart/features/customer/settings/presentation/utils/settings_helper.dart';

// Delete Account Page
class DeleteAccountPage extends StatefulWidget {
  final bool isEmailUser;
  const DeleteAccountPage({super.key, required this.isEmailUser});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Show Delete confirmation modal
  void _confirmDelete() {
    if (widget.isEmailUser && !_formKey.currentState!.validate()) return;

    SettingsHelper.showDeleteAccountConfirm(
      context: context,
      onConfirmed: () {
        SettingsHelper.showDeleteAccountConfirmDouble(
          context: context,
          onConfirmed: _performDelete,
        );
      },
    );
  }

  // Permanent Account Deletion
  void _performDelete() {
    context.read<AuthBloc>().add(
      DeleteAccountRequested(
        widget.isEmailUser ? _passwordController.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAccountDeleted) {
          CustomSnackBar.show(
            context,
            message: 'Account deleted successfully.',
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthError) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                // Page Header
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delete Account Form Field
                    DeleteAccountForm(
                      formKey: _formKey,
                      passwordController: _passwordController,
                      isEmailUser: widget.isEmailUser,
                      obscurePassword: settingsState.obscureDeletePassword,
                      onObscurePressed: () => context.read<SettingsBloc>().add(
                        ToggleObscureDeletePassword(),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // Action button to delete account
                    PrimaryButton(
                      text: 'Delete Account',
                      backgroundColor: Colors.red,
                      textStyle: CustomerAppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      isLoading: isLoading,
                      suffixIcon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: _confirmDelete,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
