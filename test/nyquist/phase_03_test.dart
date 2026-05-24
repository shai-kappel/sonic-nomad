import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 03 Nyquist Validation:', () {
    group('1. MusicBrainz API Client & Rate Limiting:', () {
      test(
        'musicbrainz_api.dart should exist and have rate limiting and User-Agent configured',
        () {
          final file = File(
            'lib/features/musicbrainz/data/datasources/musicbrainz_api.dart',
          );
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();

          // Assert client-side rate limiting configuration
          expect(content, contains('Duration(seconds: 1)'));
          expect(content, contains('_waitForSlot('));
          expect(content, contains('_processQueue('));

          // Assert User-Agent matches MusicBrainz policy
          expect(content, contains('User-Agent'));
          expect(
            content,
            contains('SonicNomad/1.0.0 ( contact@sonicnomad.app )'),
          );
        },
      );
    });

    group('2. Clean Architecture Layer Separation:', () {
      test('Domain layers should not import Data layers (boundary enforcement)', () {
        final domainDir = Directory('lib/features/musicbrainz/domain');
        expect(domainDir.existsSync(), isTrue);

        final files = domainDir.listSync(recursive: true).whereType<File>();
        for (final file in files) {
          if (!file.path.endsWith('.dart')) continue;
          final content = file.readAsStringSync();

          // Domain should not import data sources, models, or implementations
          expect(
            content,
            isNot(contains('import \'../../data')),
            reason:
                '${file.path} violates clean architecture by importing data layer elements.',
          );
          expect(
            content,
            isNot(contains('import \'../data')),
            reason:
                '${file.path} violates clean architecture by importing data layer elements.',
          );
          expect(
            content,
            isNot(contains('package:http/http.dart')),
            reason:
                '${file.path} violates clean architecture by importing direct HTTP package.',
          );
        }
      });

      test('MusicBrainzRepository should be abstract/interface in domain', () {
        final file = File(
          'lib/features/musicbrainz/domain/repositories/musicbrainz_repository.dart',
        );
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('abstract class MusicBrainzRepository'));
      });

      test(
        'MusicBrainzRepositoryImpl should exist in data layer and implement domain interface',
        () {
          final file = File(
            'lib/features/musicbrainz/data/repositories/musicbrainz_repository_impl.dart',
          );
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();
          expect(content, contains('implements MusicBrainzRepository'));
          expect(content, contains('final MusicBrainzApi'));
        },
      );
    });

    group('3. Data Models vs Domain Entities Boundary:', () {
      test(
        'MBArtistModel and MBRelationModel should have toEntity() methods',
        () {
          final artistModelFile = File(
            'lib/features/musicbrainz/data/models/mb_artist_model.dart',
          );
          final relationModelFile = File(
            'lib/features/musicbrainz/data/models/mb_relation_model.dart',
          );

          expect(artistModelFile.existsSync(), isTrue);
          expect(relationModelFile.existsSync(), isTrue);

          final artistModelContent = artistModelFile.readAsStringSync();
          final relationModelContent = relationModelFile.readAsStringSync();

          expect(artistModelContent, contains('Artist toEntity()'));
          expect(relationModelContent, contains('ArtistRelation toEntity()'));
          expect(artistModelContent, contains('fromJson'));
          expect(artistModelContent, contains('toJson'));
        },
      );

      test(
        'Artist and ArtistRelation entities should not contain serialization logic',
        () {
          final artistEntityFile = File(
            'lib/features/musicbrainz/domain/entities/artist.dart',
          );
          expect(artistEntityFile.existsSync(), isTrue);

          final content = artistEntityFile.readAsStringSync();

          // Entities should remain pure and not know about JSON formats
          expect(content, isNot(contains('fromJson')));
          expect(content, isNot(contains('toJson')));
        },
      );
    });
  });
}
