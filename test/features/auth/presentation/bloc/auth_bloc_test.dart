import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
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

  final tSession = const AuthSession(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    isAnonymous: false,
    providerIds: ['password'],
  );

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
    expect: () => [AuthState.authenticated(tSession)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading] when signInWithEmail is requested',
    build: () {
      when(() => mockSignInWithEmail.execute(any(), any()))
          .thenAnswer((_) async => tSession);
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthSignInRequested(
      email: 'test@example.com',
      password: 'password123',
    )),
    expect: () => [const AuthState.loading()],
    verify: (_) {
      verify(() => mockSignInWithEmail.execute('test@example.com', 'password123')).called(1);
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
      email: 'test@example.com',
      password: 'password123',
    )),
    expect: () => [
      const AuthState.loading(),
      const AuthState.failure('Exception: Invalid credentials'),
    ],
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
}
