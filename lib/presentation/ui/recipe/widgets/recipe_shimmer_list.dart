import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecipeShimmerList extends StatelessWidget {
  const RecipeShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: const ListTile(
            leading: CircleAvatar(radius: 24, backgroundColor: Colors.white),
            title: SizedBox(height: 14, child: ColoredBox(color: Colors.white)),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8),
              child:
                  SizedBox(height: 12, child: ColoredBox(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
