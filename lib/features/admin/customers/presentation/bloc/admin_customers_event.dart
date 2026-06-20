abstract class AdminCustomersEvent {}

class LoadAdminCustomers extends AdminCustomersEvent {
  final int page;
  final int limit;

  LoadAdminCustomers({required this.page, required this.limit});
}

class SearchCustomersQueryChanged extends AdminCustomersEvent {
  final String query;

  SearchCustomersQueryChanged(this.query);
}

class FilterCustomersStatusChanged extends AdminCustomersEvent {
  final String status;

  FilterCustomersStatusChanged(this.status);
}

class ToggleCustomerBlockRequested extends AdminCustomersEvent {
  final String uid;
  final bool isBlocked;

  ToggleCustomerBlockRequested({required this.uid, required this.isBlocked});
}
