import 'package:intl/intl.dart';

/// Utilitaires de formatage pour l'application
final NumberFormat _currencyFormat = NumberFormat.decimalPattern('fr_FR');

String formatCurrency(double price) {
  // On arrondit au nombre entier le plus proche (XOF sans décimales)
  return '${_currencyFormat.format(price.round())} XOF';
}
