import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/screens/customer_reservations_screen.dart';
import 'package:short_time_app/screens/main_feed_screen.dart';
import 'package:short_time_app/screens/profile.dart'; // Asegúrate de que este archivo esté correctamente enlazado
import 'package:short_time_app/screens/reservations_screen.dart';
import 'package:short_time_app/widgets/service_search_delegate.dart';

import 'components/Theme_button.dart';
import 'models/tab_manager.dart';
import 'screens/client_services_screen.dart';

class Home extends StatefulWidget {
  Home({
    super.key,
    required this.appTitle,
    required this.ChangeThemeMode,
  });

  final String appTitle;
  final Function ChangeThemeMode;
  final ShortTimeApiClient apiClient = ShortTimeApiClient();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentScreen = 0;
  List<dynamic> services = []; // Servicios cargados desde el JSON

  // Lista de pantallas (Reservas utiliza un userId de prueba por ahora)
  final List<Widget> screens = [
    const MainFeedScreen(),
    CustomerReservationsScreen(userId: 3),
    ProfileScreen(
      authService: AuthService(apiClient: ShortTimeApiClient()),
      userService: UserService(apiClient: ShortTimeApiClient()),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Test if the token is stored

    loadServices(); // Cargar servicios al inicio
  }

  Future<void> loadServices() async {
    try {
      // Cargar el archivo JSON desde assets
      final String response =
          await rootBundle.loadString('assets/test_data.json');
      final decodedData = json.decode(response);

      setState(() {
        services =
            decodedData['services'] ?? []; // Corregido para extraer servicios
      });
    } catch (e) {
      print('Error al cargar servicios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el tema actual
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Consumer<TabManager>(
      builder: (context, tabManager, child) => Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).appBarTheme.backgroundColor, // Color fijo
          title: Row(
            children: [
              const SizedBox(width: 8),
              Image.asset(
                isLightMode
                    ? 'assets/icon/Short_Time Logo Claro.jpg'
                    : 'assets/icon/Short_Time Logo Oscuro.jpg',
                height: 32,
              ),
              const SizedBox(width: 16),
              Text(
                widget.appTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (services.isNotEmpty) {
                  showSearch(
                    context: context,
                    delegate: ClientSearchDelegate(
                      services: services,
                      onSelected: (clientId) {
                        // Navegar a los servicios del cliente seleccionado
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientServicesScreen(clientId: clientId),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Cargando servicios, intenta nuevamente.')),
                  );
                }
              },
            ),
            ThemeButton(changeTheme: widget.ChangeThemeMode),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueGrey,
          onTap: (value) {
            tabManager.goToTab(value);
          },
          currentIndex: tabManager.selectedTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Reservation",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        body: screens[tabManager.selectedTab],
      ),
    );
  }
}
