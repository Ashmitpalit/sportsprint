import 'package:flutter/material.dart';

class AppConstants {
  // App name
  static const String appName = "SportLink";
  static const String appTagline = "Connect. Play. Win.";
  
  // Colors
  static const Color primaryColor = Color(0xFF0066CC); // Bright blue for buttons
  static const Color secondaryColor = Color(0xFF1E3A8A); // Dark blue for headings
  static const Color backgroundColor = Color(0xFFF8FAFC); // Light background
  static const Color cardBackgroundColor = Colors.white; // White for content areas
  static const Color textBoxColor = Colors.white; // White text boxes
  static const Color textBoxBorderColor = Color(0xFFE2E8F0); // Light gray borders
  static const Color errorColor = Color(0xFFE53935);
  static const Color textColor = Color(0xFF1E293B); // Dark text color
  
  // Spacing
  static const double horizontalPadding = 24.0;
  static const double fieldSpacing = 24.0;
  static const double sectionSpacing = 40.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 48.0;
  static const double maxContentWidth = 440.0;
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );
  
  static const TextStyle taglineStyle = TextStyle(
    fontSize: 16.0,
    color: Color(0xFF64748B),
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle inputLabelStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 12.0,
    color: errorColor,
  );
  
  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 14.0,
    color: primaryColor,
    fontWeight: FontWeight.w500,
  );
}