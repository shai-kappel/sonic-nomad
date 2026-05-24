import '../entities/auth_session.dart';
import '../../../../core/config/auth_provider_config.dart';

abstract class AuthRepository {
  Stream<AuthSession?> observeSession();
  Future<AuthSession> signUpWithEmail(String email, String password);
  Future<AuthSession> signInWithEmail(String email, String password);
  Future<AuthSession> signInWithSocialProvider(SocialAuthProvider provider);
  Future<void> signOut();
}
