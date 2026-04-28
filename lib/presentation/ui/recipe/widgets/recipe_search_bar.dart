import 'package:flutter/material.dart';

class RecipeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const RecipeSearchBar({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText:
              enabled ? 'Search recipes' : 'Favorites mode (search disabled)',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
