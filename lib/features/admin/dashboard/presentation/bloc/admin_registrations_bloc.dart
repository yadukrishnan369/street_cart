import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pending_registrations.dart';
import '../../domain/usecases/get_pending_registrations_count.dart';
import 'admin_registrations_event.dart';
import 'admin_registrations_state.dart';

class AdminRegistrationsBloc extends Bloc<AdminRegistrationsEvent, AdminRegistrationsState> {
  final GetPendingRegistrations getPendingRegistrations;
  final GetPendingRegistrationsCount getPendingRegistrationsCount;

  AdminRegistrationsBloc({
    required this.getPendingRegistrations,
    required this.getPendingRegistrationsCount,
  }) : super(AdminRegistrationsInitial()) {
    on<LoadPendingRegistrationsRequested>((event, emit) async {
      emit(AdminRegistrationsLoading());
      try {
        final totalCount = await getPendingRegistrationsCount();
        final registrations = await getPendingRegistrations(
          page: event.page,
          limit: event.limit,
        );
        final totalPages = (totalCount / event.limit).ceil();
        
        emit(AdminRegistrationsLoadSuccess(
          registrations: registrations,
          currentPage: event.page,
          totalCount: totalCount,
          totalPages: totalPages > 0 ? totalPages : 1,
        ));
      } catch (e) {
        emit(AdminRegistrationsLoadFailure(e.toString()));
      }
    });
  }
}
