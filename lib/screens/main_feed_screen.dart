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
  Map<String, List<dynamic>> clientsByCategory = {}; // Mapa de categorías y clientes
  bool isLoading = true; // Indicador de carga
  String errorMessage = ""; // Mensaje de error para mostrar en caso de fallo

  @override
  void initState() {
    super.initState();
    loadClients(); // Cargar datos iniciales
  }

  Future<void> loadClients() async {
    try {
      final String response = await rootBundle.loadString('assets/test_data.json');
      final decodedData = json.decode(response);

      // Verificación de claves en el JSON
      if (decodedData['users'] == null ||
          decodedData['services'] == null ||
          decodedData['categories'] == null) {
        throw Exception("Datos incompletos en el archivo JSON");
      }

      final allClients = decodedData['users']
          ?.where((user) => user['role'] == 'client')
          ?.toList() ??
          [];
      final allServices = decodedData['services'] ?? [];
      final allCategories = decodedData['categories'] ?? [];

      // Verifica que los datos cargados no estén vacíos
      if (allClients.isEmpty || allServices.isEmpty || allCategories.isEmpty) {
        throw Exception("Datos insuficientes para mostrar contenido.");
      }

      // Procesar clientes por categoría
      final Map<String, List<dynamic>> tempClientsByCategory = {};

      for (var category in allCategories) {
        final categoryName = category['name'] ?? "Sin Categoría";
        final categoryId = category['id'];

        final categoryServices = allServices
            .where((service) => service['category_id'] == categoryId)
            .toList();

        for (var service in categoryServices) {
          final client = allClients.firstWhere(
                (client) => client['id'] == service['client_id'],
            orElse: () => null,
          );

          if (client != null) {
            if (!tempClientsByCategory.containsKey(categoryName)) {
              tempClientsByCategory[categoryName] = [];
            }
            if (!tempClientsByCategory[categoryName]!.any((c) => c['id'] == client['id'])) {
              tempClientsByCategory[categoryName]!.add(client);
            }
          }
        }
      }

      setState(() {
        clientsByCategory = tempClientsByCategory;
        isLoading = false;
        errorMessage = ""; // Limpiar cualquier mensaje de error previo
      });
    } catch (e) {
      print('Error cargando datos JSON: $e');
      setState(() {
        isLoading = false;
        errorMessage = "Error al cargar los datos: ${e.toString()}";
      });
    }
  }

  String getClientImage(String? imageUrl) {
    return imageUrl ?? 'assets/short_time_assets/ImagenLocal.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : clientsByCategory.isEmpty
          ? const Center(child: Text("No hay clientes disponibles."))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: clientsByCategory.keys.length,
          itemBuilder: (context, index) {
            final category = clientsByCategory.keys.elementAt(index);
            final categoryClients = clientsByCategory[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título de la categoría
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                // Lista horizontal de clientes
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categoryClients.map((client) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClientCard(
                          imageUrl: client['profile_picture'],
                          businessName: client['business_name'],
                          location: client['business_address'],
                          clientId: client['id'],
                          openingTime: client['opening_time'],
                          closingTime: client['closing_time'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientServicesScreen(clientId: client['id']),
                              ),
                            );
                          },
                        )

                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
