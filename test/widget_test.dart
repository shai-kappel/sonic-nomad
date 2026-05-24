import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sonic_nomad/main.dart';
import 'package:sonic_nomad/features/canvas/presentation/pages/canvas_page.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_event.dart';
import 'package:sonic_nomad/features/auth/presentation/bloc/auth_state.dart';
import 'package:sonic_nomad/core/config/app_config.dart';
import 'package:sonic_nomad/app/di.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUp(() async {
    await getIt.reset();
    await initDependencies();

    // Register mock AuthBloc to avoid Firebase initialization in tests
    final mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthState.guest());
    getIt.allowReassignment = true;
    getIt.registerFactory<AuthBloc>(() => mockAuthBloc);
  });

  testWidgets('Smoke test: app launches and shows CanvasPage', (
    WidgetTester tester,
  ) async {
    // Initialize AppConfig for testing
    AppConfig.environment = Environment.dev;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const SonicNomadApp());
    await tester.pump(); // Allow BLoC initialization

    // Verify that the CanvasPage is present
    expect(find.byType(CanvasPage), findsOneWidget);

    // Verify initial zoom level is 100%
    expect(find.text('100%'), findsOneWidget);
  });
}
