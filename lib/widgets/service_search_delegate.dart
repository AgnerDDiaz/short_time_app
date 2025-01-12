import 'package:flutter/material.dart';

class ServiceSearchDelegate extends SearchDelegate {
  final List<dynamic> services;
  final Function(dynamic) onSelected;

  ServiceSearchDelegate({required this.services, required this.onSelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = services
        .where((service) =>
        service['nombre'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final service = results[index];
        return ListTile(
          title: Text(service['nombre']),
          onTap: () => onSelected(service),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
