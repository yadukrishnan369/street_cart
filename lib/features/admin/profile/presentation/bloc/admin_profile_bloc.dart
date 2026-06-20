import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/get_admin_profile_data.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/update_admin_profile_name.dart';
import 'admin_profile_event.dart';
import 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final GetAdminProfileData getProfileData;
  final UpdateAdminProfileName updateProfileName;

  AdminProfileBloc({
    required this.getProfileData,
    required this.updateProfileName,
  }) : super(AdminProfileInitial()) {
    on<LoadAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      try {
        final profile = await getProfileData();
        emit(AdminProfileLoaded(profile));
      } catch (e) {
        emit(AdminProfileError(e.toString()));
      }
    });

    on<UpdateAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      try {
        await updateProfileName(event.fullName);
        final profile = await getProfileData();
        emit(AdminProfileLoaded(profile));
      } catch (e) {
        emit(AdminProfileError(e.toString()));
      }
    });
  }
}
