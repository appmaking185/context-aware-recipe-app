import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/repositories/product_repository_impl.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/connectivity_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/ecommerce_auth_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/ecommerce_storage_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/location_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/product_api_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/domain/repositories/product_repository.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/auth_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/location_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ecommerceSl = GetIt.asNewInstance();

Future<void> initEcommerce() async {
  final prefs = await SharedPreferences.getInstance();
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  final storage = EcommerceStorageService();
  await storage.init();

  final authService = EcommerceAuthService(prefs: prefs);
  await authService.init(prefs);

  ecommerceSl
    ..registerSingleton<Dio>(dio)
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<EcommerceStorageService>(storage)
    ..registerSingleton<EcommerceAuthService>(authService)
    ..registerSingleton<ProductApiService>(ProductApiService(dio))
    ..registerSingleton<ProductRepository>(
      ProductRepositoryImpl(ecommerceSl<ProductApiService>()),
    )
    ..registerSingleton<ConnectivityService>(ConnectivityService())
    ..registerSingleton<EcommerceLocationService>(EcommerceLocationService())
    ..registerFactory<AuthProvider>(
      () => AuthProvider(ecommerceSl<EcommerceAuthService>()),
    )
    ..registerFactory<ConnectivityProvider>(
      () => ConnectivityProvider(ecommerceSl<ConnectivityService>()),
    )
    ..registerFactory<LocationProvider>(
      () => LocationProvider(ecommerceSl<EcommerceLocationService>()),
    )
    ..registerFactory<CartProvider>(
      () => CartProvider(ecommerceSl<EcommerceStorageService>())..loadCart(),
    )
    ..registerFactory<ProductProvider>(
      () => ProductProvider(
        repository: ecommerceSl<ProductRepository>(),
        storage: ecommerceSl<EcommerceStorageService>(),
      ),
    );
}
