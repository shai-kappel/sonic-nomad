import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sonic_nomad/features/auth/domain/entities/auth_session.dart';
import 'package:sonic_nomad/core/config/auth_provider_config.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_event.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_state.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/auth_entry_sheet.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/email_auth_form.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/social_sign_in_buttons.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(const AuthSignUpRequested(
      email: 'fallback@example.com',
      password: 'password123',
    ));
    registerFallbackValue(
      const AuthSocialSignInRequested(SocialAuthProvider.google),
    );
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const AuthEntrySheet(),
        ),
      ),
    );
  }

  void stubGuestState() {
    when(() => mockAuthBloc.state).thenReturn(const AuthState.guest());
  }

  testWidgets('renders EmailAuthForm and SocialSignInButtons when state is guest', (
    WidgetTester tester,
  ) async {
    stubGuestState();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(EmailAuthForm), findsOneWidget);
    expect(find.byType(SocialSignInButtons), findsOneWidget);
    expect(find.text('Sign Out'), findsNothing);
  });

  testWidgets('renders loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(const AuthState.loading());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(EmailAuthForm), findsNothing);
  });

  testWidgets('renders user session info and sign out button when state is authenticated', (
    WidgetTester tester,
  ) async {
    const tSession = AuthSession(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      isAnonymous: false,
      providerIds: ['password'],
    );

    when(() => mockAuthBloc.state).thenReturn(const AuthState.authenticated(tSession));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
    expect(find.byType(EmailAuthForm), findsNothing);
  });

  testWidgets('dispatches sign up request from email form', (
    WidgetTester tester,
  ) async {
    stubGuestState();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(0), 'new@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Create Account'));
    await tester.pump();

    verify(() => mockAuthBloc.add(const AuthSignUpRequested(
      email: 'new@example.com',
      password: 'password123',
    ))).called(1);
  });

  testWidgets('dispatches social provider event when tapping Google button', (
    WidgetTester tester,
  ) async {
    stubGuestState();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Continue with Google'));
    await tester.pump();

    verify(() => mockAuthBloc.add(
      const AuthSocialSignInRequested(SocialAuthProvider.google),
    )).called(1);
  }, variant: const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.android}));

  testWidgets('hides Apple sign-in on Android', (
    WidgetTester tester,
  ) async {
    stubGuestState();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
  }, variant: const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.android}));

  testWidgets('shows Apple sign-in on iOS', (
    WidgetTester tester,
  ) async {
    stubGuestState();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Continue with Apple'), findsOneWidget);
  }, variant: const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));
}
