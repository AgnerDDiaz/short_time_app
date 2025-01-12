import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final double rating;
  final int clientId;
  final String clientName;
  final String openingTime;
  final String closingTime;
  final int serviceDuration;
  final VoidCallback? onTap; // Añadir parámetro onTap

  const ServiceCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.clientId,
    required this.clientName,
    required this.openingTime,
    required this.closingTime,
    required this.serviceDuration,
    this.onTap, // Inicializar parámetro onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Ejecutar la función onTap cuando se toque la tarjeta
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
              Text("\$${price.toStringAsFixed(2)}", style: Theme.of(context).textTheme.bodyLarge),
              Text("Rating: ${rating.toStringAsFixed(1)} ⭐"),
            ],
          ),
        ),
      ),
    );
  }
}
