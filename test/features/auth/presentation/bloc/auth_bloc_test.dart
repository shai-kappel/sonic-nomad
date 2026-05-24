import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sonic_nomad/core/config/auth_provider_config.dart';
import 'package:sonic_nomad/features/auth/domain/entities/auth_session.dart';
import 'package:sonic_nomad/features/auth/domain/usecases/observe_auth_state.dart';
import 'package:sonic_nomad/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:sonic_nomad/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:sonic_nomad/features/auth/domain/usecases/sign_in_with_social_provider.dart';
import 'package:sonic_nomad/features/auth/domain/usecases/sign_out.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_event.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_state.dart';

class MockObserveAuthState extends Mock implements ObserveAuthState {}
class MockSignInWithEmail extends Mock implements SignInWithEmail {}
class MockSignUpWithEmail extends Mock implements SignUpWithEmail {}
class MockSignInWithSocialProvider extends Mock implements SignInWithSocialProvider {}
class MockSignOut extends Mock implements SignOut {}

void main() {
  late AuthBloc bloc;
  late MockObserveAuthState mockObserveAuthState;
  late MockSignInWithEmail mockSignInWithEmail;
  late MockSignUpWithEmail mockSignUpWithEmail;
  late MockSignInWithSocialProvider mockSignInWithSocialProvider;
  late MockSignOut mockSignOut;

  const tSession = AuthSession(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    isAnonymous: false,
    providerIds: ['password'],
  );

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  setUpAll(() {
    registerFallbackValue(SocialAuthProvider.google);
  });

  setUp(() {
    mockObserveAuthState = MockObserveAuthState();
    mockSignInWithEmail = MockSignInWithEmail();
    mockSignUpWithEmail = MockSignUpWithEmail();
    mockSignInWithSocialProvider = MockSignInWithSocialProvider();
    mockSignOut = MockSignOut();

    bloc = AuthBloc(
      observeAuthState: mockObserveAuthState,
      signInWithEmail: mockSignInWithEmail,
      signUpWithEmail: mockSignUpWithEmail,
      signInWithSocialProvider: mockSignInWithSocialProvider,
      signOut: mockSignOut,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be initial', () {
    expect(bloc.state, const AuthState.initial());
  });

  blocTest<AuthBloc, AuthState>(
    'emits guest when observe session returns null',
    build: () {
      when(() => mockObserveAuthState.execute())
          .thenAnswer((_) => Stream.value(null));
      return bloc;
    },
    act: (bloc) => bloc.add(AuthSubscriptionRequested()),
    expect: () => [const AuthState.guest()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits authenticated when observe session returns user session',
    build: () {
      when(() => mockObserveAuthState.execute())
          .thenAnswer((_) => Stream.value(tSession));
      return bloc;
    },
    act: (bloc) => bloc.add(AuthSubscriptionRequested()),
    expect: () => [const AuthState.authenticated(tSession)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading] when signInWithEmail is requested',
    build: () {
      when(() => mockSignInWithEmail.execute(any(), any()))
          .thenAnswer((_) async => tSession);
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthSignInRequested(
      email: tEmail,
      password: tPassword,
    )),
    expect: () => [const AuthState.loading()],
    verify: (_) {
      verify(() => mockSignInWithEmail.execute(tEmail, tPassword)).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading] when signUpWithEmail is requested',
    build: () {
      when(() => mockSignUpWithEmail.execute(any(), any()))
          .thenAnswer((_) async => tSession);
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthSignUpRequested(
      email: tEmail,
      password: tPassword,
    )),
    expect: () => [const AuthState.loading()],
    verify: (_) {
      verify(() => mockSignUpWithEmail.execute(tEmail, tPassword)).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, failure] when signInWithEmail throws exception',
    build: () {
      when(() => mockSignInWithEmail.execute(any(), any()))
          .thenThrow(Exception('Invalid credentials'));
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthSignInRequested(
      email: tEmail,
      password: tPassword,
    )),
    expect: () => [
      const AuthState.loading(),
      const AuthState.failure('Exception: Invalid credentials'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading] when social sign-in is requested',
    build: () {
      when(() => mockSignInWithSocialProvider.execute(any()))
          .thenAnswer((_) async => tSession);
      return bloc;
    },
    act: (bloc) => bloc.add(
      const AuthSocialSignInRequested(SocialAuthProvider.google),
    ),
    expect: () => [const AuthState.loading()],
    verify: (_) {
      verify(() => mockSignInWithSocialProvider.execute(
        SocialAuthProvider.google,
      )).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading] when signOut is requested',
    build: () {
      when(() => mockSignOut.execute()).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(AuthSignOutRequested()),
    expect: () => [const AuthState.loading()],
    verify: (_) {
      verify(() => mockSignOut.execute()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits authenticated then guest as auth state stream changes',
    build: () {
      when(() => mockObserveAuthState.execute()).thenAnswer(
        (_) => Stream.fromIterable([tSession, null]),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(AuthSubscriptionRequested()),
    expect: () => [
      const AuthState.authenticated(tSession),
      const AuthState.guest(),
    ],
  );
}
