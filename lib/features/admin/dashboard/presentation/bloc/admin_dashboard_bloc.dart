import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetDashboardData getDashboardData;
  StreamSubscription? _shopsSubscription;
  StreamSubscription? _customersSubscription;

  AdminDashboardBloc({
    required this.getDashboardData,
    required FirebaseFirestore firestore,
  }) : super(AdminDashboardInitial()) {
    // Listen to changes in shops to automatically reload stats
    _shopsSubscription = firestore.collection('shops').snapshots().listen((_) {
      add(LoadDashboardDataRequested());
    });

    // Listen to changes in customers to automatically reload stats
    _customersSubscription = firestore.collection('customers').snapshots().listen((_) {
      add(LoadDashboardDataRequested());
    });

    on<LoadDashboardDataRequested>((event, emit) async {
      if (state is! AdminDashboardLoadSuccess) {
        emit(AdminDashboardLoading());
      }
      try {
        final stats = await getDashboardData();
        emit(AdminDashboardLoadSuccess(stats));
      } catch (e) {
        emit(AdminDashboardLoadFailure(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _shopsSubscription?.cancel();
    _customersSubscription?.cancel();
    return super.close();
  }
}
