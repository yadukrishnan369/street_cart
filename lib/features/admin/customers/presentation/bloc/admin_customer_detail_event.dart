abstract class AdminCustomerDetailEvent {}

// Request loading customer details Event
class LoadCustomerDetailRequested extends AdminCustomerDetailEvent {
  final String uid;

  LoadCustomerDetailRequested(this.uid);
}

// Request toggling the block/unblock status Event
class ToggleBlockStatusRequested extends AdminCustomerDetailEvent {
  final String uid;
  final bool isBlocked;

  ToggleBlockStatusRequested({required this.uid, required this.isBlocked});
}

// Request deletion of the customer Event
class DeleteCustomerRequested extends AdminCustomerDetailEvent {
  final String uid;

  DeleteCustomerRequested(this.uid);
}

// Change Past Orders Page Requested Event
class ChangePastOrdersPageRequested extends AdminCustomerDetailEvent {
  final int page;

  ChangePastOrdersPageRequested(this.page);
}
