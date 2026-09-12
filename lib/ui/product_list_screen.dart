import 'package:flutter/material.dart';
import '../data/product.dart';
import '../data/product_service.dart';

enum ViewStatus {loading, error, empty, success}

class ProductListScreen extends StatefulWidget{
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductResponse? _productResponse;
  ViewStatus _status = ViewStatus.loading;
  int _limit = 20;
  int _skip = 0;

  @override
  void initState(){
    super.initState();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    setState((){
      _status = ViewStatus.loading;
    });
    try {
      final result = await ProductService.fetchProducts(_limit, _skip);
      setState((){
        _productResponse = result;
        _status = result.products.isEmpty ? ViewStatus.empty : ViewStatus.success;
      });
    } catch (e) {
      setState(() {
        _status = ViewStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _productResponse?.products ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Product list')),
      body: _status == ViewStatus.loading ? const Center(
        child: CircularProgressIndicator()
      ) : _status == ViewStatus.error ? const Center(
        child: Text('Failed to load products')
      ) : _status == ViewStatus.empty ? const Center(
        child: Text('No products found')
      ) : ListView.builder(
        itemCount: products.length,
        itemBuilder: (content, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('Price: ${product.price}'),
            leading: Image.network(product.thumbnail),
          );
        })
    );
  }
}