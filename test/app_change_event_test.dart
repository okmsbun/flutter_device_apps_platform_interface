import 'package:flutter_device_apps_platform_interface/flutter_device_apps_app_change_event.dart';
import 'package:test/test.dart';

void main() {
  group('AppChangeType', () {
    test('has all expected values', () {
      expect(AppChangeType.values, hasLength(3));
      expect(AppChangeType.values, contains(AppChangeType.installed));
      expect(AppChangeType.values, contains(AppChangeType.removed));
      expect(AppChangeType.values, contains(AppChangeType.updated));
    });

    test('enum names match expected strings', () {
      expect(AppChangeType.installed.name, 'installed');
      expect(AppChangeType.removed.name, 'removed');
      expect(AppChangeType.updated.name, 'updated');
    });
  });

  group('AppChangeEvent', () {
    group('constructor', () {
      test('creates instance with all null values', () {
        const event = AppChangeEvent();

        expect(event.packageName, isNull);
        expect(event.type, isNull);
        expect(event.isReplacing, isNull);
      });

      test('creates instance with all values', () {
        const event = AppChangeEvent(
          packageName: 'com.example.app',
          type: AppChangeType.installed,
          isReplacing: false,
        );

        expect(event.packageName, 'com.example.app');
        expect(event.type, AppChangeType.installed);
        expect(event.isReplacing, false);
      });

      test('creates instance with partial values', () {
        const event = AppChangeEvent(
          packageName: 'com.example.app',
        );

        expect(event.packageName, 'com.example.app');
        expect(event.type, isNull);
        expect(event.isReplacing, isNull);
      });
    });

    group('fromMap', () {
      test('parses empty map', () {
        final event = AppChangeEvent.fromMap({});

        expect(event.packageName, isNull);
        expect(event.type, isNull);
        expect(event.isReplacing, isNull);
      });

      test('parses packageName correctly', () {
        final event = AppChangeEvent.fromMap({
          'packageName': 'com.test.app',
        });

        expect(event.packageName, 'com.test.app');
      });

      test('parses type "installed" correctly', () {
        final event = AppChangeEvent.fromMap({
          'type': 'installed',
        });

        expect(event.type, AppChangeType.installed);
      });

      test('parses type "removed" correctly', () {
        final event = AppChangeEvent.fromMap({
          'type': 'removed',
        });

        expect(event.type, AppChangeType.removed);
      });

      test('parses type "updated" correctly', () {
        final event = AppChangeEvent.fromMap({
          'type': 'updated',
        });

        expect(event.type, AppChangeType.updated);
      });

      test('returns null type for invalid type string', () {
        final event = AppChangeEvent.fromMap({
          'type': 'unknown',
        });

        expect(event.type, isNull);
      });

      test('returns null type for empty type string', () {
        final event = AppChangeEvent.fromMap({
          'type': '',
        });

        expect(event.type, isNull);
      });

      test('parses isReplacing from bool value', () {
        final eventTrue = AppChangeEvent.fromMap({
          'isReplacing': true,
        });
        final eventFalse = AppChangeEvent.fromMap({
          'isReplacing': false,
        });

        expect(eventTrue.isReplacing, true);
        expect(eventFalse.isReplacing, false);
      });

      test('parses isReplacing from string value', () {
        final eventTrue = AppChangeEvent.fromMap({
          'isReplacing': 'true',
        });
        final eventFalse = AppChangeEvent.fromMap({
          'isReplacing': 'false',
        });

        expect(eventTrue.isReplacing, true);
        expect(eventFalse.isReplacing, false);
      });

      test('returns null isReplacing for invalid string', () {
        final event = AppChangeEvent.fromMap({
          'isReplacing': 'yes',
        });

        expect(event.isReplacing, isNull);
      });

      test('parses complete map with all fields', () {
        final event = AppChangeEvent.fromMap({
          'packageName': 'com.example.fullapp',
          'type': 'updated',
          'isReplacing': true,
        });

        expect(event.packageName, 'com.example.fullapp');
        expect(event.type, AppChangeType.updated);
        expect(event.isReplacing, true);
      });
    });

    group('toMap', () {
      test('converts empty event to map', () {
        const event = AppChangeEvent();
        final Map<String, Object?> map = event.toMap();

        expect(map['packageName'], isNull);
        expect(map['type'], isNull);
        expect(map['isReplacing'], isNull);
      });

      test('converts full event to map', () {
        const event = AppChangeEvent(
          packageName: 'com.example.app',
          type: AppChangeType.installed,
          isReplacing: false,
        );
        final Map<String, Object?> map = event.toMap();

        expect(map['packageName'], 'com.example.app');
        expect(map['type'], 'installed');
        expect(map['isReplacing'], false);
      });

      test('converts removed type correctly', () {
        const event = AppChangeEvent(type: AppChangeType.removed);
        final Map<String, Object?> map = event.toMap();

        expect(map['type'], 'removed');
      });

      test('converts updated type correctly', () {
        const event = AppChangeEvent(type: AppChangeType.updated);
        final Map<String, Object?> map = event.toMap();

        expect(map['type'], 'updated');
      });

      test('converts partial event to map', () {
        const event = AppChangeEvent(
          packageName: 'com.partial.app',
          isReplacing: true,
        );
        final Map<String, Object?> map = event.toMap();

        expect(map['packageName'], 'com.partial.app');
        expect(map['type'], isNull);
        expect(map['isReplacing'], true);
      });
    });

    group('round-trip (fromMap -> toMap)', () {
      test('installed event survives round-trip', () {
        final originalMap = <String, Object?>{
          'packageName': 'com.roundtrip.installed',
          'type': 'installed',
          'isReplacing': false,
        };

        final event = AppChangeEvent.fromMap(originalMap);
        final Map<String, Object?> resultMap = event.toMap();

        expect(resultMap['packageName'], originalMap['packageName']);
        expect(resultMap['type'], originalMap['type']);
        expect(resultMap['isReplacing'], originalMap['isReplacing']);
      });

      test('removed event survives round-trip', () {
        final originalMap = <String, Object?>{
          'packageName': 'com.roundtrip.removed',
          'type': 'removed',
          'isReplacing': false,
        };

        final event = AppChangeEvent.fromMap(originalMap);
        final Map<String, Object?> resultMap = event.toMap();

        expect(resultMap['packageName'], originalMap['packageName']);
        expect(resultMap['type'], originalMap['type']);
        expect(resultMap['isReplacing'], originalMap['isReplacing']);
      });

      test('updated event with replacing survives round-trip', () {
        final originalMap = <String, Object?>{
          'packageName': 'com.roundtrip.updated',
          'type': 'updated',
          'isReplacing': true,
        };

        final event = AppChangeEvent.fromMap(originalMap);
        final Map<String, Object?> resultMap = event.toMap();

        expect(resultMap['packageName'], originalMap['packageName']);
        expect(resultMap['type'], originalMap['type']);
        expect(resultMap['isReplacing'], originalMap['isReplacing']);
      });

      test('empty event survives round-trip', () {
        final originalMap = <String, Object?>{};

        final event = AppChangeEvent.fromMap(originalMap);
        final Map<String, Object?> resultMap = event.toMap();

        expect(resultMap['packageName'], isNull);
        expect(resultMap['type'], isNull);
        expect(resultMap['isReplacing'], isNull);
      });
    });
  });
}
