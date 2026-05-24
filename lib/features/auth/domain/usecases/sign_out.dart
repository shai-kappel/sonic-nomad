import '../repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> execute() async {
    return repository.signOut();
  }
}
