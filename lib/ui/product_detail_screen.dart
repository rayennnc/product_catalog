import 'package:flutter/material.dart';
import '../data/product.dart';
import '../data/product_service.dart';

enum DetailStatus {loading, error, success}

class ProductDetailScreen extends StatefulWidget{
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  DetailStatus _status = DetailStatus.loading;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    setState((){
      _status = DetailStatus.loading;
    });
    try {
      final result = await ProductService.fetchProductDetails(widget.productId);
      setState((){
        _product = result;
        _status = DetailStatus.success;
      });
    } catch (e) {
      setState((){
        _status = DetailStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: _status == DetailStatus.loading ? const Center(
        child: CircularProgressIndicator()
      ) : _status == DetailStatus.error ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text ('Failed to fetch product details'),
            ElevatedButton(onPressed: _loadProductDetails, child: const Text('Retry'))
          ]
        )
      )
      : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: _product!.images.length,
              itemBuilder: (context, index) => Image.network(
                _product!.images[index],
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _product!.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
            Text('Description: ${_product!.description}', style: const TextStyle(fontSize: 12),
            ),
            Text('Price: ${_product!.price}', style: const TextStyle(fontSize: 12),
            ),
            Text('Rating: ${_product!.rating}', style: const TextStyle(fontSize: 12),
            ),
          ],
        )
      )
    );
  }
}