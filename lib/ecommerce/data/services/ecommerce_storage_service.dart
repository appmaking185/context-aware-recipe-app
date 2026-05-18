import 'dart:convert';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_constants.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/cart_item_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';

class EcommerceStorageService {
  Box? _cartBox;
  Box? _cacheBox;

  Future<void> init() async {
    _cartBox = await Hive.openBox(EcommerceConstants.cartBoxName);
    _cacheBox = await Hive.openBox(EcommerceConstants.productsCacheBox);
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    final encoded =
        items.map((e) => jsonEncode(e.toJson())).toList();
    await _cartBox?.put('items', encoded);
  }

  List<CartItemModel> loadCart() {
    final raw = _cartBox?.get('items');
    if (raw is! List) return [];
    return raw
        .map((e) => CartItemModel.fromJson(
              jsonDecode(e as String) as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final encoded =
        products.map((e) => jsonEncode(e.toJson())).toList();
    await _cacheBox?.put('latest', encoded);
  }

  List<ProductModel> loadCachedProducts() {
    final raw = _cacheBox?.get('latest');
    if (raw is! List) return [];
    return raw
        .map((e) => ProductModel.fromJson(
              jsonDecode(e as String) as Map<String, dynamic>,
            ))
        .toList();
  }
}
