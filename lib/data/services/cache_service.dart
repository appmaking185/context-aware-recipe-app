import 'package:hive_ce_flutter/adapters.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';

class CacheService {
  final box = Hive.box('cache');

  void save(List<RecipeModel> list, {String key = 'recipes'}) {
    box.put(key, list.map((e) => e.toJson()).toList());
  }

  List<RecipeModel> get({String key = 'recipes'}) {
    final data = box.get(key, defaultValue: []);

    return List.from(data)
        .map((e) => RecipeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void saveSearch(String query, List<RecipeModel> list) {
    save(list, key: 'search_${query.toLowerCase()}');
  }

  List<RecipeModel> getSearch(String query) {
    return get(key: 'search_${query.toLowerCase()}');
  }

  void saveViewedRecipe(RecipeModel recipe) {
    box.put('viewed_${recipe.id}', recipe.toJson());
  }

  List<RecipeModel> getViewedRecipes() {
    final viewedEntries = box.toMap().entries.where(
          (entry) => entry.key.toString().startsWith('viewed_'),
        );

    return viewedEntries
        .map((entry) =>
            RecipeModel.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();
  }
}
