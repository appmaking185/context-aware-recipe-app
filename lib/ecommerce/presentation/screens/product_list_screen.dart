import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/product_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/cart_screen.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/product_detail_screen.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/widgets/offline_banner.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/widgets/product_card.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().init();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: AppColors.alertcolor,
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const OfflineBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            products.onSearchChanged('');
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                onChanged: products.onSearchChanged,
              ),
            ),
            _FilterBar(products: products),
            Expanded(child: _buildBody(products, cart)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ProductProvider products, CartProvider cart) {
    if (products.status == ProductListStatus.loading &&
        products.products.isEmpty) {
      return _buildShimmer();
    }

    if (products.status == ProductListStatus.error &&
        products.products.isEmpty) {
      return _ErrorView(
        message: products.errorMessage ?? 'Something went wrong',
        onRetry: () {
          context.read<ConnectivityProvider>().refresh();
          products.refreshProducts();
        },
      );
    }

    if (products.products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return RefreshIndicator(
      onRefresh: products.refreshProducts,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 0.62,
          mainAxisExtent: 325,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.products.length + 1,
        itemBuilder: (context, index) {
          if (index == products.products.length) {
            if (!products.hasMore) {
              return const SizedBox.expand(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('End of list'),
                  ),
                ),
              );
            }
            if (products.isLoadingMore) {
              return const SizedBox.expand(
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final product = products.products[index];
          return ProductCard(
            product: product,
            cartQuantity: cart.quantityForProduct(product.id),
            onTap: () => _openDetails(product),
            onAdd: () => cart.addProduct(product),
          );
        },
      ),
    );
  }

  void _openDetails(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: product.id),
      ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.greyBackground,
        highlightColor: Colors.white,
        child: Card(child: Container(color: Colors.white)),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.products});

  final ProductProvider products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _CategoryChip(
            label: 'All',
            selected: products.selectedCategory == 'all',
            onTap: () => products.setCategory('all'),
          ),
          ...products.categories.map(
            (c) => _CategoryChip(
              label: c.name,
              selected: products.selectedCategory == c.slug,
              onTap: () => products.setCategory(c.slug),
            ),
          ),
          const VerticalDivider(),
          PopupMenuButton<ProductSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: products.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: ProductSortOption.priceLowToHigh,
                child: Text('Price: Low to High'),
              ),
              PopupMenuItem(
                value: ProductSortOption.priceHighToLow,
                child: Text('Price: High to Low'),
              ),
              PopupMenuItem(
                value: ProductSortOption.rating,
                child: Text('Rating'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.alertcolor,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
