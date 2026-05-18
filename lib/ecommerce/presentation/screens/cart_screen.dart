import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_currency.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: SafeArea(
        child: cart.items.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.product.thumbnail,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${EcommerceCurrency.formatFromUsd(item.product.discountedPrice)} × ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    cart.decreaseQuantity(item.product.id),
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () =>
                                    cart.increaseQuantity(item.product.id),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () =>
                                    cart.removeItem(item.product.id),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.alertcolor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SummaryRow('Items', '${cart.totalItems}'),
                        _SummaryRow(
                          'Subtotal',
                          EcommerceCurrency.formatFromUsd(cart.subtotal),
                        ),
                        _SummaryRow(
                          'Discount',
                          '-${EcommerceCurrency.formatFromUsd(cart.totalDiscount)}',
                        ),
                        const Divider(),
                        _SummaryRow(
                          'Payable',
                          EcommerceCurrency.formatFromUsd(cart.payableAmount),
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? AppColors.appColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
