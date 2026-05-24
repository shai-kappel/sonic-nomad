import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final List<String> providerIds;

  const AuthSession({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
    required this.providerIds,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    isAnonymous,
    providerIds,
  ];
}
