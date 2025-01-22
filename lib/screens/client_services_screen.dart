import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/rating.dart';
import 'availability_screen.dart';
import '/api/st_api_service.dart';

class ClientServicesScreen extends StatefulWidget {
  final int clientId;

  const ClientServicesScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  List<dynamic> clients = [];  // Agregar esta lista
  Map<String, dynamic>? clientData;
  List<Map<String, dynamic>> clientServices = [];
  List<Rating> ratings = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadClientData();
  }

  Future<void> loadClientData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Obtener información del cliente usando la API
      clientData = await StApiService.getClientInfo(widget.clientId);

      // Si no se encuentra el cliente, mostrar un error
      if (clientData == null) {
        setState(() {
          errorMessage = 'Cliente no encontrado';
          isLoading = false;
        });
        return;
      }

      // Obtener servicios del cliente usando la API
      clientServices = await StApiService.getClientServices(widget.clientId);

      // Por ahora, dejamos los ratings vacíos
      ratings = [];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar los datos: $e';
        isLoading = false;
      });
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







