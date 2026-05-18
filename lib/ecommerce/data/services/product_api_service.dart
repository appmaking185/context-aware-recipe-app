import 'package:dio/dio.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_constants.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';

enum ProductSortOption {
  none,
  priceLowToHigh,
  priceHighToLow,
  rating,
}

class ProductApiService {
  ProductApiService(this._dio);

  final Dio _dio;

  Future<ProductsPageResult> fetchProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? category,
  }) async {
    final String url;
    final Map<String, dynamic> query = {'limit': limit, 'skip': skip};

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      url = '${EcommerceConstants.productsBaseUrl}/search';
      query['q'] = searchQuery.trim();
    } else if (category != null && category.isNotEmpty && category != 'all') {
      url =
          '${EcommerceConstants.productsBaseUrl}/category/${Uri.encodeComponent(category)}';
    } else {
      url = EcommerceConstants.productsBaseUrl;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      url,
      queryParameters: query,
    );
    final data = response.data ?? {};
    final list = (data['products'] as List<dynamic>? ?? [])
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductsPageResult(
      products: list,
      total: data['total'] as int? ?? list.length,
    );
  }

  Future<ProductModel> fetchProductById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${EcommerceConstants.productsBaseUrl}/$id',
    );
    return ProductModel.fromJson(response.data ?? {});
  }

  Future<List<ProductCategory>> fetchCategories() async {
    final response = await _dio.get<dynamic>(
      '${EcommerceConstants.productsBaseUrl}/categories',
    );
    final data = response.data;
    if (data is List) {
      return data
          .map(
            (e) => ProductCategory.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }
    return [];
  }

  List<ProductModel> applySort(
    List<ProductModel> products,
    ProductSortOption sort,
  ) {
    final sorted = List<ProductModel>.from(products);
    switch (sort) {
      case ProductSortOption.priceLowToHigh:
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
      case ProductSortOption.priceHighToLow:
        sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
      case ProductSortOption.rating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSortOption.none:
        break;
    }
    return sorted;
  }
}
