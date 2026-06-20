abstract class AdminCustomerDetailEvent {}

class LoadCustomerDetailRequested extends AdminCustomerDetailEvent {
  final String uid;

  LoadCustomerDetailRequested(this.uid);
}

class ToggleBlockStatusRequested extends AdminCustomerDetailEvent {
  final String uid;
  final bool isBlocked;

  ToggleBlockStatusRequested({required this.uid, required this.isBlocked});
}

class DeleteCustomerRequested extends AdminCustomerDetailEvent {
  final String uid;

  DeleteCustomerRequested(this.uid);
}
