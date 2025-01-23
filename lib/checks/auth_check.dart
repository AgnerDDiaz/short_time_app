import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/screens/login_screen.dart';

import '../states/auth_state.dart';

class AuthCheck extends StatelessWidget {
  final Widget loggedInWidget;

  AuthCheck({required this.loggedInWidget });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        if (authState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return authState.isLoggedIn ? loggedInWidget : LoginScreen();
      },
    );
  }
}