// Base event class
abstract class AdminRegistrationsEvent {
  const AdminRegistrationsEvent();
}

// load pending shop registrations Event
class LoadPendingRegistrationsRequested extends AdminRegistrationsEvent {
  final int page;
  final int limit;

  const LoadPendingRegistrationsRequested({required this.page, this.limit = 6});
}

// change the registration list Event
class ChangeRegistrationPageRequested extends AdminRegistrationsEvent {
  final int page;
  const ChangeRegistrationPageRequested(this.page);
}

// Mark Registration Changes Requested Event
class MarkRegistrationChangesRequested extends AdminRegistrationsEvent {
  const MarkRegistrationChangesRequested();
}
