import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.isFav,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'recipe-image-${recipe.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: recipe.image,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(recipe.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Category: ${recipe.category}'),
          Text('Cuisine: ${recipe.area}'),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(isFav ? 'Marked as favorite' : 'Not marked favorite'),
            ],
          ),
        ],
      ),
    );
  }
}
