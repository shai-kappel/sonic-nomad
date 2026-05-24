import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_session.dart';

enum AuthStatus { initial, loading, guest, authenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  const AuthState({required this.status, this.session, this.errorMessage});

  const AuthState.initial() : this(status: AuthStatus.initial);

  const AuthState.loading() : this(status: AuthStatus.loading);

  const AuthState.guest() : this(status: AuthStatus.guest);

  const AuthState.authenticated(AuthSession session)
    : this(status: AuthStatus.authenticated, session: session);

  const AuthState.failure(String message)
    : this(status: AuthStatus.failure, errorMessage: message);

  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isGuest => status == AuthStatus.guest;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isFailure => status == AuthStatus.failure;

  @override
  List<Object?> get props => [status, session, errorMessage];
}
