import '../models/specification.dart';

class SpecificationDto {
  const SpecificationDto({
    required this.id,
    required this.width,
    required this.height,
    required this.depth,
    required this.material,
    required this.name,
    required this.isRechargeable,
  });

  final int id;
  final int width;
  final int height;
  final int depth;
  final String material;
  final String name;
  final bool isRechargeable;

  factory SpecificationDto.fromJson(Map<String, dynamic> json) {
    return SpecificationDto(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      depth: json['depth'] as int,
      material: json['material'] as String,
      name: json['name'] as String,
      isRechargeable:
          (json['isRechargeable'] ?? json['is_rechargeable']) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'depth': depth,
      'material': material,
      'name': name,
      'isRechargeable': isRechargeable,
    };
  }

  Specification toDomain() {
    return Specification(
      id: id,
      width: width,
      height: height,
      depth: depth,
      material: material,
      name: name,
      isRechargeable: isRechargeable,
    );
  }

  factory SpecificationDto.fromDomain(Specification specification) {
    return SpecificationDto(
      id: specification.id,
      width: specification.width,
      height: specification.height,
      depth: specification.depth,
      material: specification.material,
      name: specification.name,
      isRechargeable: specification.isRechargeable,
    );
  }
}
