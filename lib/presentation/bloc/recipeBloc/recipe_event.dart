part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class SearchRecipeEvent extends RecipeEvent {
  final String query;
  const SearchRecipeEvent(this.query);
}

class LoadInitialEvent extends RecipeEvent {}

class ToggleFavoriteEvent extends RecipeEvent {
  final RecipeModel recipe;
  const ToggleFavoriteEvent(this.recipe);
}

class OpenRecipeDetailEvent extends RecipeEvent {
  final RecipeModel recipe;
  const OpenRecipeDetailEvent(this.recipe);
}

class LoadFavoriteRecipesEvent extends RecipeEvent {}
