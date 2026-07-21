import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';

abstract class AdminRegistrationsState {
  final int currentPage;
  final bool anyChanges;

  const AdminRegistrationsState({
    this.currentPage = 1,
    this.anyChanges = false,
  });
}

// Initial state of registration
class AdminRegistrationsInitial extends AdminRegistrationsState {
  const AdminRegistrationsInitial() : super();
}

// Registrations Loading State
class AdminRegistrationsLoading extends AdminRegistrationsState {
  const AdminRegistrationsLoading({super.currentPage, super.anyChanges});
}

// Registrations Load Success State
class AdminRegistrationsLoadSuccess extends AdminRegistrationsState {
  final List<NewRegistrationModel> registrations;
  final int totalCount;
  final int totalPages;

  const AdminRegistrationsLoadSuccess({
    required this.registrations,
    required super.currentPage,
    required this.totalCount,
    required this.totalPages,
    super.anyChanges,
  });

  AdminRegistrationsLoadSuccess copyWith({
    List<NewRegistrationModel>? registrations,
    int? currentPage,
    int? totalCount,
    int? totalPages,
    bool? anyChanges,
  }) {
    return AdminRegistrationsLoadSuccess(
      registrations: registrations ?? this.registrations,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      anyChanges: anyChanges ?? this.anyChanges,
    );
  }
}

// Registrations Load Failure State
class AdminRegistrationsLoadFailure extends AdminRegistrationsState {
  final String message;

  const AdminRegistrationsLoadFailure(
    this.message, {
    super.currentPage,
    super.anyChanges,
  });
}
