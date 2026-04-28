import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/core/either_extension_function.dart';
import 'package:ivtexsolutionsapp/core/failure.dart';
import 'package:ivtexsolutionsapp/data/apiService/base_api_service.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';
import 'package:ivtexsolutionsapp/domain/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final BaseAPIService baseAPIService;

  RecipeRepositoryImpl({required this.baseAPIService});

  @override
  Future<Either<Failure, List<RecipeModel>>> searchRecipe(String query) async {
    final normalized = query.trim();
    debugPrint('[RecipeAPI] searchRecipe called. query="$normalized"');
    try {
      final res = await baseAPIService.executeAPI(
        url: "https://www.themealdb.com/api/json/v1/1/search.php",
        queryParameters: {"s": normalized},
        isClientToken: false,
        apiType: ApiType.GET,
      );

      if (res.isLeft()) {
        final error = res.getLeft()!.error;
        debugPrint('[RecipeAPI] request failed. error="$error"');
        return left(Failure(error));
      }

      final data = res.getRight();
      final meals = data['meals'] as List?;

      if (meals == null) {
        debugPrint('[RecipeAPI] success but no meals found.');
        return right([]);
      }

      final list = meals.map((e) => RecipeModel.fromJson(e)).toList();
      debugPrint('[RecipeAPI] success. totalMeals=${list.length}');

      return right(list);
    } catch (e) {
      debugPrint('[RecipeAPI] unexpected exception: $e');
      return left(const Failure('Unexpected Error'));
    }
  }
}
