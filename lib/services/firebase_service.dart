import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_scan_web/models/product.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> streamAllProducts() {
    print("Streaming all products");
    return _firestore.collection('products').snapshots().map((snapshot) {
      print("Received snapshot with ${snapshot.docs.length} documents");
      return snapshot.docs
          .map((doc) {
            print("Processing document: ${doc.id}");
            try {
              return Product.fromJson(doc.data() as Map<String, dynamic>);
            } catch (e) {
              print("Error processing document ${doc.id}: $e");
              return null;
            }
          })
          .where((product) => product != null)
          .cast<Product>()
          .toList();
    });
  }

  Stream<List<Product>> streamProductsByType(String type) {
    print("Streaming products of type: $type");
    return _firestore
        .collection('products')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) {
      print("Received snapshot with ${snapshot.docs.length} documents");
      return snapshot.docs
          .map((doc) {
            print("Processing document: ${doc.id}");
            try {
              return Product.fromJson(doc.data() as Map<String, dynamic>);
            } catch (e) {
              print("Error processing document ${doc.id}: $e");
              return null;
            }
          })
          .where((product) => product != null)
          .cast<Product>()
          .toList();
    });
  }
}
