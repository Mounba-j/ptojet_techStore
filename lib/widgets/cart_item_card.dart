import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/formatters.dart';

/// Widget affichant une ligne d'article dans le panier
/// 
/// Affiche pour chaque article :
/// - Image du produit (petite)
/// - Nom et prix unitaire
/// - Quantité avec boutons +/-
/// - Sous-total
/// - Bouton de suppression
class CartItemCard extends StatelessWidget {
  /// L'article du panier à afficher
  final CartItem cartItem;

  /// Callback quand on clique sur le bouton "+" pour augmenter la quantité
  final VoidCallback onIncreaseQuantity;

  /// Callback quand on clique sur le bouton "-" pour diminuer la quantité
  final VoidCallback onDecreaseQuantity;

  /// Callback quand on clique sur le bouton "Supprimer"
  final VoidCallback onRemove;

  /// Constructeur de la carte article panier
  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // L'article du panier contient le produit et la quantité
    final product = cartItem.product;
    final subtotal = cartItem.getSubtotal();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ===== IMAGE PRODUIT (PETITE) =====
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ===== INFORMATIONS PRODUIT =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du produit
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Prix unitaire
                  Text(
                    formatCurrency(product.price),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Sélecteur de quantité avec boutons +/-
                  Row(
                    children: [
                      // Bouton "-" pour diminuer
                      GestureDetector(
                        onTap: onDecreaseQuantity,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Affichage de la quantité
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      // Bouton "+" pour augmenter
                      GestureDetector(
                        onTap: onIncreaseQuantity,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ===== SOUS-TOTAL ET SUPPRIMER =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Sous-total (Prix × Quantité)
                Text(
                  formatCurrency(subtotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Bouton de suppression
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[400],
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
