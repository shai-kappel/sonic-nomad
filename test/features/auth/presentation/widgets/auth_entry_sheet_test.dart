import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sonic_nomad/features/auth/domain/entities/auth_session.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_event.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_state.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/auth_entry_sheet.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/email_auth_form.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/social_sign_in_buttons.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

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

  testWidgets('renders EmailAuthForm and SocialSignInButtons when state is guest', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(const AuthState.guest());

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
    final tSession = const AuthSession(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      isAnonymous: false,
      providerIds: ['password'],
    );

    when(() => mockAuthBloc.state).thenReturn(AuthState.authenticated(tSession));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
    expect(find.byType(EmailAuthForm), findsNothing);
  });
}
