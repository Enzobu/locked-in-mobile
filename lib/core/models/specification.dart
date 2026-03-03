class Specification {
  const Specification({
    required this.id,
    required this.width,
    required this.height,
    required this.depth,
    required this.material,
    required this.name,
    this.isRechargeable = false,
  });

  final int id;
  final int width;
  final int height;
  final int depth;
  final String material;
  final String name;
  final bool isRechargeable;

  Specification copyWith({
    int? id,
    int? width,
    int? height,
    int? depth,
    String? material,
    String? name,
    bool? isRechargeable,
  }) {
    return Specification(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      material: material ?? this.material,
      name: name ?? this.name,
      isRechargeable: isRechargeable ?? this.isRechargeable,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Specification &&
        other.id == id &&
        other.width == width &&
        other.height == height &&
        other.depth == depth &&
        other.material == material &&
        other.name == name &&
        other.isRechargeable == isRechargeable;
  }

  @override
  int get hashCode =>
      Object.hash(id, width, height, depth, material, name, isRechargeable);

  @override
  String toString() {
    return 'Specification(id: $id, name: $name, width: $width, height: $height, depth: $depth, material: $material, isRechargeable: $isRechargeable)';
  }
}
