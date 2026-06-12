import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
import 'shop_settings_event.dart';
import 'shop_settings_state.dart';

class ShopSettingsBloc extends Bloc<ShopSettingsEvent, ShopSettingsState> {
  final ChangeShopPassword changeShopPassword;
  final DeleteShopAuthAccount deleteShopAuthAccount;

  ShopSettingsBloc({
    required this.changeShopPassword,
    required this.deleteShopAuthAccount,
  }) : super(ShopSettingsInitial()) {
    on<ChangePasswordRequested>((event, emit) async {
      emit(ShopSettingsLoading());
      try {
        await changeShopPassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(ShopSettingsFailure(e.toString()));
      }
    });

    on<DeleteAccountRequested>((event, emit) async {
      emit(ShopSettingsLoading());
      try {
        await deleteShopAuthAccount(event.password);
        emit(DeleteAccountSuccess());
      } catch (e) {
        emit(ShopSettingsFailure(e.toString()));
      }
    });
  }
}
