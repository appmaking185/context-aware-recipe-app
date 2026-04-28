import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/data/model/recipe_model.dart';
import 'package:ivtexsolutionsapp/data/services/cache_service.dart';
import 'package:ivtexsolutionsapp/data/services/fav_service.dart';
import 'package:ivtexsolutionsapp/data/services/location_context_service.dart';
import 'package:ivtexsolutionsapp/data/services/meal_notification_service.dart';
import 'package:ivtexsolutionsapp/data/services/time_service.dart';
import 'package:ivtexsolutionsapp/domain/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repo;
  final CacheService cache;
  final FavoriteService favoriteService;
  final LocationContextService locationContextService;
  final MealNotificationService mealNotificationService;
  final TimeService timeService;

  Timer? _debounce;
  int _searchSeq = 0;
  String _lastMealType = 'Breakfast';
  String? _lastCountry;
  bool _locationPermissionDenied = false;
  bool _notificationPermissionDenied = false;

  RecipeBloc(
    this.repo,
    this.cache, {
    required this.favoriteService,
    required this.locationContextService,
    required this.mealNotificationService,
    required this.timeService,
  }) : super(RecipeInitial()) {
    on<SearchRecipeEvent>(_onSearch);
    on<LoadInitialEvent>(_onLoadInitial);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<OpenRecipeDetailEvent>(_onOpenRecipeDetail);
    on<LoadFavoriteRecipesEvent>(_onLoadFavoriteRecipes);
  }

  Future<void> _onSearch(
    SearchRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    _debounce?.cancel();
    _searchSeq++;
    final seq = _searchSeq;
    final query = event.query.trim();

    debugPrint('[RecipeBloc] Search input received: "$query"');

    if (query.isEmpty) {
      debugPrint('[RecipeBloc] Empty query, reloading initial.');
      add(LoadInitialEvent());
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (emit.isDone || seq != _searchSeq) {
      debugPrint('[RecipeBloc] Search cancelled (newer query arrived).');
      return;
    }

    emit(RecipeLoading());
    debugPrint('[RecipeBloc] Debounce complete, searching API...');

    final res = await repo.searchRecipe(query);
    if (emit.isDone || seq != _searchSeq) return;

    res.fold(
      (l) {
        debugPrint('[RecipeBloc] Search failed: ${l.error}');
        final cached = cache.getSearch(query);
        if (cached.isNotEmpty) {
          debugPrint(
            '[RecipeBloc] Showing cached search results. count=${cached.length}',
          );
          emit(_buildLoadedState(cached, showingOfflineData: true));
        } else {
          final fallback = cache.get();
          if (fallback.isNotEmpty) {
            debugPrint(
              '[RecipeBloc] Showing fallback cache results. count=${fallback.length}',
            );
            emit(_buildLoadedState(fallback, showingOfflineData: true));
          } else {
            emit(RecipeError(l.error));
          }
        }
      },
      (r) {
        debugPrint('[RecipeBloc] Search success. count=${r.length}');
        cache.saveSearch(query, r);
        emit(_buildLoadedState(_prioritizeByCountry(r)));
      },
    );
  }

  Future<void> _onLoadInitial(
    LoadInitialEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    debugPrint('[RecipeBloc] Loading initial recipes...');

    _lastMealType = timeService.getMealType();
    final context = await locationContextService.getCountryContext();
    _lastCountry = context.country;
    _locationPermissionDenied = context.permissionDenied;
    debugPrint(
      '[RecipeBloc] Context => mealType=$_lastMealType, country=$_lastCountry, locationDenied=$_locationPermissionDenied',
    );

    final res = await repo.searchRecipe(_lastMealType);
    final sourceData = res.fold<List<RecipeModel>>(
      (l) {
        debugPrint('[RecipeBloc] Initial API failed: ${l.error}');
        final cached = cache.get();
        final favorites = favoriteService.getFavorites();
        return cached.isNotEmpty ? cached : favorites;
      },
      (r) {
        final prioritized = _prioritizeByCountry(r);
        debugPrint(
          '[RecipeBloc] Initial API success. count=${prioritized.length}',
        );
        return prioritized;
      },
    );

    final suggestions = _prepareMealSuggestions(sourceData);
    final notificationResult = await mealNotificationService
        .scheduleDailyMealNotifications(
          breakfastSuggestion: suggestions.$1,
          lunchSuggestion: suggestions.$2,
          dinnerSuggestion: suggestions.$3,
        );
    _notificationPermissionDenied = notificationResult.permissionDenied;
    debugPrint(
      '[RecipeBloc] Notifications scheduled. denied=$_notificationPermissionDenied',
    );

    if (emit.isDone) return;

    res.fold(
      (l) {
        if (sourceData.isNotEmpty) {
          debugPrint(
            '[RecipeBloc] Showing offline data. count=${sourceData.length}',
          );
          emit(
            _buildLoadedState(
              _prioritizeByCountry(sourceData),
              showingOfflineData: true,
            ),
          );
        } else {
          emit(RecipeError(l.error));
        }
      },
      (r) {
        final prioritized = _prioritizeByCountry(r);
        cache.save(prioritized);
        emit(_buildLoadedState(prioritized));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    favoriteService.toggle(event.recipe);
    debugPrint('[RecipeBloc] Favorite toggled. recipeId=${event.recipe.id}');

    if (state is RecipeLoaded) {
      final current = state as RecipeLoaded;
      emit(
        RecipeLoaded(
          current.list,
          favoriteIds: favoriteService.getFavoriteIds(),
          mealType: current.mealType,
          country: current.country,
          showingOfflineData: current.showingOfflineData,
          locationPermissionDenied: current.locationPermissionDenied,
          notificationPermissionDenied: current.notificationPermissionDenied,
        ),
      );
    }
  }

  Future<void> _onOpenRecipeDetail(
    OpenRecipeDetailEvent event,
    Emitter<RecipeState> emit,
  ) async {
    cache.saveViewedRecipe(event.recipe);
  }

  Future<void> _onLoadFavoriteRecipes(
    LoadFavoriteRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final favorites = favoriteService.getFavorites();
    debugPrint('[RecipeBloc] Loading favorites. count=${favorites.length}');
    emit(_buildLoadedState(favorites, showingOfflineData: true));
  }

  List<RecipeModel> _prioritizeByCountry(List<RecipeModel> list) {
    if ((_lastCountry ?? '').trim().isEmpty) return list;

    final target = _lastCountry!.toLowerCase().trim();
    final sorted = [...list];
    sorted.sort((a, b) {
      final aMatch = a.area.toLowerCase().contains(target);
      final bMatch = b.area.toLowerCase().contains(target);
      if (aMatch == bMatch) return 0;
      return aMatch ? -1 : 1;
    });
    return sorted;
  }

  RecipeLoaded _buildLoadedState(
    List<RecipeModel> list, {
    bool showingOfflineData = false,
  }) {
    return RecipeLoaded(
      list,
      favoriteIds: favoriteService.getFavoriteIds(),
      mealType: _lastMealType,
      country: _lastCountry,
      showingOfflineData: showingOfflineData,
      locationPermissionDenied: _locationPermissionDenied,
      notificationPermissionDenied: _notificationPermissionDenied,
    );
  }

  (String?, String?, String?) _prepareMealSuggestions(List<RecipeModel> list) {
    String? breakfast;
    String? lunch;
    String? dinner;

    for (final item in list) {
      final category = item.category.toLowerCase();
      breakfast ??= category.contains('breakfast') ? item.name : null;
      lunch ??= category.contains('lunch') ? item.name : null;
      dinner ??= category.contains('dinner') ? item.name : null;
    }

    breakfast ??= list.isNotEmpty ? list.first.name : null;
    lunch ??= list.length > 1 ? list[1].name : breakfast;
    dinner ??= list.length > 2 ? list[2].name : lunch ?? breakfast;

    return (breakfast, lunch, dinner);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

/*
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:unite_flutter/data/model/recipe_model.dart';
import 'package:unite_flutter/data/services/cache_service.dart';
import 'package:unite_flutter/data/services/fav_service.dart';
import 'package:unite_flutter/data/services/location_context_service.dart';
import 'package:unite_flutter/data/services/meal_notification_service.dart';
import 'package:unite_flutter/data/services/time_service.dart';
import 'package:unite_flutter/domain/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repo;
  final CacheService cache;
  final FavoriteService favoriteService;
  final LocationContextService locationContextService;
  final MealNotificationService mealNotificationService;
  final TimeService timeService;

  Timer? _debounce;
  int _searchSeq = 0;
  String _lastMealType = 'Breakfast';
  String? _lastCountry;
  bool _locationPermissionDenied = false;
  bool _notificationPermissionDenied = false;

  RecipeBloc(
    this.repo,
    this.cache, {
    required this.favoriteService,
    required this.locationContextService,
    required this.mealNotificationService,
    required this.timeService,
  }) : super(RecipeInitial()) {
    on<SearchRecipeEvent>(_onSearch);
    on<LoadInitialEvent>(_onLoadInitial);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<OpenRecipeDetailEvent>(_onOpenRecipeDetail);
    on<LoadFavoriteRecipesEvent>(_onLoadFavoriteRecipes);
  }

  Future<void> _onSearch(
      SearchRecipeEvent event, Emitter<RecipeState> emit) async {
    _debounce?.cancel();
    _searchSeq++;
    final seq = _searchSeq;
    final query = event.query.trim();

    debugPrint('[RecipeBloc] Search input received: "$query"');

    if (query.isEmpty) {
      debugPrint('[RecipeBloc] Empty query, reloading initial.');
      add(LoadInitialEvent());
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (emit.isDone || seq != _searchSeq) {
      debugPrint('[RecipeBloc] Search cancelled (newer query arrived).');
      return;
    }

    emit(RecipeLoading());
    debugPrint('[RecipeBloc] Debounce complete, searching API...');

    final res = await repo.searchRecipe(query);
    if (emit.isDone || seq != _searchSeq) return;

    res.fold(
      (l) {
        debugPrint('[RecipeBloc] Search failed: ${l.error}');
        final cached = cache.getSearch(query);
        if (cached.isNotEmpty) {
          debugPrint(
              '[RecipeBloc] Showing cached search results. count=${cached.length}');
          emit(_buildLoadedState(cached, showingOfflineData: true));
        } else {
          final fallback = cache.get();
          if (fallback.isNotEmpty) {
            debugPrint(
                '[RecipeBloc] Showing fallback cache results. count=${fallback.length}');
            emit(_buildLoadedState(fallback, showingOfflineData: true));
          } else {
            emit(RecipeError(l.error));
          }
        }
      },
      (r) {
        debugPrint('[RecipeBloc] Search success. count=${r.length}');
        cache.saveSearch(query, r);
        emit(_buildLoadedState(_prioritizeByCountry(r)));
      },
    );
  }

  Future<void> _onLoadInitial(
      LoadInitialEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    debugPrint('[RecipeBloc] Loading initial recipes...');

    _lastMealType = timeService.getMealType();
    final context = await locationContextService.getCountryContext();
    _lastCountry = context.country;
    _locationPermissionDenied = context.permissionDenied;
    debugPrint(
        '[RecipeBloc] Context => mealType=$_lastMealType, country=$_lastCountry, locationDenied=$_locationPermissionDenied');

    final res = await repo.searchRecipe(_lastMealType);
    final sourceData = res.fold<List<RecipeModel>>(
      (l) {
        debugPrint('[RecipeBloc] Initial API failed: ${l.error}');
        final cached = cache.get();
        final favorites = favoriteService.getFavorites();
        return cached.isNotEmpty ? cached : favorites;
      },
      (r) {
        final prioritized = _prioritizeByCountry(r);
        debugPrint(
            '[RecipeBloc] Initial API success. count=${prioritized.length}');
        return prioritized;
      },
    );

    final suggestions = _prepareMealSuggestions(sourceData);
    final notificationResult =
        await mealNotificationService.scheduleDailyMealNotifications(
      breakfastSuggestion: suggestions.$1,
      lunchSuggestion: suggestions.$2,
      dinnerSuggestion: suggestions.$3,
    );
    _notificationPermissionDenied = notificationResult.permissionDenied;
    debugPrint(
      '[RecipeBloc] Notifications scheduled. denied=$_notificationPermissionDenied',
    );

    if (emit.isDone) return;

    res.fold(
      (l) {
        if (sourceData.isNotEmpty) {
          debugPrint(
              '[RecipeBloc] Showing offline data. count=${sourceData.length}');
          emit(_buildLoadedState(
            _prioritizeByCountry(sourceData),
            showingOfflineData: true,
          ));
        } else {
          emit(RecipeError(l.error));
        }
      },
      (r) {
        final prioritized = _prioritizeByCountry(r);
        cache.save(prioritized);
        emit(_buildLoadedState(prioritized));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    favoriteService.toggle(event.recipe);
    debugPrint('[RecipeBloc] Favorite toggled. recipeId=${event.recipe.id}');

    if (state is RecipeLoaded) {
      final current = state as RecipeLoaded;
      emit(RecipeLoaded(
        current.list,
        favoriteIds: favoriteService.getFavoriteIds(),
        mealType: current.mealType,
        country: current.country,
        showingOfflineData: current.showingOfflineData,
        locationPermissionDenied: current.locationPermissionDenied,
        notificationPermissionDenied: current.notificationPermissionDenied,
      ));
    }
  }

  Future<void> _onOpenRecipeDetail(
    OpenRecipeDetailEvent event,
    Emitter<RecipeState> emit,
  ) async {
    cache.saveViewedRecipe(event.recipe);
  }

  Future<void> _onLoadFavoriteRecipes(
    LoadFavoriteRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final favorites = favoriteService.getFavorites();
    debugPrint('[RecipeBloc] Loading favorites. count=${favorites.length}');
    emit(_buildLoadedState(
      favorites,
      showingOfflineData: true,
    ));
  }

  List<RecipeModel> _prioritizeByCountry(List<RecipeModel> list) {
    if ((_lastCountry ?? '').trim().isEmpty) return list;

    final target = _lastCountry!.toLowerCase().trim();
    final sorted = [...list];
    sorted.sort((a, b) {
      final aMatch = a.area.toLowerCase().contains(target);
      final bMatch = b.area.toLowerCase().contains(target);
      if (aMatch == bMatch) return 0;
      return aMatch ? -1 : 1;
    });
    return sorted;
  }

  RecipeLoaded _buildLoadedState(
    List<RecipeModel> list, {
    bool showingOfflineData = false,
  }) {
    return RecipeLoaded(
      list,
      favoriteIds: favoriteService.getFavoriteIds(),
      mealType: _lastMealType,
      country: _lastCountry,
      showingOfflineData: showingOfflineData,
      locationPermissionDenied: _locationPermissionDenied,
      notificationPermissionDenied: _notificationPermissionDenied,
    );
  }

  (String?, String?, String?) _prepareMealSuggestions(List<RecipeModel> list) {
    String? breakfast;
    String? lunch;
    String? dinner;

    for (final item in list) {
      final category = item.category.toLowerCase();
      breakfast ??= category.contains('breakfast') ? item.name : null;
      lunch ??= category.contains('lunch') ? item.name : null;
      dinner ??= category.contains('dinner') ? item.name : null;
    }

    breakfast ??= list.isNotEmpty ? list.first.name : null;
    lunch ??= list.length > 1 ? list[1].name : breakfast;
    dinner ??= list.length > 2 ? list[2].name : lunch ?? breakfast;

    return (breakfast, lunch, dinner);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
*/
