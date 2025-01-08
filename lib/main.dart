import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/short_time_themes.dart';

import 'home.dart';
import 'models/grocery_manager.dart';
import 'models/tab_manager.dart';
import 'screens/login_screen.dart';
import 'models/auth_manager.dart'; // Clase para manejar la autenticación

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
    const appTitle = "Short Time";

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GroceryManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthManager(), // Agregamos el AuthManager
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: appTitle,
        home: Wrapper(
          appTitle: appTitle,
          ChangeThemeMode: ChangeThemeMode,
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  final String appTitle;
  final Function(bool) ChangeThemeMode;

  Wrapper({required this.appTitle, required this.ChangeThemeMode});

  @override
  Widget build(BuildContext context) {
    // Verificamos si el usuario está autenticado
    final authManager = Provider.of<AuthManager>(context);

    // Si está autenticado, muestra la Home, si no, redirige al LoginScreen
    if (authManager.isAuthenticated) {
      return Home(
        appTitle: appTitle,
        ChangeThemeMode: ChangeThemeMode,
      );
    } else {
      return LoginScreen();
    }
  }
}
