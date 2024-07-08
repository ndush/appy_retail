import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider() {
    fetchProducts(organizationId: '7cd9a1ace9534942827d1d6a6896b375');
  }

  void fetchProducts({String? organizationId}) async {
    try {
      _products = await _apiService.fetchProducts(organizationId: organizationId);
    } catch (error) {
      print('Error fetching products: $error');
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
