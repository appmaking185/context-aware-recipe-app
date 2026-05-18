import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  double get lineSubtotal => product.discountedPrice * quantity;

  double get lineDiscount =>
      (product.price - product.discountedPrice) * quantity;

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
