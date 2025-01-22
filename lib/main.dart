import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/screens/customer_reservations_screen.dart';
import 'package:short_time_app/screens/provider_reservations_screen.dart';
import 'package:short_time_app/short_time_themes.dart';

import 'home.dart';
import 'home_bussines.dart';
import 'models/tab_manager.dart';
import 'models/auth_manager.dart'; // Clase para manejar la autenticación
import 'screens/add_service_screen.dart';
import 'screens/login_screen.dart'; // Pantalla de Login
import 'screens/manage_availability_screen.dart';
import 'screens/manage_services_screen.dart';
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
    const appTitle = "Short Time";

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthManager(), // Importación sin conflicto
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: appTitle,
        initialRoute: '/login', // Ahora la ruta inicial es "/login"
        routes: {
          '/login': (context) => LoginScreen(), // Pantalla de Login
          '/home': (context) => Home(
            appTitle: appTitle,
            ChangeThemeMode: ChangeThemeMode,
          ),
          '/homebussines': (context) => Home_bussines(
            appTitle: appTitle,
            ChangeThemeMode: ChangeThemeMode,
          ),// Pantalla principal Home
          '/forgotPassword': (context) => ForgotPasswordScreen(), // Ruta añadida para la pantalla de recuperación
          '/register': (context) => RegisterScreen(), // Ruta añadida para el registro
          '/add_service': (context) => AddServiceScreen(), // Agrega esta línea
          '/manageServices': (context) => ManageServicesScreen(clientId: 1),
          '/manageAvailability': (context) => ManageAvailabilityScreen(clientId: 1),
          '/customerReservations': (context) => CustomerReservationsScreen(userId: 3),
          '/providerReservations': (context) => ProviderReservationsScreen(clientId: 1),
          // Usa un clientId de prueba

        },
      ),
    );
  }
}
