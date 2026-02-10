import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product.dart';

/// Écran d'Administration - Ajout de nouveaux produits au catalogue
///
/// Permet aux administrateurs d'ajouter des produits au catalogue via un formulaire
/// avec validation complète des champs.
class AdminScreen extends StatefulWidget {
  /// Identifiant unique du screen dans la navigation
  static const routeName = '/admin';

  /// Callback quand on valide et ajoute un nouveau produit
  /// Paramètre : Le produit à ajouter
  final Function(Product) onAddProduct;

  /// Callback pour retourner à l'accueil
  final VoidCallback onCancel;

  /// Constructeur de l'écran d'administration
  const AdminScreen({Key? key, required this.onAddProduct, required this.onCancel}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  /// Clé globale du formulaire pour accéder à ses states
  final _formKey = GlobalKey<FormState>();

  /// Contrôleurs de texte pour chaque champ du formulaire
  /// Ces contrôleurs permettent de récupérer les valeurs saisies

  /// Contrôleur du champ "Titre"
  final _titleController = TextEditingController();

  /// Contrôleur du champ "Description"
  final _descriptionController = TextEditingController();

  /// Contrôleur du champ "Prix"
  final _priceController = TextEditingController();

  /// Contrôleur du champ "URL de l'image"
  final _imageUrlController = TextEditingController();

  /// Image sélectionnée pour le produit
  File? _selectedImage;

  /// Indique si le formulaire est en cours de validation
  bool _isLoading = false;

  /// Instance pour sélectionner une image
  final ImagePicker _imagePicker = ImagePicker();

  /// Destructeur pour libérer les ressources des contrôleurs
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  /// Permet de sélectionner une image depuis la galerie
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compresser l'image
      );
      
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        print('Image sélectionnée: ${imageFile.path}');
        print('Fichier existe: ${await imageFile.exists()}');
        
        setState(() {
          _selectedImage = imageFile;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image sélectionnée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de la sélection d\'image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Permet de prendre une photo avec la caméra
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        print('Photo prise: ${imageFile.path}');
        
        setState(() {
          _selectedImage = imageFile;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo capturée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de la capture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Fonction de validation et d'ajout du produit
  void _submitForm() {
    // Vérifier qu'une image a été sélectionnée
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez sélectionner une image pour le produit',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validation : vérifier que tous les champs sont valides
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Sauvegarder le formulaire (déclenche les validateurs)
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    // Simuler un délai réseau (exemple)
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        // Récupérer les valeurs saisies
        final title = _titleController.text.trim();
        final description = _descriptionController.text.trim();
        final price = double.parse(_priceController.text);
        
        // Utiliser le chemin de l'image sélectionnée
        // En production, vous uploaderiez l'image sur un serveur
        final imageUrl = _selectedImage!.path;

        // Générer un ID unique pour le nouveau produit
        // (dans une vraie app, ce serait générée par le serveur)
        final newId = DateTime.now().millisecondsSinceEpoch;

        // Créer le nouveau produit
        final newProduct = Product(
          id: newId,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

        // Appeler le callback pour ajouter le produit
        widget.onAddProduct(newProduct);

        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _imageUrlController.clear();
        
        // Réinitialiser l'image sélectionnée
        setState(() {
          _selectedImage = null;
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Produit ajouté avec succès ! 🎉',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 2000),
          ),
        );

        // Retour à l'accueil après succès
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
        });
      } catch (error) {
        // Afficher une erreur si quelque chose s'est mal passé
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $error'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== EN-TÊTE =====
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white54),
      ),
      // ===== FORMULAIRE =====
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            // Le formulaire contient tous les champs de saisie
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre explicatif
                const Text(
                  'Formulaire d\'ajout de produit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complétez les champs ci-dessous pour ajouter un nouveau produit au catalogue.',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color.fromARGB(255, 35, 30, 30),
                  ),
                ),
                const SizedBox(height: 24),

                // ===== CHAMP 1 : TITRE =====
                const Text(
                  'Titre du produit *',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Ex: iPhone 15 Pro',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.shopping_bag),
                  ),
                  // Validation du titre
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est obligatoire';
                    }
                    if (value.length < 3) {
                      return 'Le titre doit contenir au moins 3 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ===== CHAMP 2 : DESCRIPTION =====
                const Text(
                  'Description *',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Décrivez le produit en détail...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  minLines: 3,
                  maxLines: 10,
                  textInputAction: TextInputAction.newline,
                  // Validation de la description
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La description est obligatoire';
                    }
                    if (value.length < 10) {
                      return 'La description doit contenir au moins 10 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ===== CHAMP 3 : PRIX =====
                const Text(
                  'Prix (en XOF) *',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Ex: 500.000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  // Validation du prix
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le prix est obligatoire';
                    }
                    try {
                      final price = double.parse(value);
                      if (price <= 0) {
                        return 'Le prix doit être supérieur à 0';
                      }
                    } catch (e) {
                      return 'Entrez un nombre valide (ex: 9999.99)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ===== CHAMP 4 : IMAGE DU PRODUIT =====
                const Text(
                  'Image du produit *',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                // Aperçu de l'image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Aucune image sélectionnée',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      size: 60,
                                      color: Colors.red[400],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Erreur lors du chargement',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                // Boutons pour sélectionner une image
                Row(
                  children: [
                    // Bouton "Galerie"
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickImageFromGallery,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blue,
                        ),
                        icon: const Icon(Icons.photo_library, color: Colors.white),
                        label: const Text(
                          'Galerie',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Bouton "Caméra"
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickImageFromCamera,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey[700],
                        ),
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text(
                          'Caméra',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ===== ANCIEN CHAMP 4 : URL DE L'IMAGE (CACHÉ) =====
                // Ce champ n'est plus visible mais reste pour la retrocompatibilité
                Visibility(
                  visible: false,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          hintText: 'assets/images/mon-image.png',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.image),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null; // Pas de validation puisque l'image est uploadée
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ===== BOUTONS D'ACTION =====
                Row(
                  children: [
                    // Bouton "Annuler"
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : widget.onCancel,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color.fromARGB(
                            255,
                            248,
                            99,
                            99,
                          ),
                        ),

                        child: const Text(
                          'Annuler',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Bouton "Valider"
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
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
                const SizedBox(height: 20),

                // Note importante
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Text(
                    '💡 Conseil : Sélectionnez une image de haute qualité depuis votre galerie ou prenez une photo avec la caméra. L\'image sera compressée automatiquement.',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
