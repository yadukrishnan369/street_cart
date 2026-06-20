abstract class AdminAuthState {
  const AdminAuthState();
}

class AdminAuthInitial extends AdminAuthState {}

class AdminAuthLoading extends AdminAuthState {}

class AdminAuthSuccess extends AdminAuthState {}

class AdminAuthFailure extends AdminAuthState {
  final String message;

  const AdminAuthFailure(this.message);
}

class AdminUnauthenticated extends AdminAuthState {}

class AdminAuthPasswordResetSent extends AdminAuthState {}

class AdminAuthPasswordResetSuccess extends AdminAuthState {}
