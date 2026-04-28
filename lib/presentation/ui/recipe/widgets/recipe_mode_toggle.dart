import 'package:flutter/material.dart';

class RecipeModeToggle extends StatelessWidget {
  final bool showingFavorites;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectFavorites;

  const RecipeModeToggle({
    super.key,
    required this.showingFavorites,
    required this.onSelectAll,
    required this.onSelectFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: !showingFavorites,
            onSelected: (_) => onSelectAll(),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Favorites'),
            selected: showingFavorites,
            onSelected: (_) => onSelectFavorites(),
          ),
        ],
      ),
    );
  }
}
