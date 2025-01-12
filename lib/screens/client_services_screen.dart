import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/service_card.dart';
import 'availability_screen.dart';

class ClientServicesScreen extends StatefulWidget {
  final int clientId;

  const ClientServicesScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  List<dynamic> services = [];
  Map<String, dynamic>? clientData;

  @override
  void initState() {
    super.initState();
    loadClientServices();
  }

  Future<void> loadClientServices() async {
    try {
      final String response = await rootBundle.loadString('assets/test_data.json');
      final decodedData = json.decode(response);

      final allServices = decodedData['servicios'];
      final allClients = decodedData['usuario'];

      setState(() {
        services = allServices
            .where((service) => service['idusuario'] == widget.clientId)
            .toList();
        clientData = allClients.firstWhere(
              (client) => client['idusuario'] == widget.clientId,
          orElse: () => null,
        );
      });
    } catch (e) {
      print('Error cargando datos JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Servicios del Cliente"),
      ),
      body: services.isEmpty
          ? const Center(child: Text("No hay servicios disponibles para este cliente."))
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];

          return ServiceCard(
            name: service['nombre'],
            description: service['descripcion'],
            price: service['precio'],
            rating: double.parse(service['calificacion'].toString()),
            clientId: widget.clientId,
            clientName: clientData?['nombre'] ?? "Cliente Desconocido",
            openingTime: clientData?['apertura'] ?? "09:00:00",
            closingTime: clientData?['cierre'] ?? "18:00:00",
            serviceDuration: service['duracion'] ?? 60,
            onTap: () {
              // Navegar a AvailabilityScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AvailabilityScreen(
                    clientId: widget.clientId,
                    clientName: clientData?['nombre'] ?? "Cliente Desconocido",
                    openingTime: clientData?['apertura'] ?? "09:00:00",
                    closingTime: clientData?['cierre'] ?? "18:00:00",
                    serviceDuration: service['duracion'] ?? 60,
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
