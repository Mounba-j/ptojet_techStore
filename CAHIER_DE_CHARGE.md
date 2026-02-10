 CAHIER DE CHARGE - APPLICATION TECHSTORE

 1. PRÉSENTATION GÉNÉRALE

**TechStore** est une application e-commerce Flutter permettant aux utilisateurs de :
- Parcourir un catalogue de produits technologiques
- Ajouter des articles à un panier
- Gérer leur panier (modification, suppression)
- Valider les achats
- Administrer le catalogue (ajout de produits)

---

 2. SPÉCIFICATIONS FONCTIONNELLES

# 🏠 ÉCRAN 1 : ACCUEIL (LE MAGASIN)

 En-tête (Header/AppBar)
- **Titre** : "TechStore"
- **Icône Panier** : Avec badge affichant le nombre d'articles (ex: "3")
- **Couleur** : Thème personnalisé (couleur verte/turquoise)
- **Navigation** : Drawer menu pour accéder aux autres sections

 Zone "À la une"
- **Carrousel horizontal** : 3 produits phares défilants
- **Auto-scroll** : Défilement continu pour attirer l'attention
- **Tappable** : Clic pour voir les détails du produit

 Zone "Catalogue"
- **GridView** : 2 colonnes
- **Cartes produits** : Affichant :
  - Image du produit
  - Titre du produit
  - Prix en évidence
  - Bouton "Ajouter au panier" (rapide)
- **Scroll infini** : Possibilité d'ajouter plus de produits

 Menu Latéral (Drawer)
- Lien vers **Accueil**
- Lien vers **Panier**
- Lien vers **Administration** (Ajout produit)
- Icônes claires et lisibles

---

# 📄 ÉCRAN 2 : DÉTAILS PRODUIT

Accessible en cliquant sur un produit depuis l'accueil.

 Contenu
- **Image Grande** : Affichage en grand format (responsive)
- **Titre** : Bien visible
- **Description Complète** : Texte multi-lignes explicite
- **Prix** : Affiché en gros et en évidence
- **Bouton Flottant/Fixe** : "Ajouter au panier"
- **Bouton Retour** : Navigation vers l'écran précédent

 Interactions
- Clic sur "Ajouter au panier" → Article ajouté au panier
- Badge de panier mis à jour en temps réel

---

 🛒 ÉCRAN 3 : PANIER

 Contenu Principal
- **Liste des articles** : Chaque ligne affiche :
  - Nom du produit
  - Prix unitaire
  - **Quantité** : Avec boutons **+** et **-**
  - **Sous-total** : Prix unitaire × Quantité
  - **Bouton Supprimer** : Croix ou icône poubelle

 Pied de Page (Footer)
- **Total Général** : Somme dynamique de tous les sous-totaux
- **Bouton Valider** : Pour confirmer l'achat (optionnel : affiche un message de succès)
- **Bouton Continuer Shopping** : Retour à l'accueil

 Interactions
- Bouton **+** → Augmente la quantité
- Bouton **-** → Diminue la quantité (minimum 1)
- Bouton **Supprimer** → Retire l'article du panier
- Total mis à jour automatiquement

---

* ⚙️ ÉCRAN 4 : ADMINISTRATION (AJOUT DE PRODUIT)

Formulaire permettant d'ajouter de nouveaux produits au catalogue.

 Champs Obligatoires
1. **Titre** : TextFormField (texte simple)
2. **Description** : TextFormField (texte multi-lignes)
3. **Prix** : TextFormField (clavier numérique obligatoire)
4. **URL Image** : TextFormField (lien web valide)

 Validation
- Tous les champs obligatoires
- Message d'erreur si un champ est vide
- Validation du format URL pour l'image
- Validation du prix (nombre positif)

 Comportement
- Bouton **Valider** : 
  - Vérification des champs
  - Création du produit
  - Ajout à la liste en mémoire
  - Message de succès
  - Retour à l'accueil
- Bouton **Annuler** : Retour sans sauvegarde

---

 3. SPÉCIFICATIONS TECHNIQUES

* Architecture & Structure

```
lib/
├── main.dart                    * Point d'entrée + Config ThemeData
├── app_shell.dart             * Widget principal (gestion état global)
├── models/
│   ├── product.dart           * Classe Product
│   └── cart_item.dart         * Classe CartItem
├── screens/
│   ├── home_screen.dart       * Écran Accueil
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   └── admin_screen.dart
├── widgets/
│   ├── product_card.dart      * Composant carte produit
│   ├── cart_item_card.dart    * Composant ligne panier
│   ├── carousel.dart          * Composant carrousel
│   └── custom_drawer.dart     * Menu latéral personnalisé
└── utils/
    └── constants.dart         * Données initiales & constantes
```

