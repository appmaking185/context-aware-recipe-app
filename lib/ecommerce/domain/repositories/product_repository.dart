import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';

abstract class ProductRepository {
  Future<ProductsPageResult> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? category,
  });

  Future<ProductModel> getProductById(int id);

  Future<List<ProductCategory>> getCategories();

  List<ProductModel> sortProducts(
    List<ProductModel> products,
    ProductSortOption sort,
  );
}
