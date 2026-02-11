import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/formatters.dart';

/// Widget affichant un carrousel horizontal de produits "À la une"
/// 
/// Fonctionnalités :
/// - Défilement continu automatique fluide
/// - Chaque produit est cliquable
/// - Animation fluide et pause au survol
/// - Affiche image, titre et prix
/// - Boucle infinie du carrousel
class ProductCarousel extends StatefulWidget {
  /// Liste des produits à afficher dans le carrousel
  final List<Product> products;

  /// Callback quand on clique sur un produit du carrousel
  final Function(Product) onProductTap;

  /// Constructeur du carrousel
  const ProductCarousel({
    Key? key,
    required this.products,
    required this.onProductTap,
  }) : super(key: key);

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel>
    with TickerProviderStateMixin {
  /// Contrôleur pour gérer le scroll
  late ScrollController _scrollController;

  /// Animation controller pour le défilement continu
  late AnimationController _animationController;

  /// Hauteur d'une carte
  static const double cardWidth = 200.0;
  static const double cardSpacing = 16.0;
  static const double padding = 16.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    // Écouter les changements d'animation
    _animationController.addListener(_onAnimationTick);

    // Démarrer l'animation après un délai pour laisser le widget se construire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  /// Callback pour chaque frame de l'animation
  void _onAnimationTick() {
    if (!_scrollController.hasClients) return;

    try {
      final position = _scrollController.position;
      final maxScroll = position.maxScrollExtent;

      // Si maxScroll est 0 ou négatif, le widget n'est pas encore totalement construit
      if (maxScroll <= 0) return;

      final scrollAmount = _animationController.value * maxScroll;

      // S'assurer que scrollAmount est dans les limites valides
      final clampedAmount = scrollAmount.clamp(0.0, maxScroll);

      // Vérifier si on a atteint la fin
      if (clampedAmount >= maxScroll * 0.99) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(clampedAmount);
      }
    } catch (e) {
      // Ignorer les erreurs pendant le scroll si le widget est en cours de construction
      print('Erreur dans animation scroll: $e');
    }
  }

  /// Démarre le défilement automatique continu
  void _startAutoScroll() {
    _animationController.repeat();
  }

  /// Pause le défilement
  void _pauseScroll() {
    _animationController.stop();
  }

  /// Reprend le défilement
  void _resumeScroll() {
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'À la une 🌟',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        // Carrousel défilant en continu
        SizedBox(
          height: 220,
          child: MouseRegion(
            onEnter: (_) => _pauseScroll(),
            onExit: (_) => _resumeScroll(),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: padding),
              // Dupliquer les produits pour l'effet de boucle infinie
              itemCount: widget.products.length * 2,
              itemBuilder: (context, index) {
                final product = widget.products[index % widget.products.length];
                return Padding(
                  padding: const EdgeInsets.only(right: cardSpacing),
                  child: GestureDetector(
                    onTap: () {
                      _pauseScroll();
                      widget.onProductTap(product);
                      // Reprendre après 500ms
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          _resumeScroll();
                        }
                      });
                    },
                    child: SizedBox(
                      width: cardWidth,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image du produit
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 140,
                                color: Colors.grey[200],
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
                            // Titre et prix
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCurrency(product.price),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
