import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Simple regex for phone validation
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3 || value.length > 20) {
      return 'Username must be between 3 and 20 characters';
    }
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegExp.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Za-z]')) || !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  static String? validateLoginIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email, phone number, or username';
    }
    
    // If it looks like an email (contains @) but isn't valid
    if (value.contains('@') && !isEmail(value)) {
      return 'Please enter a valid email address';
    }
    
    // If it looks like a phone number (all digits) but isn't valid
    if (value.replaceAll(RegExp(r'\D'), '').length > 0 && 
        value.replaceAll(RegExp(r'\D'), '').length == value.length && 
        !isPhone(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    // Check if it's a valid email, phone, or username
    if (isEmail(value) || isPhone(value) || value.length >= 3) {
      return null;
    }
    
    // Generic fallback message
    return 'Please enter a valid email, phone number, or username';
  }

  static bool isEmail(String value) {
    return EmailValidator.validate(value);
  }

  static bool isPhone(String value) {
    final phoneRegExp = RegExp(r'^\d{10}$');
    return phoneRegExp.hasMatch(value);
  }
}