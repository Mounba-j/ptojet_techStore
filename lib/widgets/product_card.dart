import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/formatters.dart';

/// Widget réutilisable affichant une carte produit
/// 
/// Affiche :
/// - Image du produit
/// - Titre du produit
/// - Prix en gros
/// - Bouton rapide "Ajouter au panier"
/// - Sur clic : navigation vers la page de détails
class ProductCard extends StatelessWidget {
  /// Le produit à afficher dans la carte
  final Product product;

  /// Callback déclenché quand on clique sur le bouton "Ajouter au panier"
  /// 
  /// Paramètre : Le produit à ajouter
  final Function(Product) onAddToCart;

  /// Callback déclenché quand on clique sur la carte
  /// pour voir les détails du produit
  /// 
  /// Paramètre : Le produit sélectionné
  final Function(Product) onProductTap;

  /// Constructeur de la carte produit
  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Quand on clique sur la carte → Afficher les détails
      onTap: () => onProductTap(product),
      // Carte avec ombre et espacement
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== IMAGE DU PRODUIT =====
            // Image sur fond gris si le chargement échoue
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              // Utiliser un AspectRatio pour garder un rendu cohérent
              // des images dans toutes les cartes
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    // En cas d'erreur de chargement, afficher une icône
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // ===== CONTENU TEXTE =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre du produit (limité à 2 lignes)
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Prix (formaté en XOF)
                    Text(
                      formatCurrency(product.price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Spacer(),
                    // Bouton "Ajouter au panier"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => onAddToCart(product),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
