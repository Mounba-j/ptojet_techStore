import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';

/// AppState gère le catalogue et le panier, remplaçant AppShell comme source unique de vérité
class AppState extends ChangeNotifier {
  late List<Product> _products;
  final List<CartItem> _cart = [];
  String _currentScreen = 'HOME';
  Product? _selectedProduct;

  AppState() {
    _products = List.from(productCatalog);
  }

  List<Product> get products => _products;
  List<CartItem> get cartItems => List.unmodifiable(_cart);
  String get currentScreen => _currentScreen;
  Product? get selectedProduct => _selectedProduct;

  int get cartItemCount {
    int count = 0;
    for (var item in _cart) {
      count += item.quantity;
    }
    return count;
  }

  void addToCart(Product product) {
    final existing = _cart.firstWhere(
      (it) => it.product.id == product.id,
      orElse: () => CartItem(product: Product(id: -1, title: '', description: '', price: 0, imageUrl: ''), quantity: 0),
    );

    if (existing.product.id != -1) {
      existing.increaseQuantity();
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((it) => it.product.id == productId);
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final item = _cart.firstWhere((it) => it.product.id == productId);
    item.increaseQuantity();
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _cart.firstWhere((it) => it.product.id == productId);
    item.decreaseQuantity();
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void navigateTo(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void showProductDetail(Product product) {
    _selectedProduct = product;
    _currentScreen = 'PRODUCT_DETAIL';
    notifyListeners();
  }

  void backToHome() {
    _currentScreen = 'HOME';
    _selectedProduct = null;
    notifyListeners();
  }
}
