import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../theme/dating_colors.dart';

class RoseFab extends StatefulWidget {
  const RoseFab({
    super.key,
    this.onTap,
    this.size,
  });

  final VoidCallback? onTap;
  final double? size;

  @override
  State<RoseFab> createState() => _RoseFabState();
}

class _RoseFabState extends State<RoseFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? DatingConstants.roseButtonSize.w;

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: DatingColors.cardWhite,
            shape: BoxShape.circle,
            boxShadow: DatingConstants.roseGlow,
          ),
          child: Center(
            child: Text(
              '🌹',
              style: TextStyle(fontSize: 22.sp),
            ),
          ),
        ),
      ),
    );
  }
}

class RoseIconSmall extends StatelessWidget {
  const RoseIconSmall({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 32.w,
      height: size ?? 32.w,
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        shape: BoxShape.circle,
        boxShadow: DatingConstants.softShadow,
      ),
      child: Center(
        child: Text('🌹', style: TextStyle(fontSize: 14.sp)),
      ),
    );
  }
}
