import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String appId = 'RQQ1VU1460BFJYN';
  final String apiKey = '7b0c313e9d3d4e5887bec3c734ecec4320240707175024538629';
  final String baseUrl = 'https://api.timbu.cloud';

  Future<List<Product>> fetchProducts({String? organizationId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response body
        List<dynamic> productsJson = json.decode(response.body)['items'];

        // Convert JSON objects to Product objects using map and toList
        List<Product> products = productsJson.map((json) => Product.fromJson(json, baseUrl)).toList();

        print('Parsed products: $products');
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw Exception('Failed to load products');
    }
  }
}

class Product {
  final String name;
  final String description;
  final String id;
  final String dateCreated;
  final bool isAvailable;
  final List<String> productImageUrls;
  final double currentPrice;

  Product({
    required this.name,
    required this.description,
    required this.id,
    required this.dateCreated,
    required this.isAvailable,
    required this.productImageUrls,
    required this.currentPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json, String baseUrl) {
    List<String> productImageUrls = [];

    // Extract product image URLs if available
    if (json['photos'] != null && json['photos'] is List) {
      productImageUrls = List<String>.from(json['photos'].map((photo) {
        if (photo['url'] is String) {
          return '$baseUrl/images/${photo['url']}';
        } else {
          return '';
        }
      }));
    }

    // Extract current price
    double currentPrice = 0.0;
    if (json['current_price'] != null && json['current_price'] is List) {
      var priceData = json['current_price'][0];
      if (priceData is Map) {
        var kesPrice = priceData['KES'];
        if (kesPrice is List && kesPrice.isNotEmpty) {
          currentPrice = kesPrice[0] ?? 0.0;
        }
      }
    }

    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      dateCreated: json['date_created'] ?? '',
      isAvailable: json['is_available'] ?? false,
      productImageUrls: productImageUrls,
      currentPrice: currentPrice,
    );
  }
}
