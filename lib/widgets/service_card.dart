import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String rating;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(name, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(
          '$description\nPrecio: \$${price.toStringAsFixed(2)}\nCalificación: $rating',
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
