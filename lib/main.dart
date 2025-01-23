import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/models/ProfileManager.dart';
import 'package:short_time_app/models/auth_models.dart';
import 'package:short_time_app/screens/profile_screen.dart';
import 'package:short_time_app/screens/reservations_screen.dart';
import 'package:short_time_app/short_time_themes.dart';
import 'package:short_time_app/states/auth_state.dart';

import 'api/api_client.dart';
import 'checks/auth_check.dart';
import 'home.dart';
import 'models/tab_manager.dart';
import 'screens/change_password_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/forgot_password_verification_screen.dart';
import 'screens/login_screen.dart'; // Pantalla de Login
import 'screens/registro_screen.dart'; // Pantalla de Registro
import 'screens/forgot_password_screen.dart'; // Importar la pantalla de recuperación de contraseña

void main() {
  runApp(ShortTimeApp());
}

class ShortTimeApp extends StatefulWidget {
  ShortTimeApp({super.key});

  @override
  State<ShortTimeApp> createState() => ShortTimeAppState();
}

class ShortTimeAppState extends State<ShortTimeApp> {
  // Create a theme with blue colors
  ThemeData theme = ShortTimeThemes.light();

  // ThemeData theme = ShortTimeThemes.light();

  void ChangeThemeMode(bool isLightMode) {
    setState(() {
      if (isLightMode) {
        theme = ShortTimeThemes.dark();
      } else {
        theme = ShortTimeThemes.light();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _apiClient = ShortTimeApiClient();
    const appTitle = "Short Time";

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileManager(),
        ),
        ChangeNotifierProvider(
            create: (context) =>
                AuthState(authService: AuthService(apiClient: _apiClient)))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: appTitle,
        initialRoute: '/login', // Ahora la ruta inicial es "/login"
        routes: {
          '/profile': (context) => AuthCheck(loggedInWidget: ProfileScreen()),
          '/login': (context) => LoginScreen(), // Pantalla de Login
          '/home': (context) => AuthCheck(
                  loggedInWidget: Home(
                appTitle: appTitle,
                ChangeThemeMode: ChangeThemeMode,
              )), // Pantalla principal Home
          '/forgotPassword': (context) =>
              ForgotPasswordScreen(), // Ruta añadida para la pantalla de recuperación
          '/forgotPasswordVerification': (context) =>
              ForgotPasswordVerificationScreen(), // Ruta añadida para la pantalla de verificación
          '/changePassword': (context) =>
              AuthCheck(loggedInWidget: ChangePasswordScreen()), // Ruta añadida para la pantalla de cambio de contraseña
          // '/emptyPage': (context) => EmptyPage(), // Página vacía
          '/register': (context) =>
              RegisterScreen(), // Ruta añadida para el registro // Ruta añadida para las reservas

          '/editProfile': (context) => AuthCheck(
              loggedInWidget:
                  EditProfileScreen()), // Ruta añadida para la edición de perfil
        },
      ),
    );
  }
}
