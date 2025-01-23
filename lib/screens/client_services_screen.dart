import 'package:flutter/material.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/rating_service.dart';
import 'package:short_time_app/api/service_service.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/models/service.dart';
import 'package:short_time_app/models/user.dart';
import '../models/rating.dart';
import 'availability_screen.dart';

class ClientServicesScreen extends StatefulWidget {
  final GetUserByIdResponseDto client;

  ClientServicesScreen({Key? key, required this.client}) : super(key: key);

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  List<dynamic> clients = [];  // Agregar esta lista
  List<GetServiceByIdResponseDto> clientServices = [];
  List<RatingDto> ratings = [];
  bool isLoading = true;
  String errorMessage = "";

  final ServiceService serviceService = ServiceService(apiClient: ShortTimeApiClient());
  final UserService userService = UserService(apiClient: ShortTimeApiClient());
  final RatingService ratingService = RatingService(apiClient: ShortTimeApiClient());

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

      final services = await serviceService.getAllServices(widget.client.id);
      final clientRatings = await ratingService.getClientRatings(widget.client.id);
      

      setState(() {
        clientServices = services.results;
      });

      ratings = clientRatings.results;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
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
          widget.client != null
              ? "Servicios de ${widget.client!.businessName ?? 'Sin Nombre'}"
              : "Cargando...",
        ),
      ),
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
                              image: widget.client?.profilePicture != null
                                  ? DecorationImage(
                                      image: NetworkImage(widget.client!.profilePicture!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: Colors.grey.shade300,
                            ),
                            child: widget.client?.profilePicture == null
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
                              widget.client?.businessName ?? "Sin Nombre",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.client?.businessAddress ?? "Sin Dirección",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.client?.phoneNumber ?? "Sin Teléfono",
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
                                service.name ?? "Sin Nombre",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Duración: ${service.serviceDuration} minutos\n${service.description ?? "Sin Descripción"}",
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$${service.price}",
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
                                      serviceId: service.id,
                                      serviceName: service.name,
                                      serviceDuration: service.serviceDuration, 
                                      clientId: service.clientId,
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







