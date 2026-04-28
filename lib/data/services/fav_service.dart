import 'package:hive_ce_flutter/adapters.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';

class FavoriteService {
  final box = Hive.box('favorites');

  void toggle(RecipeModel r) {
    if (box.containsKey(r.id)) {
      box.delete(r.id);
    } else {
      box.put(r.id, r.toJson());
    }
  }

  List<RecipeModel> getFavorites() {
    return box.values
        .map((e) => RecipeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  bool isFavorite(String recipeId) => box.containsKey(recipeId);

  Set<String> getFavoriteIds() {
    return box.keys.map((key) => key.toString()).toSet();
  }
}
