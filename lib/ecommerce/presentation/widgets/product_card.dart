import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_currency.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.cartQuantity,
    required this.onTap,
    required this.onAdd,
  });

  final ProductModel product;
  final int cartQuantity;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(
                  color: AppColors.greyBackground,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: AppColors.textColor757575,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        EcommerceCurrency.formatFromUsd(
                          product.discountedPrice,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.discountPercentage > 0)
                        Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: AppColors.greenColor05A660,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(' ${product.rating}'),
                      const Spacer(),
                      Text(
                        product.availabilityStatus,
                        style: TextStyle(
                          fontSize: 11,
                          color: product.inStock
                              ? (product.isLowStock
                                    ? AppColors.custYellow
                                    : AppColors.greenColor05A660)
                              : AppColors.alertcolor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: product.inStock ? onAdd : null,
                      icon: Icon(
                        cartQuantity > 0
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                      ),
                      label: Text(
                        style: const TextStyle(fontSize: 12),
                        cartQuantity > 0
                            ? 'In cart ($cartQuantity)'
                            : 'Add to cart',
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
