import 'package:flutter/material.dart';
import 'dart:math' as math;

class AuthIllustration extends StatelessWidget {
  final String type; // 'login' or 'signup'
  
  const AuthIllustration({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Background decorative elements
          ...List.generate(8, (index) {
            return Positioned(
              left: (index * 40.0) % 200,
              top: (index * 30.0) % 100,
              child: Container(
                width: 8 + (index % 3) * 4.0,
                height: 8 + (index % 3) * 4.0,
                decoration: BoxDecoration(
                  color: _getColor(index),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          
          // Main illustration
          Center(
            child: type == 'login' ? _buildLoginIllustration() : _buildSignupIllustration(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginIllustration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // User figure
        Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // Lock/security element
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lock_open,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupIllustration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First user figure
        Container(
          width: 35,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        // Connection line
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 8),
        // Second user figure
        Container(
          width: 35,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        // Success checkmark
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Yellow
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Purple
    ];
    return colors[index % colors.length];
  }
}
