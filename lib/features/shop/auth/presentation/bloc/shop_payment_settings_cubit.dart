import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_payment_settings.dart';

part 'shop_payment_settings_state.dart';

class ShopPaymentSettingsCubit extends Cubit<ShopPaymentSettingsState> {
  final GetShopPaymentSettings _getShopPaymentSettings;

  ShopPaymentSettingsCubit({
    required GetShopPaymentSettings getShopPaymentSettings,
  })  : _getShopPaymentSettings = getShopPaymentSettings,
        super(ShopPaymentSettingsInitial());

  Future<void> loadPaymentSettings() async {
    emit(ShopPaymentSettingsLoading());
    try {
      final settings = await _getShopPaymentSettings();
      emit(ShopPaymentSettingsLoaded(settings));
    } catch (e) {
      emit(ShopPaymentSettingsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
