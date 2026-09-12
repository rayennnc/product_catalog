import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

class ProductService{
  static Future<ProductResponse> fetchProducts(int limit, int skip) async {
    final url = Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final data = jsonDecode(response.body);

    return ProductResponse.fromJson(data);
  }

  static Future<Product> fetchProductDetails(int id) async {
    final url = Uri.parse('https://dummyjson.com/products/$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load product details');
    }

    return Product.fromJson(jsonDecode(response.body));
  }
}