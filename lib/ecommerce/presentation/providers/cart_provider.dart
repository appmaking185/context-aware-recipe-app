import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/cart_item_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/ecommerce_storage_service.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._storage);

  final EcommerceStorageService _storage;
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, e) => sum + e.quantity);

  double get subtotal =>
      _items.fold(0, (sum, e) => sum + e.product.price * e.quantity);

  double get totalDiscount =>
      _items.fold(0, (sum, e) => sum + e.lineDiscount);

  double get payableAmount =>
      _items.fold(0, (sum, e) => sum + e.lineSubtotal);

  Future<void> loadCart() async {
    _items
      ..clear()
      ..addAll(_storage.loadCart());
    notifyListeners();
  }

  int quantityForProduct(int productId) {
    final item = _items.where((e) => e.product.id == productId);
    if (item.isEmpty) return 0;
    return item.first.quantity;
  }

  bool isInCart(int productId) =>
      _items.any((e) => e.product.id == productId);

  Future<void> addProduct(ProductModel product) async {
    final index =
        _items.indexWhere((element) => element.product.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(CartItemModel(product: product, quantity: 1));
    }
    await _persist();
    notifyListeners();
  }

  Future<void> increaseQuantity(int productId) async {
    final index =
        _items.indexWhere((element) => element.product.id == productId);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + 1,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> decreaseQuantity(int productId) async {
    final index =
        _items.indexWhere((element) => element.product.id == productId);
    if (index < 0) return;
    final nextQty = _items[index].quantity - 1;
    if (nextQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: nextQty);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((e) => e.product.id == productId);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() => _storage.saveCart(_items);
}
