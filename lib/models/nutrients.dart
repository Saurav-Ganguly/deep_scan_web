class Nutrient {
  final String? name;
  final String? perServingValue;
  Nutrient({
    required this.name,
    required this.perServingValue,
  });
  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
        name: json['name'], perServingValue: json['perServingValue']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'perServingValue': perServingValue};
  }
}
