import 'package:flutter/material.dart';

class ScaleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double scale;

  const ScaleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.scale = 0.95,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _animateDown() {
    _controller.forward();
  }

  void _animateUp() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animateDown(),
      onTapUp: (_) {
        _animateUp();
        widget.onPressed();
      },
      onTapCancel: () => _animateUp(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
        child: widget.child,
      ),
    );
  }
}