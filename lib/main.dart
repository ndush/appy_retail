import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListScreen(),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            print('Loaded products: ${provider.products}');
            if (provider.products.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              return ListView.builder(
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: product.productImageUrls.isNotEmpty
                            ? Image.network(
                          product.productImageUrls.first,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Placeholder(
                          fallbackWidth: 50,
                          fallbackHeight: 50,
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          Text('Price: \$${product.currentPrice}'),
                        ],
                      ),
                      onTap: () {

                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
