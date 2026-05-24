import 'package:equatable/equatable.dart';
import '../../../../core/config/auth_provider_config.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSubscriptionRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSocialSignInRequested extends AuthEvent {
  final SocialAuthProvider provider;

  const AuthSocialSignInRequested(this.provider);

  @override
  List<Object> get props => [provider];
}

class AuthSignOutRequested extends AuthEvent {}
