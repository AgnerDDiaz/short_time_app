import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/category_service.dart';
import 'package:short_time_app/api/service_service.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/models/service.dart';
import 'package:short_time_app/models/user.dart';

import '../widgets/client_card.dart';
import 'client_services_screen.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({Key? key}) : super(key: key);

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  final UserService userService = UserService(apiClient: ShortTimeApiClient());
  final CategoryService categoryService =
      CategoryService(apiClient: ShortTimeApiClient());
  late Map<String, List<GetUserByIdResponseDto>> clientsByCategory;

  bool isLoading = true; // Indicador de carga
  String errorMessage = ""; // Mensaje de error para mostrar en caso de fallo

  @override
  void initState() {
    super.initState();
    loadClients(); // Cargar datos iniciales
  }

  Future<void> loadClients() async {
    try {
      final categories = await categoryService.getAllCategories();

      final clients = await userService.getClients();
      final clientByCategory = <String, List<GetUserByIdResponseDto>>{
        for (var category in categories.results)
          category.name: clients.results
              .where((client) =>
                  client.category_id != null &&
                  client.category_id == category.id)
              .toList()
      };
      setState(() {
        clientsByCategory = clientByCategory;
        // clientsByCategory = tempClientsByCategory;
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
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
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
                          final category =
                              clientsByCategory.keys.elementAt(index);
                          List<GetUserByIdResponseDto> categoryClients =
                              clientsByCategory[category]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título de la categoría
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ClientCard.ServiceCard(
                                          client: client,
                                          imageUrl: client.profilePicture,
                                          businessName: client.name,
                                          location: client.businessAddress,
                                          clientId: client.id,
                                          rating: client.rating,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ClientServicesScreen(
                                                  client: client,
                                                ),
                                              ),
                                            );
                                          },
                                        ));
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
