import 'dart:async';
import 'package:flutter/material.dart';
import '../data/product.dart';
import '../data/product_service.dart';
import '../ui/product_detail_screen.dart';

enum ViewStatus {loading, error, empty, success}

class ProductListScreen extends StatefulWidget{
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductResponse? _productResponse;
  ViewStatus _status = ViewStatus.loading;
  final int _limit = 20;
  int _skip = 0;
  late final ScrollController _controller;
  bool isLoadingMore = false;
    final _searchController = TextEditingController();
  String _query = '';
  Timer? _debounce;

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
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _handleScroll(){
    final threshold = _controller.position.maxScrollExtent - 200;
    final nearBottom = _controller.position.pixels >= threshold;

    if (nearBottom && !isLoadingMore && _status == ViewStatus.success) {
      _loadMoreProducts();
    }
  }

    void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _query = value;
      });
    });
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
    
    final filtered = _query.isEmpty
      ? products
      : products
        .where((product) => product.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Product list')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(hintText: 'Search Product...'),
            ),
          ),
          Expanded(
            child: _status == ViewStatus.loading ? const Center(
        child: CircularProgressIndicator()
      ) : _status == ViewStatus.error ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Failed to load products'),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      ) : _status == ViewStatus.empty || filtered.isEmpty ? const Center(
        child: Text('No products found')
      ) : ListView.builder(
        controller: _controller,
        itemCount: filtered.length,
        itemBuilder: (content, index) {
          final product = filtered[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(productId: product.id),
                ),
              );
            },
            title: Text(product.title),
            subtitle: Text('Price: ${product.price}'),
            leading: Image.network(product.thumbnail),
          );
        })
          )
        ]
      )
    );
  }
}