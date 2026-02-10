import 'package:flutter/material.dart';

/// Widget personnalisé du menu latéral (Drawer) de TechStore
/// 
/// Affiche les options de navigation :
/// - Accueil
/// - Panier
/// - Administration
class CustomDrawer extends StatelessWidget {
  /// Callback quand on sélectionne "Accueil"
  final VoidCallback onHome;

  /// Callback quand on sélectionne "Panier"
  final VoidCallback onCart;

  /// Callback quand on sélectionne "Administration"
  final VoidCallback onAdmin;

  /// Constructeur du drawer
  const CustomDrawer({
    Key? key,
    required this.onHome,
    required this.onCart,
    required this.onAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du drawer avec logo/branding
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Tech Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Votre boutique technologique',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Option : Accueil
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context); // Fermer le drawer
              onHome();
            },
          ),
          // Option : Panier
          Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Panier'),
            onTap: () {
              Navigator.pop(context);
              onCart();
            },
          ),
          const Divider(), // Séparateur
          // Option : Administration
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Administration'),
            subtitle: const Text('Ajouter un produit'),
            onTap: () {
              Navigator.pop(context);
              onAdmin();
            },
          ),
        
          const Divider(),
          // Informations en pied
          SizedBox(height: 100,),
          const Padding(
            
            padding: EdgeInsets.all(24),
            child: Text(
              'TechStore © 2026\nVotre destination pour les meilleurs produits technologiques.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(213, 11, 55, 34),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
