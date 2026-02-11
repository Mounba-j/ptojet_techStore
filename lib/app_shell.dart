import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/admin_screen.dart';
import 'providers/app_state.dart';

/// Widget principal (Shell/Coque) de l'application TechStore
/// 
/// Responsabilités :
/// - Gestion de l'état global (produits, panier)
/// - Navigation entre les écrans
/// - Création et mise à jour des données
/// 
/// Structure :
/// - productCatalog : liste mutable des produits du catalogue
/// - cart : liste mutable des articles du panier
/// - Méthodes : addToCart, removeFromCart, updateQuantity, etc.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    Widget currentScreenWidget;

    switch (appState.currentScreen) {
      case 'HOME':
        currentScreenWidget = const HomeScreen();
        break;
      case 'PRODUCT_DETAIL':
        currentScreenWidget = ProductDetailScreen(
          product: appState.selectedProduct!,
          onAddToCart: (product) {
            appState.addToCart(product);
            appState.backToHome();
          },
          onBack: () {
            appState.backToHome();
          },
        );
        break;
      case 'CART':
        currentScreenWidget = CartScreen(
          cartItems: appState.cartItems,
          onIncreaseQuantity: appState.increaseQuantity,
          onDecreaseQuantity: appState.decreaseQuantity,
          onRemoveItem: appState.removeFromCart,
          onCheckout: () {
            appState.clearCart();
            appState.navigateTo('HOME');
          },
          onNavigateHome: () => appState.navigateTo('HOME'),
        );
        break;
      case 'ADMIN':
        currentScreenWidget = AdminScreen(
          onAddProduct: (product) {
            appState.addProduct(product);
            appState.navigateTo('HOME');
          },
          onCancel: () {
            appState.navigateTo('HOME');
          },
        );
        break;
      default:
        currentScreenWidget = const HomeScreen();
    }

    return currentScreenWidget;
  }
}
