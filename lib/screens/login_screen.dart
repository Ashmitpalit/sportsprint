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
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isGoogleLoading = false;
  String? _identifierError;
  String? _passwordError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Validate identifier
      _identifierError = Validators.validateLoginIdentifier(_identifierController.text);

      // Validate password
      _passwordError = _passwordController.text.isEmpty 
          ? 'Password is required' 
          : (_passwordController.text.length < 6 
              ? 'Password must be at least 6 characters' 
              : null);
    });
  }

  bool get _isFormValid {
    return _identifierError == null && _passwordError == null;
  }

  Future<void> _login() async {
    _validateForm();
    
    if (!_isFormValid) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final result = await authService.login(
      identifier: _identifierController.text,
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
        Fluttertoast.showToast(
          msg: result.errorMessage ?? 'Invalid credentials',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppConstants.errorColor,
          textColor: Colors.white,
        );
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
                          
                          // Login illustration
                          const AuthIllustration(type: 'login'),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Identifier field
                          CustomTextField(
                            label: 'Email, Phone, or Username',
                            controller: _identifierController,
                            errorText: _identifierError,
                            prefixIcon: const Icon(Icons.email, color: AppConstants.textColor),
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
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Login button
                          CustomButton(
                            text: 'Log In',
                            onPressed: _login,
                            isLoading: authService.isLoading,
                            isEnabled: _isFormValid,
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
                          
                          // Google OAuth button
                          OAuthButton(
                            text: 'Continue with Google',
                            onPressed: _signInWithGoogle,
                            isLoading: _isGoogleLoading,
                          ),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          
                          // Sign up link
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const SignupScreen()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: AppConstants.taglineStyle.color, fontSize: 14.0),
                                children: [
                                  const TextSpan(text: 'Don\'t have an account? '),
                                  TextSpan(
                                    text: 'Sign Up',
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