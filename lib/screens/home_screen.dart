import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80.0,
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Successfully Logged In!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Welcome, ${user?.fullName ?? 'User'}!',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Username: ${user?.username ?? 'N/A'}',
                style: const TextStyle(fontSize: 16.0),
              ),
              if (user?.email?.isNotEmpty ?? false) ...[  
                const SizedBox(height: 8.0),
                Text(
                  'Email: ${user?.email}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
              if (user?.phone?.isNotEmpty ?? false) ...[  
                const SizedBox(height: 8.0),
                Text(
                  'Phone: ${user?.phone}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
              const SizedBox(height: 32.0),
              const Text(
                'This is a placeholder home screen.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}