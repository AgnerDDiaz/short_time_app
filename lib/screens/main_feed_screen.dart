import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../widgets/client_card.dart';
import 'client_services_screen.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({Key? key}) : super(key: key);

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  List<dynamic> clients = []; // Lista de clientes cargados

  @override
  void initState() {
    super.initState();
    loadClients(); // Carga inicial de datos
  }

  Future<void> loadClients() async {
    try {
      final String response = await rootBundle.loadString('assets/test_data.json');
      final decodedData = json.decode(response);
      setState(() {
        clients = decodedData['usuario']
            .where((user) => user['rol'] == 'cliente')
            .toList();
      });
    } catch (e) {
      print('Error cargando datos JSON: $e');
    }
  }

  String getClientImage(String? imageUrl) {
    return imageUrl ?? 'assets/short_time_assets/ImagenLocal.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes Disponibles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0, // Cuadrado
          ),
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return ClientCard(
              imageUrl: getClientImage(client['foto']),
              name: client['nombre'],
              location: client['ubicacion'] ?? "Ubicación no disponible",
              openingTime: client['apertura'] ?? "Sin hora de apertura",
              closingTime: client['cierre'] ?? "Sin hora de cierre",
              onTap: () {
                // Navegar a ClientServicesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientServicesScreen(clientId: client['idusuario']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
