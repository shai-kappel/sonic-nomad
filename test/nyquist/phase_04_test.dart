import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/core/metrics/graph_layout_engine.dart';

void main() {
  group('Phase 04 Nyquist Validation:', () {
    group('1. Wikidata API Client & Policy Compliance:', () {
      test(
        'wikidata_api.dart should exist and have rate limiting, User-Agent, and retry policies configured',
        () {
          final file = File(
            'lib/features/wikidata/data/datasources/wikidata_api.dart',
          );
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();

          // Assert SPARQL endpoint url
          expect(content, contains('https://query.wikidata.org/sparql'));

          // Assert client-side rate limiting configuration (min 1s interval)
          expect(
            content,
            contains('Duration(\n        seconds: 1,\n      )'),
          ); // matches format of Duration
          expect(content, contains('_waitForSlot('));
          expect(content, contains('_processQueue('));

          // Assert HTTP headers conform to policy
          expect(content, contains('User-Agent'));
          expect(
            content,
            contains('SonicNomad/1.0.0 ( contact@sonicnomad.app )'),
          );
          expect(content, contains('application/sparql-results+json'));
          expect(content, contains('application/x-www-form-urlencoded'));

          // Assert 429 retry policy (5s delay)
          expect(content, contains('response.statusCode == 429'));
          expect(content, contains('Duration(seconds: 5)'));
        },
      );
    });

    group('2. Clean Architecture Layer Separation:', () {
      test('Domain layers should not import Data layers (boundary enforcement)', () {
        final domainDir = Directory('lib/features/wikidata/domain');
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

      test('WikidataRepository should be abstract/interface in domain', () {
        final file = File(
          'lib/features/wikidata/domain/repositories/wikidata_repository.dart',
        );
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('abstract class WikidataRepository'));
      });

      test(
        'WikidataRepositoryImpl should exist in data layer and implement domain interface',
        () {
          final file = File(
            'lib/features/wikidata/data/repositories/wikidata_repository_impl.dart',
          );
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();
          expect(content, contains('implements WikidataRepository'));
          expect(content, contains('final WikidataApi'));
        },
      );
    });

    group('3. Data Models vs Domain Entities Boundary:', () {
      test('Genre entity should not contain serialization logic', () {
        final genreEntityFile = File(
          'lib/features/wikidata/domain/models/genre.dart',
        );
        expect(genreEntityFile.existsSync(), isTrue);

        final content = genreEntityFile.readAsStringSync();

        // Entities should remain pure and not know about JSON formats
        expect(content, isNot(contains('fromJson')));
        expect(content, isNot(contains('toJson')));
      });
    });

    group('4. Canvas Layout & Specialized Widgets Metric Enforcement:', () {
      test(
        'GenreNodeWidget should have standard 120x120px circular size metric',
        () {
          final file = File(
            'lib/features/canvas/presentation/widgets/genre_node_widget.dart',
          );
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();
          expect(content, contains('double size = 120.0'));
          expect(content, contains('double borderRadius = size / 2'));
        },
      );

      test(
        'GraphLayoutEngine should centralize node and radial geometry dimensions',
        () {
          // Enforce the specific radius and node dimensions
          expect(GraphLayoutEngine.artistRadius, equals(300.0));
          expect(GraphLayoutEngine.genreRadius, equals(450.0));
          expect(GraphLayoutEngine.artistWidth, equals(180.0));
          expect(GraphLayoutEngine.artistHeight, equals(90.0));
          expect(GraphLayoutEngine.genreSize, equals(120.0));

          // Enforce node size selection logic matches architecture
          expect(
            GraphLayoutEngine.getNodeSize('genre'),
            equals(const Size(120.0, 120.0)),
          );
          expect(
            GraphLayoutEngine.getNodeSize('artist'),
            equals(const Size(180.0, 90.0)),
          );
          expect(
            GraphLayoutEngine.getNodeSize(null),
            equals(const Size(180.0, 90.0)),
          );
        },
      );
    });
  });
}
