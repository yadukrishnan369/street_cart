abstract class CustomerShopsEvent {}

// Event to fetch nearby shops
class FetchCustomerShops extends CustomerShopsEvent {}

// Event to update shop listing by search
class UpdateShopSearchQuery extends CustomerShopsEvent {
  final String searchQuery;

  UpdateShopSearchQuery(this.searchQuery);
}
