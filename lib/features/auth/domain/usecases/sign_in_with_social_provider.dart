import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/config/auth_provider_config.dart';

class SignInWithSocialProvider {
  final AuthRepository repository;

  SignInWithSocialProvider(this.repository);

  Future<AuthSession> execute(SocialAuthProvider provider) async {
    return repository.signInWithSocialProvider(provider);
  }
}
