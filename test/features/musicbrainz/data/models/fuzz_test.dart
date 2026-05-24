import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/musicbrainz/data/models/mb_artist_model.dart';
import 'package:sonic_nomad/features/musicbrainz/data/models/mb_relation_model.dart';

void main() {
  group('MBArtistModel Parsing Robustness (Fuzz Test)', () {
    final random = Random(42); // Seeded random for reproducible tests

    // Helper to generate a random alphanumeric string with potential special/Unicode characters
    String randomString(int length) {
      const chars =
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+=-[]{}|;:,.<>?/\\~` 🌟日本語';
      return List.generate(
        length,
        (index) => chars[random.nextInt(chars.length)],
      ).join();
    }

    test('Should handle malformed or highly corrupted JSON payloads safely', () {
      for (int i = 0; i < 500; i++) {
        // Build a randomized fuzzed JSON payload
        final Map<String, dynamic> fuzzedJson = {
          'id': random.nextBool()
              ? (random.nextBool() ? randomString(20) : '')
              : null,
          'name': random.nextBool() ? randomString(30) : null,
          'sort-name': random.nextBool() ? randomString(30) : null,
          'type': random.nextBool()
              ? (random.nextBool() ? randomString(10) : 12345)
              : null, // wrong type test
          'disambiguation': random.nextBool() ? randomString(50) : null,
          'country': random.nextBool() ? randomString(2) : null,
          'score': random.nextBool()
              ? (random.nextBool() ? random.nextInt(100) : 'high-score')
              : null, // wrong type test
          'relations': random.nextBool()
              ? [
                  if (random.nextBool())
                    {
                      'artist': random.nextBool()
                          ? {
                              'id': randomString(20),
                              'name': randomString(30),
                              'sort-name': randomString(30),
                            }
                          : null,
                      'type': random.nextBool() ? randomString(15) : null,
                      'direction': random.nextBool() ? 'forward' : 'backward',
                      'target-type': random.nextBool() ? 'artist' : null,
                    }
                  else
                    'corrupted-relation-element',
                ]
              : null,
        };

        try {
          // Attempt parsing
          final model = MBArtistModel.fromJson(fuzzedJson);

          // If parsing succeeded, verify properties are correctly assigned
          expect(model.id, isA<String>());
          expect(model.name, isA<String>());
          expect(model.sortName, isA<String>());
        } catch (e) {
          // Normal validation errors, type errors, or cast errors are expected when required keys are missing or typed incorrectly.
          // The critical aspect is that parsing throws a standard, catchable error rather than causing a crash.
          expect(e, anyOf(isA<TypeError>(), isA<NoSuchMethodError>()));
        }
      }
    });

    test(
      'Should parse a perfectly valid model, serialize/deserialize without data loss',
      () {
        final validJson = {
          'id': 'artist-123',
          'name': 'The Nomad',
          'sort-name': 'Nomad, The',
          'type': 'Group',
          'disambiguation': 'Alternative Rock Band',
          'country': 'US',
          'score': 100,
          'relations': [
            {
              'type': 'member of',
              'direction': 'forward',
              'target-type': 'artist',
              'artist': {
                'id': 'artist-456',
                'name': 'Sub Nomad',
                'sort-name': 'Nomad, Sub',
              },
            },
          ],
        };

        final model = MBArtistModel.fromJson(validJson);
        expect(model.id, 'artist-123');
        expect(model.name, 'The Nomad');
        expect(model.relations?.length, 1);
        expect(model.relations?.first.artist.name, 'Sub Nomad');

        final serialized = model.toJson();
        expect(serialized['id'], 'artist-123');
        expect(serialized['relations']?.first['artist']['name'], 'Sub Nomad');

        final entity = model.toEntity();
        expect(entity.id, 'artist-123');
        expect(entity.relations?.first.artist.name, 'Sub Nomad');
      },
    );
  });
}
