// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivtexsolutionsapp/data/services/app_permissions_service.dart';
import 'package:ivtexsolutionsapp/data/services/meal_notification_service.dart';
import 'package:ivtexsolutionsapp/presentation/bloc/recipeBloc/recipe_bloc.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/recipe_detail_page.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/context_banner.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/empty_state.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/recipe_loaded_view.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/recipe_mode_toggle.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/recipe_search_bar.dart';
import 'package:ivtexsolutionsapp/presentation/ui/recipe/widgets/recipe_shimmer_list.dart';

@RoutePage()
class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({super.key});

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showingFavorites = false;
  bool _openedSettingsFromBanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    context.read<RecipeBloc>().add(LoadInitialEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Context Aware Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: () async {
              final service = MealNotificationService();
              await service.scheduleQuickMealTestNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Notification will arrive in about 30 seconds. Please wait...',
                  ),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            RecipeSearchBar(
              controller: _searchController,
              enabled: !_showingFavorites,
              onChanged: (value) => context.read<RecipeBloc>().add(
                SearchRecipeEvent(value.trim()),
              ),
            ),
            RecipeModeToggle(
              showingFavorites: _showingFavorites,
              onSelectAll: () {
                setState(() => _showingFavorites = false);
                context.read<RecipeBloc>().add(LoadInitialEvent());
              },
              onSelectFavorites: () {
                setState(() => _showingFavorites = true);
                context.read<RecipeBloc>().add(LoadFavoriteRecipesEvent());
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoading) {
                    return const RecipeShimmerList();
                  }
                  if (state is RecipeError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is RecipeLoaded) {
                    if (_showingFavorites && state.list.isEmpty) {
                      return const EmptyState(
                        message:
                            'No favorites yet. Tap heart on recipes to save them.',
                      );
                    }
                    return Column(
                      children: [
                        ContextBanner(
                          state: state,
                          onOpenSettings: _openSettingsWithRefresh,
                        ),
                        Expanded(
                          child: RecipeLoadedView(
                            state: state,
                            onOpenRecipe: (recipe, isFav) {
                              context.read<RecipeBloc>().add(
                                OpenRecipeDetailEvent(recipe),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailPage(
                                    recipe: recipe,
                                    isFav: isFav,
                                  ),
                                ),
                              );
                            },
                            onToggleFavorite: (recipe) {
                              context.read<RecipeBloc>().add(
                                ToggleFavoriteEvent(recipe),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettingsWithRefresh() async {
    _openedSettingsFromBanner = await AppPermissionsService.openSettings();
  }

  late final WidgetsBindingObserver _lifecycleObserver = _RecipeLifecycleObserver(
    onResume: () {
      if (!_openedSettingsFromBanner || !mounted) return;
      _openedSettingsFromBanner = false;
      context.read<RecipeBloc>().add(LoadInitialEvent());
    },
  );

  // UI widgets are separated under `lib/presentation/ui/recipe/widgets/`.
}

class _RecipeLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;

  _RecipeLifecycleObserver({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
