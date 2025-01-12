import 'package:flutter/material.dart';

class ClientSearchDelegate extends SearchDelegate {
  final List<dynamic> services; // Lista de servicios
  final Function(dynamic) onSelected; // Callback para seleccionar un cliente

  ClientSearchDelegate({
    required this.services,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpiar la búsqueda
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Cerrar el buscador
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filtrar los servicios por el nombre y la categoría
    final filteredServices = services.where((service) {
      final serviceName = service['nombre'].toLowerCase();
      final category = service['categoria'].toLowerCase();
      return serviceName.contains(query.toLowerCase()) ||
          category.contains(query.toLowerCase());
    }).toList();

    // Agrupar los servicios por cliente (idusuario)
    final clients = {};
    for (var service in filteredServices) {
      final clientId = service['idusuario'];
      if (!clients.containsKey(clientId)) {
        clients[clientId] = service;
      }
    }

    return ListView(
      children: clients.values.map<Widget>((service) {
        final clientId = service['idusuario'];
        final clientName = service['nombre']; // Nombre del cliente
        final category = service['categoria'];

        return ListTile(
          title: Text(clientName),
          subtitle: Text('Categoría: $category'),
          onTap: () {
            onSelected(clientId); // Seleccionar cliente
            close(context, null);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
