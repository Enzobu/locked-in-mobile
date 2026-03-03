import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/specification_dto.dart';

void main() {
  const json = {
    'id': 1,
    'name': 'Small',
    'width': 30,
    'height': 40,
    'depth': 50,
    'material': 'Acier',
    'is_rechargeable': true,
  };

  group('SpecificationDto', () {
    test('fromJson creates correct DTO', () {
      final dto = SpecificationDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'Small');
      expect(dto.width, 30);
      expect(dto.height, 40);
      expect(dto.depth, 50);
      expect(dto.material, 'Acier');
      expect(dto.isRechargeable, true);
    });

    test('toJson produces correct map', () {
      final dto = SpecificationDto.fromJson(json);
      final result = dto.toJson();

      expect(result, json);
    });

    test('round-trip serialization preserves data', () {
      final dto = SpecificationDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = SpecificationDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.width, dto.width);
      expect(restored.height, dto.height);
      expect(restored.depth, dto.depth);
      expect(restored.material, dto.material);
      expect(restored.isRechargeable, dto.isRechargeable);
    });

    test('toDomain creates correct domain model', () {
      final dto = SpecificationDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.name, dto.name);
      expect(domain.isRechargeable, dto.isRechargeable);
    });

    test('fromDomain creates correct DTO', () {
      final dto = SpecificationDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = SpecificationDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.material, dto.material);
    });
  });
}
