import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/models/ProfileManager.dart';
import 'package:short_time_app/screens/profile_screen.dart';
import 'package:short_time_app/short_time_themes.dart';
import 'package:short_time_app/states/auth_state.dart';

import 'api/api_client.dart';
import 'checks/auth_check.dart';
import 'home.dart';
import 'models/tab_manager.dart';
import 'models/auth_manager.dart'; // Clase para manejar la autenticación
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
  ThemeData theme = ShortTimeThemes.light();

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
          create: (context) => AuthManager(), // Importación sin conflicto
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
          // '/emptyPage': (context) => EmptyPage(), // Página vacía
          '/register': (context) =>
              RegisterScreen(), // Ruta añadida para el registro
        },
      ),
    );
  }
}
