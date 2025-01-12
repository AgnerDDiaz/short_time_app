import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/screens/explore_screen.dart';
import 'package:short_time_app/screens/Reservas_screen.dart';
import 'package:short_time_app/screens/main_feed_screen.dart';
import 'package:short_time_app/screens/profile.dart';

import 'components/Theme_button.dart';
import 'models/tab_manager.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.appTitle,
    required this.ChangeThemeMode,
  });

  final String appTitle;
  final Function ChangeThemeMode;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentScreen = 0;
  final List<Widget> screens = [MainFeedScreen(), Reservas_Screen(), Profile()];

  void ChangeScreen(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el tema actual
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Consumer<TabManager>(
      builder: (context, tabManager, child) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [

              const SizedBox(width: 8), // Espacio entre el texto y el ícono
              Image.asset(
                isLightMode
                    ? 'assets/icon/Short_Time Logo Claro.jpg' // Ícono para tema claro
                    : 'assets/icon/Short_Time Logo Oscuro.jpg',  // Ícono para tema oscuro
                height: 32, // Ajusta el tamaño del ícono
              ),
              const SizedBox(width: 16), // Espacio entre el logo y el texto
              Text(
                widget.appTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          actions: [
            // Botón para cambiar el tema
            ThemeButton(changeTheme: widget.ChangeThemeMode),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
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
