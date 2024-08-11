import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:deep_scan_web/models/product.dart';
import 'package:deep_scan_web/models/nutrients.dart';
import 'package:deep_scan_web/models/ingredient.dart';
import 'package:deep_scan_web/services/firebase_service.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProductListPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Deep Scan Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: _firebaseService.streamAllProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    List<Product> products = snapshot.data!;
                    products.sort((a, b) => b.harmfulnessPercentage
                        .compareTo(a.harmfulnessPercentage));

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            backgroundColor: _getColorForHarmfulness(
                                    product.harmfulnessPercentage)
                                .withOpacity(0.3),
                            title: Row(
                              children: [
                                if (product.typeIcon != null)
                                  Text(
                                    product.typeIcon!,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: _getColorForHarmfulness(
                                        product.harmfulnessPercentage,
                                      ).withOpacity(1),
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: _getColorForHarmfulness(
                                            product.harmfulnessPercentage,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${product.company ?? "N/A"} | ${product.type} | Made in: ${product.countryFlag} ${product.country ?? "N/A"}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 180,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildProgressRing(
                                    product.harmfulnessPercentage / 100,
                                    'Safety',
                                    _getColorForHarmfulness(
                                        product.harmfulnessPercentage),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildProgressRing(
                                    product.ecologicalHarmfulnessPercentage /
                                        100,
                                    'Eco',
                                    Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product
                                            .harmfulnessPercentageExplanation !=
                                        null)
                                      Text(
                                        'Ingredient Safety: ${product.harmfulnessPercentageExplanation}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    const SizedBox(height: 8),
                                    if (product
                                            .ecologicalHarmfullnessPercentageExplanation !=
                                        null)
                                      Text(
                                        'Eco Friendly: ${product.ecologicalHarmfullnessPercentageExplanation}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Ingredients:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildIngredientsList(context, product),
                                    if (product.nutrients != null &&
                                        product.nutrients!.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      const Text('Nutrients:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      ...product.nutrients!.map((nutrient) =>
                                          _buildNutrientRow(nutrient)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRing(double percentage, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 17.0,
          lineWidth: 4.0,
          percent: percentage,
          center: Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: Colors.grey[300]!,
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 8)),
      ],
    );
  }

  Widget _buildIngredientsList(BuildContext context, Product product) {
    if (product.ingredients == null || product.ingredients!.isEmpty) {
      return const Text('No ingredients information available',
          style: TextStyle(color: Colors.grey));
    }
    return SizedBox(
      height: 150, // Adjust this value as needed
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: product.ingredients!.length,
          itemBuilder: (context, index) {
            return _buildIngredientCard(product.ingredients![index]);
          },
        ),
      ),
    );
  }

  Widget _buildIngredientCard(Ingredient ingredient) {
    return Card(
      color: _getColorForIngredient(ingredient.harmfulnessFactor),
      margin: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 200, // Adjust this value as needed
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ingredient.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (ingredient.quantity != null)
              Text(
                'Quantity: ${ingredient.quantity}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            const SizedBox(height: 4),
            Text(
              'Harmfulness Factor (low to high): ${ingredient.harmfulnessFactor}/10',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            if (ingredient.comments != null) ...[
              const SizedBox(height: 4),
              Text(
                'Comments: ${ingredient.comments}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (ingredient.allergies != null &&
                ingredient.allergies!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Allergies: ${ingredient.allergies!.join(", ")}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColorForIngredient(int harmfulnessFactor) {
    if (harmfulnessFactor <= 2) {
      return Colors.green.shade700;
    } else if (harmfulnessFactor <= 4) {
      return Colors.orange.shade700;
    } else {
      return Colors.red.shade700;
    }
  }

  Color _getColorForHarmfulness(int harmfulness) {
    if (harmfulness >= 90) {
      return Colors.green;
    } else if (harmfulness >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildNutrientRow(Nutrient nutrient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nutrient.name ?? 'Unknown'),
          Text(nutrient.perServingValue ?? 'N/A'),
        ],
      ),
    );
  }
}
