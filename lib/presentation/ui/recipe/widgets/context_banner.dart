import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/presentation/bloc/recipeBloc/recipe_bloc.dart';

class ContextBanner extends StatelessWidget {
  final RecipeLoaded state;
  final VoidCallback? onOpenSettings;

  const ContextBanner({
    super.key,
    required this.state,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final notes = <String>[
      'Meal: ${state.mealType}',
      if ((state.country ?? '').isNotEmpty) 'Location: ${state.country}',
      if (state.showingOfflineData) 'Showing offline content',
      if (state.locationPermissionDenied) 'Location permission denied',
      if (state.notificationPermissionDenied) 'Notification permission denied',
    ];

    return Container(
      width: double.infinity,
      color: Colors.black12,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              notes.join(' | '),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (state.locationPermissionDenied || state.notificationPermissionDenied)
            TextButton(
              onPressed: onOpenSettings,
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }
}
