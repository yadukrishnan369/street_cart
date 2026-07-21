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
    // Load Admin Profile
    on<LoadAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      try {
        final profile = await getProfileData();
        emit(AdminProfileLoaded(profile));
      } catch (e) {
        emit(AdminProfileError(e.toString()));
      }
    });
    // Update Admin Profile
    on<UpdateAdminProfile>((event, emit) async {
      final currentState = state;
      emit(AdminProfileLoading());
      try {
        await updateProfileName(event.fullName);
        final profile = await getProfileData();
        emit(AdminProfileLoaded(profile));
      } catch (e) {
        if (currentState is AdminProfileLoaded) {
          emit(currentState.copyWith());
        }
        emit(AdminProfileError(e.toString()));
      }
    });
    // Show Edit Overlay
    on<ShowEditOverlay>((event, emit) {
      if (state is AdminProfileLoaded) {
        emit((state as AdminProfileLoaded).copyWith(isEditing: true));
      }
    });
    // Hide Edit Overlay
    on<HideEditOverlay>((event, emit) {
      if (state is AdminProfileLoaded) {
        emit((state as AdminProfileLoaded).copyWith(isEditing: false));
      }
    });
  }
}
