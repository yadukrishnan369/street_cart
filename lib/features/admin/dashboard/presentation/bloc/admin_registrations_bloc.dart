import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations_count.dart';
import 'admin_registrations_event.dart';
import 'admin_registrations_state.dart';

class AdminRegistrationsBloc
    extends Bloc<AdminRegistrationsEvent, AdminRegistrationsState> {
  final GetPendingRegistrations getPendingRegistrations;
  final GetPendingRegistrationsCount getPendingRegistrationsCount;

  AdminRegistrationsBloc({
    required this.getPendingRegistrations,
    required this.getPendingRegistrationsCount,
  }) : super(const AdminRegistrationsInitial()) {
    // loading pending registrations list
    on<LoadPendingRegistrationsRequested>((event, emit) async {
      emit(
        AdminRegistrationsLoading(
          currentPage: event.page,
          anyChanges: state.anyChanges,
        ),
      );
      try {
        final totalCount = await getPendingRegistrationsCount();
        final registrations = await getPendingRegistrations(
          page: event.page,
          limit: event.limit,
        );
        final totalPages = (totalCount / event.limit).ceil();

        emit(
          AdminRegistrationsLoadSuccess(
            registrations: registrations,
            currentPage: event.page,
            totalCount: totalCount,
            totalPages: totalPages > 0 ? totalPages : 1,
            anyChanges: state.anyChanges,
          ),
        );
      } catch (e) {
        emit(
          AdminRegistrationsLoadFailure(
            e.toString(),
            currentPage: event.page,
            anyChanges: state.anyChanges,
          ),
        );
      }
    });

    // change registration page Requested
    on<ChangeRegistrationPageRequested>((event, emit) {
      if (state is AdminRegistrationsLoadSuccess) {
        final successState = state as AdminRegistrationsLoadSuccess;
        emit(successState.copyWith(currentPage: event.page));
      } else {
        emit(
          AdminRegistrationsLoading(
            currentPage: event.page,
            anyChanges: state.anyChanges,
          ),
        );
      }
      // Re-trigger load for the selected page
      add(LoadPendingRegistrationsRequested(page: event.page));
    });

    // Mark Registration Changes Requested
    on<MarkRegistrationChangesRequested>((event, emit) {
      if (state is AdminRegistrationsLoadSuccess) {
        final successState = state as AdminRegistrationsLoadSuccess;
        emit(successState.copyWith(anyChanges: true));
      }
    });
  }
}
