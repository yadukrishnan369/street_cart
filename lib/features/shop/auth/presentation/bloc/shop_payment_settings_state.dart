part of 'shop_payment_settings_cubit.dart';

abstract class ShopPaymentSettingsState extends Equatable {
  const ShopPaymentSettingsState();

  @override
  List<Object?> get props => [];
}

class ShopPaymentSettingsInitial extends ShopPaymentSettingsState {}

class ShopPaymentSettingsLoading extends ShopPaymentSettingsState {}

class ShopPaymentSettingsLoaded extends ShopPaymentSettingsState {
  final Map<String, bool> settings;

  const ShopPaymentSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ShopPaymentSettingsError extends ShopPaymentSettingsState {
  final String message;

  const ShopPaymentSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
