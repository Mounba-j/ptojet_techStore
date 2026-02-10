import 'product.dart';

/// Modèle représentant un article dans le panier
/// 
/// CartItem encapsule :
/// - Un produit (référence au produit acheté)
/// - La quantité commandée
class CartItem {
  /// Le produit contenu dans le panier
  final Product product;

  /// La quantité du produit dans le panier
  int quantity;

  /// Constructeur du modèle CartItem
  /// 
  /// [product] : Le produit à ajouter au panier
  /// [quantity] : La quantité (par défaut 1)
  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Calcule le sous-total pour cet article du panier
  /// 
  /// Formule : Prix unitaire × Quantité
  /// 
  /// Retourne : Le sous-total en tant que nombre à virgule
  double getSubtotal() {
    return product.price * quantity;
  }

  /// Augmente la quantité de 1
  /// 
  /// Généralement appelé quand l'utilisateur clique sur le bouton "+"
  void increaseQuantity() {
    quantity++;
  }

  /// Diminue la quantité de 1
  /// 
  /// Ne diminue pas en-dessous de 1 (un article supprimé
  /// doit être retiré du panier, pas réduit à 0)
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  /// Réinitialise la quantité à 1
  /// 
  /// Utile après certaines opérations ou réinitialisations
  void resetQuantity() {
    quantity = 1;
  }

  @override
  String toString() {
    return 'CartItem(product: ${product.title}, quantity: $quantity, subtotal: ${getSubtotal()})';
  }
}
