import '../models/product.dart';

/// Fichier de constantes et données initiales de l'application TechStore
/// 
/// Contient :
/// - Les produits initials du catalogue
/// - Les constantes de l'application (couleurs, textes, etc.)

/// ============================================================================
/// PRODUITS INITIALS - Catalogue par défaut
/// ============================================================================

/// Liste statique des produits disponibles dans le catalogue
/// 
/// Cette liste est affichée à l'accueil et peut être enrichie
/// via l'écran d'administration
List<Product> productCatalog = [
  // Produit 1 : iPhone 15 Pro
  Product(
    id: 1,
    title: 'iPhone 15 Pro',
    description:
        'Le nouvel iPhone 15 Pro avec processeur A17 Pro, écran Dynamic Island amélioré et appareil photo révolutionnaire. Parfait pour la photographie professionnelle et le gaming haute performance.',
    price: 850000,
    imageUrl: 'lib/assets/images/iPhone_15_pro.jpg',
  ),

  // Produit 2 : Samsung Galaxy S24
  Product(
    id: 2,
    title: 'Samsung Galaxy S24',
    description:
        'Smartphone Android flagship avec écran AMOLED 120Hz, processeur Snapdragon 8 Gen 3 et batterie durable. Excellent pour les contenus vidéo et les jeux mobiles.',
    price: 899900,
    imageUrl: 'lib/assets/images/samsung_s24.webp',
  ),

  // Produit 3 : MacBook Pro 16"
  Product(
    id: 3,
    title: 'MacBook Pro 16 pouces',
    description:
        'Ordinateur portable Apple avec processeur M3 Max, 16GB de RAM et écran Retina ProMotion. Idéal pour le développement, le montage vidéo et la conception graphique.',
    price: 2409900,
    imageUrl: 'lib/assets/images/macbook_pro.webp',
  ),

  // Produit 4 : Sony WH-1000XM5
  Product(
    id: 4,
    title: 'Sony WH-1000XM5',
    description:
        'Casque audio premium avec réduction de bruit active leader du marché. Autonomie 30h, confort optimal et son cristallin pour musiciens et audiophiles.',
    price: 399099,
    imageUrl: 'lib/assets/images/sony_wh1000xm5.jpg',
  ),

  // Produit 5 : iPad Pro 12.9"
  Product(
    id: 5,
    title: 'iPad Pro 12.9 pouces',
    description:
        'Tablette Apple avec écran Liquid Retina XDR, processeur M2 et support du Apple Pencil. Parfaite pour la créativité, le dessin et la productivité professionnelle.',
    price: 799900,
    imageUrl: 'lib/assets/images/apple_ipad_pro.webp',
  ),

  // Produit 6 : DJI Air 3
  Product(
    id: 6,
    title: 'Drone DJI Air 3',
    description:
        'Drone haute gamme avec double caméra, temps de vol 46 minutes et portée 15km. Capture aérienne professionnelle et stabilité exceptionnelle dans tous les conditions.',
    price: 309950,
    imageUrl: 'lib/assets/images/dji_drone_air_3.jpg',
  ),
];

/// ============================================================================
/// PRODUITS À LA UNE - Carousel d'accueil
/// ============================================================================

/// Liste des produits affichés dans le carrousel "À la une" de l'accueil
/// 
/// Ces produits sont mis en avant pour attirer l'attention des clients
/// Ils sont sélectionnés parmi les meilleurs produits du catalogue
List<Product> featuredProducts = [
  productCatalog[0], // iPhone 15 Pro
  productCatalog[2], // MacBook Pro
  productCatalog[4], // iPad Pro
];

/// ============================================================================
/// CONSTANTES DE L'APPLICATION
/// ============================================================================

/// Titre principal de l'application
const String appTitle = 'Tech Store';

/// Texte du bouton "Ajouter au panier"
const String addToCartButtonText = 'Ajouter au panier';

/// Texte du bouton "Valider l'achat"
const String checkoutButtonText = 'Valider';

/// Texte du bouton "Continuer shopping"
const String continuShoppingText = 'Continuer mes achats';

/// Texte du menu Drawer pour accéder à l'accueil
const String homeMenuText = 'Accueil';

/// Texte du menu Drawer pour accéder au panier
const String cartMenuText = 'Panier';

/// Texte du menu Drawer pour accéder à l'admin
const String adminMenuText = 'Administration';

/// Message affiché quand le panier est vide
const String emptyCartMessage = 'Votre panier est vide. Commencez vos achats !';

/// Texte pour le total du panier
const String totalText = 'Total :';

/// Texte pour "Supprimer du panier"
const String removeFromCartText = 'Supprimer';

/// ============================================================================
/// CONSTANTES DE VALIDATION (Écran Admin)
/// ============================================================================

/// Message d'erreur si le titre est vide
const String titleErrorText = 'Le titre est obligatoire';

/// Message d'erreur si la description est vide
const String descriptionErrorText = 'La description est obligatoire';

/// Message d'erreur si le prix est vide
const String priceErrorText = 'Le prix est obligatoire';

/// Message d'erreur si le chemin image est vide
const String imageUrlErrorText = 'Le chemin de l\'image est obligatoire';

/// Message d'erreur si le prix n'est pas un nombre valide
const String invalidPriceText = 'Le prix doit être un nombre valide';

/// Message affiché quand un produit est ajouté avec succès
const String addProductSuccessText = 'Produit ajouté avec succès !';

/// ============================================================================
/// CONSTANTES DE PAGINATION
/// ============================================================================

/// Nombre de colonnes dans la grille de produits
const int gridCrossAxisCount = 2;

/// Nombre de produits affichés par page (pour futures implémentations)
const int productsPerPage = 10;
