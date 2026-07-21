abstract class AdminCustomersEvent {}

// Load Admin Customers Event
class LoadAdminCustomers extends AdminCustomersEvent {
  final int page;
  final int limit;

  LoadAdminCustomers({required this.page, required this.limit});
}

// Search Customers Query Changed Event
class SearchCustomersQueryChanged extends AdminCustomersEvent {
  final String query;

  SearchCustomersQueryChanged(this.query);
}

// Filter Customers Status Changed Event
class FilterCustomersStatusChanged extends AdminCustomersEvent {
  final String status;

  FilterCustomersStatusChanged(this.status);
}

// Toggle Customer Block Requested Event
class ToggleCustomerBlockRequested extends AdminCustomersEvent {
  final String uid;
  final bool isBlocked;

  ToggleCustomerBlockRequested({required this.uid, required this.isBlocked});
}
