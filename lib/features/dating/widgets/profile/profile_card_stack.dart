import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import 'profile_card.dart';

class ProfileCardStack extends StatefulWidget {
  const ProfileCardStack({
    super.key,
    required this.profiles,
    required this.currentIndex,
    required this.onSwipe,
    this.height,
  });

  final List<DatingProfile> profiles;
  final int currentIndex;
  final VoidCallback onSwipe;
  final double? height;

  @override
  State<ProfileCardStack> createState() => _ProfileCardStackState();
}

class _ProfileCardStackState extends State<ProfileCardStack>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  bool _isAnimatingOut = false;
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _rotateAnim;

  static const _swipeThreshold = 100.0;
  static const _maxRotation = 0.12;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _dragOffset = Offset.zero;
          _isAnimatingOut = false;
        });
        _animController.reset();
        widget.onSwipe();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimatingOut) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimatingOut) return;

    final dx = _dragOffset.dx;
    if (dx.abs() > _swipeThreshold) {
      _animateOut(dx > 0 ? 1 : -1);
    } else {
      setState(() => _dragOffset = Offset.zero);
    }
  }

  void _animateOut(int direction) {
    _isAnimatingOut = true;
    final screenWidth = MediaQuery.sizeOf(context).width;
    _slideAnim = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(direction * screenWidth * 1.5, _dragOffset.dy + 50),
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _rotateAnim = Tween<double>(
      begin: _rotation,
      end: direction * _maxRotation * 2,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward(from: 0);
  }

  double get _rotation {
    final width = MediaQuery.sizeOf(context).width;
    return (_dragOffset.dx / width) * _maxRotation * 2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex >= widget.profiles.length) {
      return SizedBox(
        height: widget.height ?? 520.h,
        child: const Center(child: Text('No more profiles')),
      );
    }

    final cardHeight = widget.height ?? 520.h;

    return SizedBox(
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.currentIndex + 1 < widget.profiles.length)
            Positioned.fill(
              child: Transform.scale(
                scale: 0.95,
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: DatingConstants.cardRadius,
                      boxShadow: DatingConstants.cardShadow,
                    ),
                    child: ProfileCard(
                      profile: widget.profiles[widget.currentIndex + 1],
                      showTopActions: false,
                      showRoseFab: false,
                    ),
                  ),
                ),
              ),
            ),
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final offset = _isAnimatingOut ? _slideAnim.value : _dragOffset;
              final rotation =
                  _isAnimatingOut ? _rotateAnim.value : _rotation;

              return Positioned.fill(
                child: Transform.translate(
                  offset: offset,
                  child: Transform.rotate(
                    angle: rotation,
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: DatingConstants.cardRadius,
                  boxShadow: DatingConstants.cardShadow,
                ),
                child: ProfileCard(
                  profile: widget.profiles[widget.currentIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
