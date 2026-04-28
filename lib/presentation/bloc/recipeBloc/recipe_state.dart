part of 'recipe_bloc.dart';

sealed class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<RecipeModel> list;
  final Set<String> favoriteIds;
  final String mealType;
  final String? country;
  final bool showingOfflineData;
  final bool locationPermissionDenied;
  final bool notificationPermissionDenied;

  const RecipeLoaded(
    this.list, {
    required this.favoriteIds,
    required this.mealType,
    this.country,
    this.showingOfflineData = false,
    this.locationPermissionDenied = false,
    this.notificationPermissionDenied = false,
  });

  @override
  List<Object?> get props => [
        list,
        favoriteIds,
        mealType,
        country,
        showingOfflineData,
        locationPermissionDenied,
        notificationPermissionDenied,
      ];
}

class RecipeError extends RecipeState {
  final String message;
  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}
