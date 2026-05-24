import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 05 Nyquist Validation:', () {
    group('1. Firebase Initialization & Platform Wiring:', () {
      test('lib/main.dart should initialize Firebase before running dependencies and UI', () {
        final file = File('lib/main.dart');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('Firebase.initializeApp('));
        expect(content, contains('DefaultFirebaseOptions.currentPlatform'));
        expect(content.indexOf('Firebase.initializeApp'), lessThan(content.indexOf('runApp')));
      });

      test('firebase_options.dart should exist and contain DefaultFirebaseOptions', () {
        final file = File('lib/firebase_options.dart');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('class DefaultFirebaseOptions'));
        expect(content, contains('FirebaseOptions get currentPlatform'));
      });
    });

    group('2. Clean Architecture Layer Separation (Auth):', () {
      test('Auth Domain layers should not import Data layers (boundary enforcement)', () {
        final domainDir = Directory('lib/features/auth/domain');
        expect(domainDir.existsSync(), isTrue);

        final files = domainDir.listSync(recursive: true).whereType<File>();
        for (final file in files) {
          if (!file.path.endsWith('.dart')) continue;
          final content = file.readAsStringSync();

          // Domain should not import data sources, models, or implementations
          expect(
            content,
            isNot(contains(RegExp(r'import\s+.*\/data\/'))),
            reason: '${file.path} violates clean architecture by importing data layer elements.',
          );
        }
      });

      test('AuthRepository should be abstract class in domain', () {
        final file = File('lib/features/auth/domain/repositories/auth_repository.dart');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('abstract class AuthRepository'));
      });

      test('AuthRepositoryImpl should exist in data layer and implement domain interface', () {
        final file = File('lib/features/auth/data/repositories/auth_repository_impl.dart');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('implements AuthRepository'));
      });
    });

    group('3. UI Affordances & Guest-Safe Boundaries:', () {
      test('CanvasPage should contain AuthStatusButton as a non-blocking overlay', () {
        final file = File('lib/features/canvas/presentation/pages/canvas_page.dart');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('AuthStatusButton'));
      });

      test('No guest-mode local persistence package or custom local-cache write path should be used in Auth feature', () {
        final authDir = Directory('lib/features/auth');
        expect(authDir.existsSync(), isTrue);

        final files = authDir.listSync(recursive: true).whereType<File>();
        for (final file in files) {
          if (!file.path.endsWith('.dart')) continue;
          final content = file.readAsStringSync();

          // Assert guest-session is ephemeral and doesn't write to disk
          expect(content, isNot(contains('shared_preferences')));
          expect(content, isNot(contains('Hive')));
          expect(content, isNot(contains('Isar')));
          expect(content, isNot(contains('sqflite')));
        }
      });
    });

    group('4. Required Phase 5 Automated Test Suites:', () {
      test('Auth BLoC unit tests and AuthEntrySheet widget tests must exist', () {
        final blocTest = File('test/features/auth/presentation/bloc/auth_bloc_test.dart');
        final widgetTest = File('test/features/auth/presentation/widgets/auth_entry_sheet_test.dart');

        expect(blocTest.existsSync(), isTrue, reason: 'AuthBloc unit test suite is missing.');
        expect(widgetTest.existsSync(), isTrue, reason: 'AuthEntrySheet widget test suite is missing.');
      });
    });
  });
}
