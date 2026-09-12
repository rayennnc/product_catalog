class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    products: List<Product>.from(json['products'].map((product) => Product.fromJson(product))),
    total: json['total'] ?? 0,
    skip: json['skip'] ?? 0,
    limit: json['limit'] ?? 0,
  );

}

class Product{
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final List<String> images;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.images,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    thumbnail: json['thumbnail'] ?? '',
    images: List<String>.from(json['images'].map((image) => image)),
    price: json['price'] ?.toDouble() ?? 0.0,
    rating: json['rating'] ?.toDouble() ?? 0.0,
  );
}
