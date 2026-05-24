import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/auth_provider_config.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<AuthSession?> observeSession() {
    return _datasource.authStateChanges.map(_mapFirebaseUser);
  }

  @override
  Future<AuthSession> signUpWithEmail(String email, String password) async {
    final credential = await _datasource.signUpWithEmail(email, password);
    final user = credential.user;
    if (user == null) {
      throw Exception('User sign-up failed');
    }
    return _mapFirebaseUser(user)!;
  }

  @override
  Future<AuthSession> signInWithEmail(String email, String password) async {
    final credential = await _datasource.signInWithEmail(email, password);
    final user = credential.user;
    if (user == null) {
      throw Exception('User sign-in failed');
    }
    return _mapFirebaseUser(user)!;
  }

  @override
  Future<AuthSession> signInWithSocialProvider(
    SocialAuthProvider provider,
  ) async {
    final credential = await _datasource.signInWithSocialProvider(provider);
    final user = credential.user;
    if (user == null) {
      throw Exception('Social sign-in failed');
    }
    return _mapFirebaseUser(user)!;
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  AuthSession? _mapFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthSession(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
      providerIds: user.providerData.map((info) => info.providerId).toList(),
    );
  }
}
