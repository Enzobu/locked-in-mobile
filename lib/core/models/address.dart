class Address {
  const Address({
    required this.id,
    required this.city,
    required this.country,
    required this.street,
    this.number,
    this.complement,
  });

  final int id;
  final String? number;
  final String city;
  final String country;
  final String street;
  final String? complement;

  Address copyWith({
    int? id,
    String? Function()? number,
    String? city,
    String? country,
    String? street,
    String? Function()? complement,
  }) {
    return Address(
      id: id ?? this.id,
      number: number != null ? number() : this.number,
      city: city ?? this.city,
      country: country ?? this.country,
      street: street ?? this.street,
      complement: complement != null ? complement() : this.complement,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.id == id &&
        other.number == number &&
        other.city == city &&
        other.country == country &&
        other.street == street &&
        other.complement == complement;
  }

  @override
  int get hashCode => Object.hash(id, number, city, country, street, complement);

  @override
  String toString() {
    return 'Address(id: $id, number: $number, city: $city, country: $country, street: $street, complement: $complement)';
  }
}
