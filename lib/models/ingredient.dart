class Ingredient {
  final String name;
  final int harmfulnessFactor;
  final String? quantity;
  final String? comments;
  final String? healtheirAlternatives;
  final List<String>? allergies;

  Ingredient({
    required this.name,
    required this.harmfulnessFactor,
    this.quantity,
    this.comments,
    this.healtheirAlternatives,
    this.allergies,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      harmfulnessFactor: json['harmfulness_factor'],
      quantity: json['quantity'],
      comments: json['comments'],
      healtheirAlternatives: json['healthier_alternative'],
      allergies: json['potential_allergies'] != null
          ? List<String>.from(json['potential_allergies'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'harmfulness_factor': harmfulnessFactor,
      'quantity': quantity,
      'comments': comments,
      'healtheir_alternatives': healtheirAlternatives,
      'potential_allergies': allergies?.map((i) => i).toList(),
    };
  }
}
