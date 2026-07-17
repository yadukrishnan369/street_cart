// Base event class
abstract class HomeEvent {}

class FetchHomeData extends HomeEvent {}

class ResetHome extends HomeEvent {}

class SelectCategory extends HomeEvent {
  final String category;
  SelectCategory(this.category);
}

class ChangeBannerPage extends HomeEvent {
  final int pageIndex;
  ChangeBannerPage(this.pageIndex);
}
