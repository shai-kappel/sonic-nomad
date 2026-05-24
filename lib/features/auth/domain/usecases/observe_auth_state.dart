import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class ObserveAuthState {
  final AuthRepository repository;

  ObserveAuthState(this.repository);

  Stream<AuthSession?> execute() {
    return repository.observeSession();
  }
}
