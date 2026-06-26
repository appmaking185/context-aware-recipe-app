import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/features/dating/presentation/screens/dating_home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  int animationDuration = 500;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: DatingHomeRoute.page,
      initial: true,
    ),
  ];
}

// Enum for all available transitions
enum RouteTransition {
  fade, // Fade transition
  slide, // Slide from the right
  slideLeft, // Slide from the left
  slideUp, // Slide from the bottom
  slideDown, // Slide from the top
  scale, // Scale (zoom in/out)
  rotation, // Rotation
  combined, // Slide + Fade
  zoomIn, // Zoom In
  zoomOut, // Zoom Out
  bounce, // Bounce transition
  flip, // Flip along the Y-axis
}

// Default Transition Type
const RouteTransition defaultTransitionType = RouteTransition.combined;

// Custom Transition Builder
Widget customTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child, {
  RouteTransition transitionType = defaultTransitionType,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    // Use default iOS transition to enable swipe back gesture
    return child;
  }

  // Custom transitions for other platforms
  switch (transitionType) {
    case RouteTransition.slide:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // Slide from the right
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

    case RouteTransition.slideLeft:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0), // Slide from the left
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

    case RouteTransition.slideUp:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // Slide from the bottom
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

    case RouteTransition.slideDown:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1), // Slide from the top
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

    case RouteTransition.scale:
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );

    case RouteTransition.rotation:
      return RotationTransition(
        turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: child,
      );

    case RouteTransition.combined:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // Slide from the right
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      );

    case RouteTransition.zoomIn:
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );

    case RouteTransition.zoomOut:
      return ScaleTransition(
        scale: Tween<double>(
          begin: 1.5,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );

    case RouteTransition.bounce:
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.bounceIn),
        child: child,
      );

    case RouteTransition.flip:
      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final double value = animation.value;
          final Matrix4 transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(3.14 * (1 - value)); // Flip along the Y-axis
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: child,
          );
        },
      );

    case RouteTransition.fade:
      return FadeTransition(opacity: animation, child: child);
  }
}
