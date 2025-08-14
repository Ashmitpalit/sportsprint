import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/oauth_button.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/floating_shapes.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _termsAccepted = false;
  bool _isGoogleLoading = false;
  String? _emailOrPhoneError;
  String? _fullNameError;
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Validate email or phone
      final emailOrPhone = _emailOrPhoneController.text;
      if (emailOrPhone.isEmpty) {
        _emailOrPhoneError = 'Email or phone number is required';
      } else if (Validators.isEmail(emailOrPhone)) {
        _emailOrPhoneError = Validators.validateEmail(emailOrPhone);
      } else if (Validators.isPhone(emailOrPhone)) {
        _emailOrPhoneError = Validators.validatePhone(emailOrPhone);
      } else {
        _emailOrPhoneError = 'Please enter a valid email or phone number';
      }

      // Validate full name
      _fullNameError = Validators.validateFullName(_fullNameController.text);

      // Validate username
      _usernameError = Validators.validateUsername(_usernameController.text);

      // Validate password
      _passwordError = Validators.validatePassword(_passwordController.text);
    });
  }

  bool get _isFormValid {
    return _emailOrPhoneError == null &&
        _fullNameError == null &&
        _usernameError == null &&
        _passwordError == null &&
        _termsAccepted;
  }

  Future<void> _signUp() async {
    _validateForm();
    
    if (!_isFormValid) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final result = await authService.signUp(
      emailOrPhone: _emailOrPhoneController.text,
      fullName: _fullNameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );
    
    if (result.success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        if (result.errorMessage?.contains('Username') ?? false) {
          setState(() {
            _usernameError = result.errorMessage;
          });
        } else {
          Fluttertoast.showToast(
            msg: result.errorMessage ?? 'An error occurred',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppConstants.errorColor,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });
    
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final result = await authService.signInWithGoogle();
    
    setState(() {
      _isGoogleLoading = false;
    });
    
    if (result.success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        Fluttertoast.showToast(
          msg: result.errorMessage ?? 'Google sign-in was cancelled',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppConstants.errorColor,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          // Floating shapes background
          const Positioned.fill(
            child: FloatingShapes(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                  vertical: 24.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppConstants.maxContentWidth,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: AppConstants.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // App name and tagline
                          Text(
                            AppConstants.appName,
                            style: AppConstants.headingStyle,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppConstants.appTagline,
                            style: AppConstants.taglineStyle,
                          ),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Signup illustration
                          const AuthIllustration(type: 'signup'),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Google OAuth button
                          OAuthButton(
                            text: 'Sign up with Google',
                            onPressed: _signInWithGoogle,
                            isLoading: _isGoogleLoading,
                          ),
                          
                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Row(
                              children: [
                                Expanded(child: Divider(color: AppConstants.textBoxBorderColor)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text('or', style: TextStyle(color: AppConstants.taglineStyle.color)),
                                ),
                                Expanded(child: Divider(color: AppConstants.textBoxBorderColor)),
                              ],
                            ),
                          ),
                          
                          // Email or Phone field
                          CustomTextField(
                            label: 'Email or Phone Number',
                            controller: _emailOrPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailOrPhoneError,
                            prefixIcon: const Icon(Icons.email, color: AppConstants.textColor),
                          ),
                          const SizedBox(height: AppConstants.fieldSpacing),
                          
                          // Full Name field
                          CustomTextField(
                            label: 'Full Name',
                            controller: _fullNameController,
                            errorText: _fullNameError,
                            prefixIcon: const Icon(Icons.person, color: AppConstants.textColor),
                          ),
                          const SizedBox(height: AppConstants.fieldSpacing),
                          
                          // Username field
                          CustomTextField(
                            label: 'Username',
                            controller: _usernameController,
                            errorText: _usernameError,
                            prefixIcon: const Icon(Icons.account_circle, color: AppConstants.textColor),
                          ),
                          const SizedBox(height: AppConstants.fieldSpacing),
                          
                          // Password field
                          CustomTextField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            errorText: _passwordError,
                            prefixIcon: const Icon(Icons.lock, color: AppConstants.textColor),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility, color: AppConstants.textColor),
                              onPressed: () {
                                // TODO: Implement password visibility toggle
                              },
                            ),
                          ),
                          const SizedBox(height: AppConstants.fieldSpacing),
                          
                          // Terms and conditions
                          Row(
                            children: [
                              Checkbox(
                                value: _termsAccepted,
                                onChanged: (value) {
                                  setState(() {
                                    _termsAccepted = value ?? false;
                                  });
                                },
                                activeColor: AppConstants.primaryColor,
                                checkColor: Colors.white,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: AppConstants.taglineStyle.color, fontSize: 14.0),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: AppConstants.linkTextStyle,
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: AppConstants.linkTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Sign Up button
                          CustomButton(
                            text: 'Sign Up',
                            onPressed: _signUp,
                            isLoading: authService.isLoading,
                            isEnabled: _isFormValid,
                          ),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Login link
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: AppConstants.taglineStyle.color, fontSize: 14.0),
                                children: [
                                  const TextSpan(text: 'Already have an account? '),
                                  TextSpan(
                                    text: 'Log In',
                                    style: AppConstants.linkTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}