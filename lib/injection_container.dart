import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ivtexsolutionsapp/data/respositoryImpl/repository_recipe_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/apiService/base_api_service.dart';
import 'data/apiService/network_api_service.dart';
import 'data/services/cache_service.dart';
import 'data/services/fav_service.dart';
import 'data/services/location_context_service.dart';
import 'data/services/meal_notification_service.dart';
import 'data/services/time_service.dart';
import 'domain/recipe_repository.dart';
import 'presentation/bloc/recipeBloc/recipe_bloc.dart';
import 'routes/app_router.dart';

final sl = GetIt.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> init() async {
  //! External /* All the other required external injection are embedded here */
  await _initExternalDependencies();

  // Repository /* All the repository injection are embedded here */
  await _initRepositories();

  // Bloc /* All the bloc injection are embedded here */
  await _initBlocs();

  //cubit inject for small and effective ui updates
  await _initCubits();
}

Future<void> _initBlocs() async {
  //Add Blocs

  sl.registerFactory(
    () => RecipeBloc(
      sl<RecipeRepository>(),
      sl<CacheService>(),
      favoriteService: sl<FavoriteService>(),
      locationContextService: sl<LocationContextService>(),
      mealNotificationService: sl<MealNotificationService>(),
      timeService: sl<TimeService>(),
    ),
  );
}

Future<void> _initCubits() async {
  //Add Cubits.
}

Future<void> _initRepositories() async {
  //Api Service
  sl.registerLazySingleton<BaseAPIService>(() => NetworkAPIService(sl(), sl()));
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(baseAPIService: sl()));
}
  Future<void> _initExternalDependencies() async {
    sl.registerLazySingleton(() => AppRouter());

    final dio = Dio();
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    sl.registerLazySingleton(() => dio);

    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
    sl.registerLazySingleton(() => CacheService());
    sl.registerLazySingleton(() => FavoriteService());
    sl.registerLazySingleton(() => LocationContextService());
    sl.registerLazySingleton(() => MealNotificationService());
    sl.registerLazySingleton(() => TimeService());
    // sl.registerLazySingleton(() => LocationManager(sl()));
  }
