import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/product_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/product_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/cart_screen.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/product_detail_screen.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/widgets/error_retry_view.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/widgets/offline_banner.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/widgets/offline_cached_banner.dart';
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
            if (products.isShowingCachedData) const OfflineCachedBanner(),
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
      return ErrorRetryView(
        message: products.errorMessage ?? 'Something went wrong',
        onRetry: () => _retryProducts(context, products),
      );
    }

    if (products.products.isEmpty) {
      return ErrorRetryView(
        message: 'No products found. Try another search or category.',
        icon: Icons.inventory_2_outlined,
        onRetry: () => _retryProducts(context, products),
      );
    }

    return RefreshIndicator(
      onRefresh: products.refreshProducts,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products.products[index];

                return ProductCard(
                  product: product,
                  cartQuantity: cart.quantityForProduct(product.id),
                  onTap: () => _openDetails(product),
                  onAdd: () => cart.addProduct(product),
                );
              }, childCount: products.products.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 325,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),

          /// Footer Full Width
          SliverToBoxAdapter(child: _buildListFooter(context, products)),
        ],
      ),
    );
    
  }

  void _retryProducts(BuildContext context, ProductProvider products) {
    context.read<ConnectivityProvider>().refresh();
    products.refreshProducts();
  }

  Widget _buildListFooter(BuildContext context, ProductProvider products) {
    if (products.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (products.errorMessage != null && products.products.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                products.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.alertcolor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: products.loadMore,
                child: const Text('Retry load more'),
              ),
            ],
          ),
        ),
      );
    }

    if (!products.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('End of list')),
      );
    }

    return const SizedBox.shrink();
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
      itemBuilder: (_, _) => Shimmer.fromColors(
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
