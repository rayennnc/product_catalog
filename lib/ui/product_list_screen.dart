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
  late final ScrollController _controller;
  bool isLoadingMore = false;

  @override
  void initState(){
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_handleScroll);
    _loadProducts();
  }

  @override
  void dispose(){
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  void _handleScroll(){
    final threshold = _controller.position.maxScrollExtent - 200;
    final nearBottom = _controller.position.pixels >= threshold;

    if (nearBottom && !isLoadingMore && _status == ViewStatus.success) {
      _loadMoreProducts();
    }
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

  Future<void> _loadMoreProducts() async {
    setState((){
      isLoadingMore = true;
    });
    try {
      final nextLimit = _limit;
      final nextSkip = _skip + _limit;

      final results = await ProductService.fetchProducts(nextLimit, nextSkip);

      setState((){
        _skip = nextSkip;
        _productResponse!.products.addAll(results.products);
      });
    } catch (e) {
      // no need to change status
    } finally {
      setState((){
        isLoadingMore = false;
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
        controller: _controller,
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