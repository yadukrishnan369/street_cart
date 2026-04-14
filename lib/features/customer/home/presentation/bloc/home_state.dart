abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String? address;

  HomeLoaded({this.address});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
