abstract class AdminRegistrationsEvent {
  const AdminRegistrationsEvent();
}

class LoadPendingRegistrationsRequested extends AdminRegistrationsEvent {
  final int page;
  final int limit;

  const LoadPendingRegistrationsRequested({
    required this.page,
    this.limit = 6,
  });
}
