import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_carousel.dart';
import '../widgets/custom_drawer.dart';
import '../utils/constants.dart';
import '../providers/app_state.dart';

/// Écran d'accueil - Catalogue principal de TechStore
/// 
/// Affiche :
/// - En-tête avec titre et badge panier
/// - Carrousel des produits "À la une"
/// - Grille (GridView) des produits du catalogue
/// - Menu latéral (Drawer) pour navigation
class HomeScreen extends StatelessWidget {
  /// Identifiant unique du screen dans la navigation
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      // ===== EN-TÊTE (AppBar) =====
      appBar: AppBar(
        // Titre de l'application
        title: const Text(
          "Le Magazin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFFFFFFFF),
          ),
        ),
        // Couleur du fond de l'en-tête
        backgroundColor: Theme.of(context).primaryColor,
        // Couleur des icônes
        iconTheme: const IconThemeData(color: Color(0xffFFFFFF)),
        // Action : Icône panier avec badge
        actions: [
          Stack(
            children: [
              // Icône du panier
              Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => appState.navigateTo('CART'),
                  tooltip: 'Ouvrir le panier',
                ),
              ),
              // Badge affichant le nombre d'articles
              // Positionné en haut à droite de l'icône
              if (appState.cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${appState.cartItemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      // ===== CORPS PRINCIPAL =====
      body: SingleChildScrollView(
        // Le contenu est scrollable pour voir tous les produits
        child: Column(
          children: [
            // Section "À la une" - Carrousel des produits phares
            ProductCarousel(
              products: featuredProducts,
              onProductTap: (product) {
                appState.showProductDetail(product);
              },
            ),
            // Titre "Catalogue"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Text(
                    'Catalogue 📦',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  // Nombre de produits disponibles
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${appState.products.length} produits',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Grille de produits
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                // Important : désactiver le scroll du GridView
                // car il est à l'intérieur d'un SingleChildScrollView
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // 2 colonnes comme spécifié
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                // Nombre de produits à afficher
                itemCount: appState.products.length,
                // Constructeur de chaque carte produit
                itemBuilder: (context, index) {
                  final product = appState.products[index];
                  return ProductCard(
                    product: product,
                    // Au clic du bouton "Ajouter au panier"
                    onAddToCart: (product) {
                      appState.addToCart(product);
                      // Afficher une notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.title} ajouté au panier !',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(milliseconds: 1500),
                        ),
                      );
                    },
                    // Au clic sur la carte (voir détails)
                    onProductTap: (product) {
                      appState.showProductDetail(product);
                    },
                  );
                },
              ),
            ),
            // Espace en bas
            const SizedBox(height: 20),
          ],
        ),
      ),
      // ===== MENU LATÉRAL (Drawer) =====
      drawer: CustomDrawer(
        onHome: () {
          // Déjà sur la page d'accueil, le drawer se ferme automatiquement
          // Rien à faire
        },
        
        onCart: () => appState.navigateTo('CART'),
        onAdmin: () => appState.navigateTo('ADMIN'),
      ),
    );
  }
}
