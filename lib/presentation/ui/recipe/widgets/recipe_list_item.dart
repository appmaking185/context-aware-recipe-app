import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  const RecipeListItem({
    super.key,
    required this.recipe,
    required this.isFav,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onOpen,
      leading: Hero(
        tag: 'recipe-image-${recipe.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: recipe.image,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(recipe.name),
      subtitle: Text('${recipe.category} • ${recipe.area}'),
      trailing: InkWell(
        onTap: onToggleFavorite,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color:
                isFav ? Colors.red.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
