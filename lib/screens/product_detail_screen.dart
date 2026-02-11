import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/formatters.dart';

/// Écran affichant les détails complets d'un produit
/// 
/// Fonctionnalités :
/// - Image en grand format
/// - Titre et description complète
/// - Prix en évidence
/// - Bouton "Ajouter au panier"
/// - Navigation retour
class ProductDetailScreen extends StatefulWidget {
  /// Identifiant unique du screen dans la navigation
  static const routeName = '/product-detail';

  /// Le produit dont afficher les détails
  final Product product;

  /// Callback quand on ajoute le produit au panier
  final Function(Product) onAddToCart;

  /// Callback pour retourner à l'accueil
  final VoidCallback onBack;

  /// Constructeur de l'écran de détails
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBack,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /// Quantité du produit que l'utilisateur veut ajouter
  /// (actuellement fixée à 1, mais extensible pour le futur)
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      // ===== EN-TÊTE =====
      appBar: AppBar(
        title: const Text('Détails du produit'),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      // ===== CORPS PRINCIPAL =====
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== IMAGE DU PRODUIT EN GRAND =====
            // Prend toute la largeur, hauteur fixe de 300
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
            // ===== CONTENU TEXTE =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du produit
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Affichage du prix en gros et bien visible
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatCurrency(product.price),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Titre "Description"
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description complète du produit
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5, // Espacement entre les lignes
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sélecteur de quantité (optionnel pour futur)
                  Row(
                    children: [
                      const Text(
                        'Quantité :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Bouton "-"
                      GestureDetector(
                        onTap: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: quantity > 1
                                  ? Colors.grey
                                  : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: quantity > 1 ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Affichage quantité
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Bouton "+"
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ===== BOUTON FLOTTANT "AJOUTER AU PANIER" =====
      floatingActionButton: SizedBox(
        width: double.infinity,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Ajouter le produit au panier
              widget.onAddToCart(widget.product);
              // Afficher confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.title} ajouté au panier ! (Quantité: $quantity)',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(milliseconds: 1500),
                ),
              );
              // Retour à l'accueil après 1 seconde
              Future.delayed(
                const Duration(milliseconds: 500),
                () {
                  widget.onBack();
                },
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.shopping_cart),
            label: const Text(
              'Ajouter au panier',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