* Langage & Framework
- **Langage** : Dart 3.10.8+
- **Framework** : Flutter 3.x
- **Paradigme** : Programmation réactive avec setState (Stateful Widgets)

 Gestion d'État
- **Approche** : Simple avec setState
- **Global State** : Variables statiques dans AppShell
- **Pas de** : Bloc, Riverpod, Provider (non requis)

 Données
- **Source** : Liste statique `List<Product>` en mémoire RAM
- **Persistence** : Aucune (données perdues au redémarrage)
- **Données Initiales** : 5-6 produits de test (smartphones, laptops, etc.)

 Dépendances
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

 4. MODÈLES DE DONNÉES

 Classe `Product`
```dart
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
}
```

 Classe `CartItem`
```dart
class CartItem {
  final Product product;
  int quantity;
}
```

---

 5. GESTION DU PANIER

 Logique Globale (dans AppShell)
```dart
List<CartItem> cart = [];

void addToCart(Product product) {
  // Si produit existe déjà → +1 quantité
  // Sinon → Ajouter avec quantité 1
}

void removeFromCart(int productId) {
  // Supprimer le produit du panier
}

void updateQuantity(int productId, int newQuantity) {
  // Modifier la quantité
}

double getTotalPrice() {
  // Calculer le total
}

int getCartItemCount() {
  // Nombre total d'articles
}
```

---

 6. FLUX DE NAVIGATION

```
┌─────────────────────┐
│   Splash/Home       │
├─────────────────────┤
│   Drawer Menu       │
│  ├─ Accueil         │
│  ├─ Panier          │
│  └─ Administration  │
└─────────────────────┘
         │
    ┌────┴─────────────────┐
    │                      │
[Home Page]          [Product Detail]
    │                      │
    └──────────┬───────────┘
               │
          [Cart Page]
               │
      [Admin Page (Drawer)]
```

---

 7. ÉTAPES DE DÉVELOPPEMENT

 Phase 1 : Préparation
1. ✅ Créer la structure de dossiers
2. ✅ Définir les modèles (Product, CartItem)
3. ✅ Créer les données initiales (utils/constants.dart)

 Phase 2 : Écrans & Widgets
4. ✅ Créer AppShell (gestion état globale)
5. ✅ Créer widgets réutilisables (ProductCard, Carousel, etc.)
6. ✅ Implémenter HomeScreen avec Drawer
7. ✅ Implémenter ProductDetailScreen
8. ✅ Implémenter CartScreen
9. ✅ Implémenter AdminScreen

# Phase 3 : Intégration & Finition
10. ✅ Relier tous les écrans
11. ✅ Tester la navigation
12. ✅ Ajouter les commentaires de code

---

 8. CONVENTIONS DE CODE

# Nommage
- **Classes** : PascalCase (ex: `ProductCard`)
- **Fonctions** : camelCase (ex: `addToCart()`)
- **Variables** : camelCase (ex: `cartItems`)
- **Fichiers** : snake_case (ex: `product_card.dart`)

# Commentaires
- **En-tête de fichier** : Description brève du rôle
- **Classes & Fonctions** : Documentation avec `///`
- **Code complexe** : Commentaires explicatifs `//`

# Formatage
- **Indentation** : 2 espaces
- **Lignes** : Max 100 caractères
- **Imports** : Triés (dart, flutter, packages, locaux)

---

 9. CRITÈRES D'ACCEPTATION

✅ **L'application doit...**
- Afficher l'accueil avec header, carrousel et grille
- Permettre l'ajout au panier en temps réel
- Afficher les détails d'un produit au clic
- Gérer le panier (+ - supprimer)
- Calculer le total dynamiquement
- Ajouter de nouveaux produits via le formulaire d'admin
- Naviguer fluidement via drawer et boutons
- Avoir un code bien organisé et commenté
- Aucun bug ou crash runtime

---

 10. RESSOURCES & PACKAGES

- **Flutter Docs** : https://flutter.dev/docs
- **Dart Language** : https://dart.dev
- **Material Design 3** : https://m3.material.io/
- **PackageS**: pubspec.yaml (minimal)

---

**Statut** : 🚀 Prêt à développer  
**Dernière mise à jour** : 7 février 2026  
**Responsable** : Développeur Flutter
