import 'package:dartz/dartz.dart';
import 'package:ivtexsolutionsapp/core/failure.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<RecipeModel>>> searchRecipe(String query);
}
