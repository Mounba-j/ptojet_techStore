import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_card.dart';
import '../utils/formatters.dart';

/// Écran du panier - Gestion des articles sélectionnés
/// 
/// Fonctionnalités :
/// - Afficher tous les articles du panier
/// - Modifier les quantités (+ et -)
/// - Supprimer des articles
/// - Afficher le total général
/// - Bouton de validation d'achat
class CartScreen extends StatefulWidget {
  /// Identifiant unique du screen dans la navigation
  static const routeName = '/cart';

  /// Liste des articles actuellement dans le panier
  final List<CartItem> cartItems;

  /// Callback quand on augmente la quantité d'un article
  /// Paramètre : L'ID du produit
  final Function(int) onIncreaseQuantity;

  /// Callback quand on diminue la quantité d'un article
  /// Paramètre : L'ID du produit
  final Function(int) onDecreaseQuantity;

  /// Callback quand on supprime un article du panier
  /// Paramètre : L'ID du produit
  final Function(int) onRemoveItem;

  /// Callback quand on valide l'achat
  final VoidCallback onCheckout;

  /// Callback pour retourner à l'accueil
  final VoidCallback onNavigateHome;

  /// Constructeur de l'écran panier
  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemoveItem,
    required this.onCheckout,
    required this.onNavigateHome,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Calcule le total général du panier
  /// Somme de tous les sous-totaux
  double _calculateTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += item.getSubtotal();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;
    final total = _calculateTotal();
    final isEmpty = cartItems.isEmpty;

    return Scaffold(
      // ===== EN-TÊTE =====
      appBar: AppBar(
        title: const Text('Mon Panier'),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onNavigateHome,
        ),
      ),
      // ===== CORPS PRINCIPAL =====
      body: isEmpty
          // Si le panier est vide
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône panier vide
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  // Message
                  Text(
                    'Votre panier est vide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez à faire vos achats !',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bouton "Continuer mes achats"
                  ElevatedButton.icon(
                    onPressed: widget.onNavigateHome,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    icon: const Icon(Icons.shopping_bag, color: Colors.white),
                    label: const Text(
                      'Continuer mes achats',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          // Si le panier contient des articles
          : Column(
              children: [
                // ===== LISTE DES ARTICLES =====
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final product = cartItem.product;

                        return CartItemCard(
                          cartItem: cartItem,
                          // Augmenter la quantité
                          onIncreaseQuantity: () {
                            widget.onIncreaseQuantity(product.id);
                            setState(() {});
                          },
                          // Diminuer la quantité
                          onDecreaseQuantity: () {
                            widget.onDecreaseQuantity(product.id);
                            setState(() {});
                          },
                          // Supprimer l'article
                          onRemove: () {
                            widget.onRemoveItem(product.id);
                            setState(() {});
                            // Confirmation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} supprimé du panier',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.orange,
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // ===== PIED DE PAGE : TOTAL ET BOUTONS =====
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Affichage du total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total général :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatCurrency(total),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Boutons d'action
                      Row(
                        children: [
                          // Bouton "Continuer mes achats"
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onNavigateHome,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              child: const Text(
                                'Continuer mes achats',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Bouton "Valider l'achat"
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Afficher un message de confirmation
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Confirmer l\'achat',
                                    ),
                                    content: Text(
                                      'Total : ${formatCurrency(total)}\n\n'
                                      'Êtes-vous sûr de vouloir valider cet achat ?',
                                    ),
                                    actions: [
                                      // Bouton "Annuler"
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Annuler'),
                                      ),
                                      // Bouton "Confirmer"
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          widget.onCheckout();
                                          // Message de succès
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Commande validée avec succès ! 🎉',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: const Duration(
                                                milliseconds: 2000,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Confirmer'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColor,
                              ),
                              child: const Text(
                                'Valider',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
