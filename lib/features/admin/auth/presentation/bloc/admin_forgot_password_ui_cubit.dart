import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminForgotPasswordUiState {
  final int countdown;
  final bool isResetLinkSent;

  const AdminForgotPasswordUiState({
    this.countdown = 80,
    this.isResetLinkSent = false,
  });

  AdminForgotPasswordUiState copyWith({
    int? countdown,
    bool? isResetLinkSent,
  }) {
    return AdminForgotPasswordUiState(
      countdown: countdown ?? this.countdown,
      isResetLinkSent: isResetLinkSent ?? this.isResetLinkSent,
    );
  }
}

class AdminForgotPasswordUiCubit extends Cubit<AdminForgotPasswordUiState> {
  AdminForgotPasswordUiCubit() : super(const AdminForgotPasswordUiState());

  Timer? _timer;

  void startCountdown(VoidCallback onExpired) {
    _timer?.cancel();
    emit(const AdminForgotPasswordUiState(countdown: 80, isResetLinkSent: true));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        emit(state.copyWith(countdown: state.countdown - 1));
      } else {
        _timer?.cancel();
        onExpired();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
