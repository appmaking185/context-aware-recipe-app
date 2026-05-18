class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final String availabilityStatus;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.availabilityStatus,
  });

  bool get inStock =>
      stock > 0 &&
      availabilityStatus.toLowerCase() != 'out of stock';

  bool get isLowStock =>
      availabilityStatus.toLowerCase() == 'low stock';

  double get discountedPrice =>
      price - (price * discountPercentage / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] as int? ?? 0,
      brand: json['brand'] as String? ?? 'Generic',
      thumbnail: json['thumbnail'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      availabilityStatus:
          json['availabilityStatus'] as String? ??
          ((json['stock'] as int? ?? 0) > 0 ? 'In Stock' : 'Out of Stock'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'thumbnail': thumbnail,
        'images': images,
        'availabilityStatus': availabilityStatus,
      };
}

class ProductCategory {
  final String slug;
  final String name;

  const ProductCategory({required this.slug, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class ProductsPageResult {
  final List<ProductModel> products;
  final int total;

  const ProductsPageResult({
    required this.products,
    required this.total,
  });
}
