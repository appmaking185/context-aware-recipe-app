import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/api_error_mapper.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_constants.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/ecommerce_storage_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/domain/repositories/product_repository.dart';

enum ProductListStatus { initial, loading, loaded, error, offline }

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  ProductProvider({
    required ProductRepository repository,
    required EcommerceStorageService storage,
  })  : _repository = repository,
        _storage = storage;

  final ProductRepository _repository;
  final EcommerceStorageService _storage;

  final List<ProductModel> _products = [];
  List<ProductCategory> categories = [];
  ProductListStatus status = ProductListStatus.initial;
  String? errorMessage;
  bool isLoadingMore = false;
  bool hasMore = true;
  int _skip = 0;
  int _total = 0;
  bool _isFetching = false;
  bool _paginationLocked = false;

  String searchQuery = '';
  String selectedCategory = 'all';
  ProductSortOption sortOption = ProductSortOption.none;

  Timer? _debounce;
  ProductModel? selectedProduct;
  ProductDetailStatus detailStatus = ProductDetailStatus.initial;
  String? detailErrorMessage;
  int? _loadingDetailId;

  List<ProductModel> get products => List.unmodifiable(_products);

  bool get isShowingCachedData => status == ProductListStatus.offline;

  Future<void> init() async {
    await Future.wait([loadCategories(), refreshProducts()]);
  }

  Future<void> loadCategories() async {
    try {
      categories = await _repository.getCategories();
      notifyListeners();
    } catch (_) {
      categories = [];
    }
  }

  Future<void> refreshProducts() async {
    _skip = 0;
    hasMore = true;
    _products.clear();
    errorMessage = null;
    status = ProductListStatus.loading;
    notifyListeners();
    await _fetchPage(reset: true);
  }

  Future<void> loadMore() async {
    if (_isFetching || !hasMore || _paginationLocked) return;
    _paginationLocked = true;
    await _fetchPage();
    _paginationLocked = false;
  }

  void onSearchChanged(String value) {
    searchQuery = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      refreshProducts();
    });
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    refreshProducts();
  }

  void setSort(ProductSortOption option) {
    sortOption = option;
    _applyLocalSort();
    notifyListeners();
  }

  Future<void> loadProductDetails(int id) async {
    _loadingDetailId = id;
    detailStatus = ProductDetailStatus.loading;
    detailErrorMessage = null;
    selectedProduct = null;
    notifyListeners();

    try {
      selectedProduct = await _repository.getProductById(id);
      if (_loadingDetailId != id) return;
      detailStatus = ProductDetailStatus.loaded;
      detailErrorMessage = null;
    } catch (e) {
      if (_loadingDetailId != id) return;
      detailStatus = ProductDetailStatus.error;
      detailErrorMessage = ApiErrorMapper.message(e);
      selectedProduct = null;
    }
    notifyListeners();
  }

  Future<void> _fetchPage({bool reset = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    if (!reset) {
      isLoadingMore = true;
      notifyListeners();
    }

    try {
      final result = await _repository.getProducts(
        limit: EcommerceConstants.pageSize,
        skip: _skip,
        searchQuery: searchQuery.trim().isEmpty ? null : searchQuery.trim(),
        category: selectedCategory == 'all' ? null : selectedCategory,
      );

      final sorted = _repository.sortProducts(result.products, sortOption);
      _products.addAll(sorted);
      _total = result.total;
      _skip += EcommerceConstants.pageSize;
      hasMore = _products.length < _total;
      status = ProductListStatus.loaded;
      errorMessage = null;
      await _storage.cacheProducts(_products);
    } catch (e) {
      final friendly = ApiErrorMapper.message(e);
      if (_products.isEmpty) {
        final cached = _storage.loadCachedProducts();
        if (cached.isNotEmpty) {
          _products.addAll(cached);
          status = ProductListStatus.offline;
          errorMessage = null;
          hasMore = false;
        } else {
          status = ProductListStatus.error;
          errorMessage = friendly;
        }
      } else {
        errorMessage = friendly;
      }
    } finally {
      _isFetching = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void _applyLocalSort() {
    final sorted = _repository.sortProducts(_products, sortOption);
    _products
      ..clear()
      ..addAll(sorted);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
