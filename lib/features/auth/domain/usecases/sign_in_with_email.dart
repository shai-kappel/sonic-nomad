import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<AuthSession> execute(String email, String password) async {
    return repository.signInWithEmail(email, password);
  }
}
