/// Modèle représentant un produit du catalogue TechStore
/// 
/// Cette classe encapsule les informations d'un produit :
/// - Identifiant unique
/// - Titre et description
/// - Prix et image
class Product {
  /// Identifiant unique du produit
  final int id;

  /// Titre/nom du produit
  final String title;

  /// Description détaillée du produit
  final String description;

  /// Prix unitaire du produit en devise (exemple: 299.99€)
  final double price;

  /// URL web pointant vers l'image du produit
  final String imageUrl;

  /// Constructeur du modèle Product
  /// 
  /// Tous les paramètres sont obligatoires pour créer un produit valide
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  /// Crée une copie du produit avec certaines modifications optionnelles
  /// 
  /// Utile pour générer des variations d'un même produit
  /// sans modifier l'original
  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price)';
  }
}
