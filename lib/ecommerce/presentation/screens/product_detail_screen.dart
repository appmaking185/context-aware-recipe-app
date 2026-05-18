import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_currency.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/product_provider.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>().selectedProduct;
    final cart = context.watch<CartProvider>();
    final qty = product == null ? 0 : cart.quantityForProduct(product.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SizedBox(
                          height: 260,
                          child: PageView.builder(
                            itemCount: product.images.isEmpty
                                ? 1
                                : product.images.length,
                            onPageChanged: (i) =>
                                setState(() => _imageIndex = i),
                            itemBuilder: (_, index) {
                              final url = product.images.isEmpty
                                  ? product.thumbnail
                                  : product.images[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.isEmpty
                                ? 1
                                : product.images.length,
                            (i) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _imageIndex == i
                                    ? AppColors.appColor
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(product.description),
                        const SizedBox(height: 12),
                        _InfoRow('Brand', product.brand),
                        _InfoRow('Category', product.category),
                        _InfoRow('Rating', '${product.rating}'),
                        _InfoRow('Status', product.availabilityStatus),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              EcommerceCurrency.formatFromUsd(
                                product.discountedPrice,
                              ),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.discountPercentage > 0)
                              Text(
                                EcommerceCurrency.formatFromUsd(
                                  product.price,
                                ),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textColor757575,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (qty > 0) ...[
                          IconButton(
                            onPressed: () =>
                                cart.decreaseQuantity(product.id),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$qty', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            onPressed: () =>
                                cart.increaseQuantity(product.id),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                        Expanded(
                          child: FilledButton(
                            onPressed: product.inStock
                                ? () => cart.addProduct(product)
                                : null,
                            child: Text(
                              qty > 0 ? 'Add more' : 'Add to cart',
                            ),
                          ),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textColor757575),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
