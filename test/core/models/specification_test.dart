import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/specification.dart';

void main() {
  const spec = Specification(
    id: 1,
    width: 40,
    height: 60,
    depth: 30,
    material: 'steel',
    name: 'Medium',
    isRechargeable: true,
  );

  group('Specification', () {
    test('constructor sets all fields correctly', () {
      expect(spec.id, 1);
      expect(spec.width, 40);
      expect(spec.height, 60);
      expect(spec.depth, 30);
      expect(spec.material, 'steel');
      expect(spec.name, 'Medium');
      expect(spec.isRechargeable, true);
    });

    test('isRechargeable defaults to false', () {
      const defaultSpec = Specification(
        id: 2,
        width: 20,
        height: 30,
        depth: 20,
        material: 'plastic',
        name: 'Small',
      );
      expect(defaultSpec.isRechargeable, false);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = spec.copyWith(name: 'Large', width: 80);
      expect(updated.name, 'Large');
      expect(updated.width, 80);
      expect(updated.height, spec.height);
    });

    test('equality works correctly', () {
      const same = Specification(
        id: 1,
        width: 40,
        height: 60,
        depth: 30,
        material: 'steel',
        name: 'Medium',
        isRechargeable: true,
      );
      expect(spec, equals(same));
      expect(spec.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = spec.copyWith(name: 'Large');
      expect(spec, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = spec.toString();
      expect(str, contains('Specification'));
      expect(str, contains('Medium'));
      expect(str, contains('steel'));
    });
  });
}
