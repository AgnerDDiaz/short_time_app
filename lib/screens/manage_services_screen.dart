import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'edit_service_screen.dart';

class ManageServicesScreen extends StatefulWidget {
  final int clientId; // ID del cliente para filtrar sus servicios

  const ManageServicesScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  List<dynamic> clientServices = []; // Servicios del cliente
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadClientServices();
  }

  Future<void> loadClientServices() async {
    try {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Filtrar los servicios del cliente actual
      final services = data['services'] ?? [];
      clientServices = services.where((service) => service['client_id'] == widget.clientId).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar servicios: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void confirmDeleteService(int serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este servicio?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Cancelar'),


          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
              deleteService(serviceId); // Eliminar el servicio
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white),
          ),
          ),
        ],
      ),
    );
  }

  void deleteService(int serviceId) {
    setState(() {
      clientServices.removeWhere((service) => service['id'] == serviceId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Servicio eliminado con éxito.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Servicios'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : clientServices.isEmpty
          ? const Center(child: Text('No tienes servicios registrados.'))
          : ListView.builder(
        itemCount: clientServices.length,
        itemBuilder: (context, index) {
          final service = clientServices[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(service['name']),
              subtitle: Text(
                  'Precio: \$${service['price']} | Duración: ${service['service_duration']} mins'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditServiceScreen(serviceData: service),
                        ), // Navegar a la pantalla de edición
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      confirmDeleteService(service['id']); // Confirmar eliminación
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
