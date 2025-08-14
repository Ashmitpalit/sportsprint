import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + index),
        vsync: this,
      );
    });
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 2 * math.pi,
      ).animate(controller);
    }).toList();

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(6, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Positioned(
              left: 50 + (index * 60.0),
              top: 100 + math.sin(_animations[index].value) * 30,
              child: Transform.rotate(
                angle: _animations[index].value,
                child: Container(
                  width: 12 + (index % 2) * 8.0,
                  height: 12 + (index % 2) * 8.0,
                  decoration: BoxDecoration(
                    color: _getShapeColor(index).withOpacity(0.6),
                    shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: index % 2 == 0 ? null : BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _getShapeColor(int index) {
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Yellow
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
    ];
    return colors[index % colors.length];
  }
}
