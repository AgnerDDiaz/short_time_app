import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../widgets/service_card.dart';

class ClientServicesScreen extends StatefulWidget {
  final int clientId;

  const ClientServicesScreen({Key? key, required this.clientId})
      : super(key: key);

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  List<dynamic> services = []; // Servicios filtrados del cliente

  @override
  void initState() {
    super.initState();
    loadClientServices(); // Carga los servicios del cliente
  }

  Future<void> loadClientServices() async {
    try {
      // Cargar el archivo JSON desde assets
      final String response =
      await rootBundle.loadString('assets/test_data.json');
      final decodedData = json.decode(response);
      final allServices = decodedData['servicios'];

      // Filtrar servicios que coincidan con el idusuario del cliente
      setState(() {
        services = allServices
            .where((service) => service['idusuario'] == widget.clientId)
            .toList();
      });
    } catch (e) {
      print('Error cargando servicios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Servicios del Cliente"),
      ),
      body: services.isEmpty
          ? const Center(child: Text("Este cliente no tiene servicios."))
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(
            name: service['nombre'],
            description: service['descripcion'],
            price: service['precio'],
            rating: service['calificacion'],
            onTap: () {
              // Acción al tocar un servicio (si es necesario)
            },
          );
        },
      ),
    );
  }
}
