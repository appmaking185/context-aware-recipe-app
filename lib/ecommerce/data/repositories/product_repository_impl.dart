import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._api);

  final ProductApiService _api;

  @override
  Future<ProductsPageResult> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? category,
  }) =>
      _api.fetchProducts(
        limit: limit,
        skip: skip,
        searchQuery: searchQuery,
        category: category,
      );

  @override
  Future<ProductModel> getProductById(int id) => _api.fetchProductById(id);

  @override
  Future<List<ProductCategory>> getCategories() => _api.fetchCategories();

  @override
  List<ProductModel> sortProducts(
    List<ProductModel> products,
    ProductSortOption sort,
  ) =>
      _api.applySort(products, sort);
}
