import 'package:flutter/material.dart';

import '../screens/client_services_screen.dart';

class ClientCard extends StatelessWidget {
  final String? imageUrl; // Imagen del cliente (opcional)
  final String? businessName; // Nombre de la empresa (opcional)
  final String? location; // Dirección del cliente (opcional)
  final int clientId; // ID del cliente
  final String? openingTime; // Hora de apertura (opcional)
  final String? closingTime; // Hora de cierre (opcional)
  final VoidCallback onTap;

  const ClientCard({
    Key? key,
    required this.imageUrl,
    required this.businessName,
    required this.location,
    required this.clientId,
    required this.openingTime,
    required this.closingTime,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientServicesScreen(clientId: clientId),
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200, // Ancho máximo
          maxHeight: 250, // Altura máxima
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.blue, width: 2), // Borde azul
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del cliente
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  image: imageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: imageUrl == null
                    ? const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre de la empresa
                    Text(
                      businessName ?? "Sin Nombre",
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Ubicación del cliente
                    Text(
                      location ?? "Ubicación no disponible",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Horario del cliente
                    Text(
                      "Horario: ${openingTime ?? "No disponible"} - ${closingTime ?? "No disponible"}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
