import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/rating.dart';
import 'availability_screen.dart'; // Pantalla de disponibilidad

class ClientServicesScreen extends StatefulWidget {
  final int clientId;

  const ClientServicesScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  Map<String, dynamic>? clientData; // Información del cliente
  List<Map<String, dynamic>> clientServices = []; // Servicios del cliente
  List<Rating> ratings = []; // Calificaciones del cliente
  bool isLoading = true; // Indicador de carga
  String errorMessage = ""; // Mensaje de error en caso de problemas

  @override
  void initState() {
    super.initState();
    loadClientData();
  }

  Future<void> loadClientData() async {
    try {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      // Filtrar información del cliente basado en clientId
      final clients = decodedData['users'] ?? [];
      final services = decodedData['services'] ?? [];

      clientData = clients.firstWhere(
            (client) => client['id'] == widget.clientId,
        orElse: () => null,
      );

      // Si no se encuentra el cliente, mostrar un error
      if (clientData == null) {
        setState(() {
          errorMessage = "Cliente no encontrado.";
          isLoading = false;
        });
        return;
      }

      // Filtrar servicios asociados al cliente
      clientServices = services
          .where((service) => service['client_id'] == widget.clientId)
          .map<Map<String, dynamic>>((service) => Map<String, dynamic>.from(service))
          .toList();

      // Cargar comentarios relacionados con los servicios del cliente
      ratings = await loadRatings(widget.clientId);

      setState(() {
        isLoading = false; // Finalizar carga
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error al cargar los datos: $e";
        isLoading = false;
      });
    }
  }

  Future<List<Rating>> loadRatings(int clientId) async {
    try {
      // Cargar datos del JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Filtrar servicios del cliente
      final services = data['services']
          ?.where((service) => service['client_id'] == clientId)
          ?.toList() ?? [];

      // Obtener los IDs de los servicios asociados al cliente
      final serviceIds = services.map((service) => service['id']).toList();

      // Filtrar comentarios relacionados con los servicios
      final ratings = data['ratings']
          ?.where((rating) => serviceIds.contains(rating['service_id']))
          ?.map<Rating>((rating) => Rating.fromJson(rating))
          ?.toList() ?? [];

      return ratings;
    } catch (e) {
      print("Error al cargar los comentarios: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          clientData != null
              ? "Servicios de ${clientData!['business_name'] ?? 'Sin Nombre'}"
              : "Cargando...",
        ),
      ),
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
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del cliente
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: clientData!["profile_picture"] != null
                        ? DecorationImage(
                      image: NetworkImage(clientData!["profile_picture"]),
                      fit: BoxFit.cover,
                    )
                        : null,
                    color: Colors.grey.shade300,
                  ),
                  child: clientData!["profile_picture"] == null
                      ? const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Información del cliente
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientData!["business_name"] ?? "Sin Nombre",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clientData!["business_address"] ?? "Sin Dirección",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clientData!["phone_number"] ?? "Sin Teléfono",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Lista de servicios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Servicios",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: clientServices.length,
              itemBuilder: (context, index) {
                final service = clientServices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      service["name"] ?? "Sin Nombre",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Duración: ${service["service_duration"]} minutos\n${service["description"] ?? "Sin Descripción"}",
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$${service["price"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailabilityScreen(
                            serviceId: service["id"],
                            serviceName: service["name"],
                            serviceDuration: service["service_duration"],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Sección de comentarios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comentarios",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ratings.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No hay comentarios disponibles.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    "Calificación: ${rating.rating}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(rating.comment),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
