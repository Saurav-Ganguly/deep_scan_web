import 'package:deep_scan_web/models/ingredient.dart';
import 'package:deep_scan_web/models/nutrients.dart';

class Product {
  final String id;
  final String name;
  final String type;
  final int harmfulnessPercentage;
  final int ecologicalHarmfulnessPercentage;
  String? typeIcon;
  String? company;
  String? countryFlag;
  String? country;
  List<Ingredient>? ingredients;
  List<Nutrient>? nutrients;
  String? harmfulnessPercentageExplanation;
  String? ecologicalHarmfullnessPercentageExplanation;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.harmfulnessPercentage,
    required this.ecologicalHarmfulnessPercentage,
    this.typeIcon,
    this.company,
    this.countryFlag,
    this.country,
    this.ingredients,
    this.nutrients,
    this.harmfulnessPercentageExplanation,
    this.ecologicalHarmfullnessPercentageExplanation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      company: json['company'],
      name: json['product_name'],
      type: json['product_type'],
      typeIcon: json['product_type_icon'],
      country: json['country_of_manufacture'],
      countryFlag: json['country_flag'],
      harmfulnessPercentage: json['harmfulness_percentage'],
      ecologicalHarmfulnessPercentage:
          json['ecological_harmfulness_percentage'],
      harmfulnessPercentageExplanation:
          json['harmfulness_percentage_explanation'],
      ecologicalHarmfullnessPercentageExplanation:
          json['ecological_harmfullness_percentage_explanation'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      nutrients: json['nutrients'] != null
          ? (json['nutrients'] as List)
              .map((i) => Nutrient.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': name,
      'product_type': type,
      'harmfulness_percentage': harmfulnessPercentage,
      'ecological_harmfulness_percentage': ecologicalHarmfulnessPercentage,
      'product_type_icon': typeIcon,
      'company': company,
      'country_flag': countryFlag,
      'country_of_manufacture': country,
      'harmfulness_percentage_explanation': harmfulnessPercentageExplanation,
      'ecological_harmfullness_percentage_explanation':
          ecologicalHarmfullnessPercentageExplanation,
      'ingredients': ingredients?.map((i) => i.toJson()).toList(),
      'nutrients': nutrients?.map((n) => n.toJson()).toList(),
    };
  }
}
