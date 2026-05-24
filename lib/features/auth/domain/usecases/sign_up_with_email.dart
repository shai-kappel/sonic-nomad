import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<AuthSession> execute(String email, String password) async {
    return repository.signUpWithEmail(email, password);
  }
}
