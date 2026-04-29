import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';
import 'package:ivtexsolutionsapp/presentation/bloc/recipeBloc/recipe_bloc.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/recipe_list_item.dart';

class RecipeLoadedView extends StatelessWidget {
  final RecipeLoaded state;
  final void Function(RecipeModel recipe, bool isFav) onOpenRecipe;
  final void Function(RecipeModel recipe) onToggleFavorite;

  const RecipeLoadedView({
    super.key,
    required this.state,
    required this.onOpenRecipe,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.list.length,
      itemBuilder: (context, index) {
        final recipe = state.list[index];
        final isFav = state.favoriteIds.contains(recipe.id);
        return RecipeListItem(
          recipe: recipe,
          isFav: isFav,
          onOpen: () => onOpenRecipe(recipe, isFav),
          onToggleFavorite: () => onToggleFavorite(recipe),
        );
      },
    );
  }
}
