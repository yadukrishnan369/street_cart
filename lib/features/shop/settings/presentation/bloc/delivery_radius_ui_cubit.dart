import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryRadiusUiState {
  final double radius;

  const DeliveryRadiusUiState({required this.radius});
}

class DeliveryRadiusUiCubit extends Cubit<DeliveryRadiusUiState> {
  DeliveryRadiusUiCubit(double initialRadius)
    : super(DeliveryRadiusUiState(radius: initialRadius));

  void updateRadius(double val) {
    emit(DeliveryRadiusUiState(radius: val));
  }
}
