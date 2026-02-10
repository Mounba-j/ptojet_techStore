import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_shell.dart';
import 'providers/app_state.dart';

/// POINT D'ENTRÉE PRINCIPAL DE L'APPLICATION TECHSTORE
/// 
/// Cette fonction main() initialise et lance l'application Flutter.
/// Elle crée une instance de MyApp qui configure le thème et les écrans.
void main() {
  runApp(const MyApp());
}

/// Widget racine de l'application TechStore
/// 
/// Responsabilités :
/// - Configuration du thème MaterialApp
/// - Paramétrage des couleurs, polices et styles globaux
/// - Désactivation du mode debug
/// - Initialisation avec AppShell (gestion d'état et navigation)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
      // Titre de l'application (utilisé par le système d'exploitation)
      title: 'Tech Store - Boutique Technologique',
      
      // Configuration du thème MaterialApp
      theme: ThemeData(
        // Couleur primaire : vert turquoise (marque de TechStore)
        // Utilisée pour AppBar, boutons, accents, etc.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(165, 8, 126, 120),
        ),
        
        // Autres paramètres de thème
        useMaterial3: true, // Utiliser Material Design 3 (design moderne)
      ),
      
      // Écran initial : AppShell s'appuie maintenant sur Provider pour l'état
      home: const AppShell(),
      
      // Masquer la bannière "DEBUG" en bas à droite
      debugShowCheckedModeBanner: false,
      ),
    );
  }
}

