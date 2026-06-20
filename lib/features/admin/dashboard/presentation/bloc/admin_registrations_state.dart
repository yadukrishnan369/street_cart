import '../../data/models/new_registration_model.dart';

abstract class AdminRegistrationsState {
  const AdminRegistrationsState();
}

class AdminRegistrationsInitial extends AdminRegistrationsState {}

class AdminRegistrationsLoading extends AdminRegistrationsState {}

class AdminRegistrationsLoadSuccess extends AdminRegistrationsState {
  final List<NewRegistrationModel> registrations;
  final int currentPage;
  final int totalCount;
  final int totalPages;

  const AdminRegistrationsLoadSuccess({
    required this.registrations,
    required this.currentPage,
    required this.totalCount,
    required this.totalPages,
  });
}

class AdminRegistrationsLoadFailure extends AdminRegistrationsState {
  final String message;

  const AdminRegistrationsLoadFailure(this.message);
}
