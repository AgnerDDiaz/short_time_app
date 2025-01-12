import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String openingTime;
  final String closingTime;
  final VoidCallback onTap;

  const ClientCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.openingTime,
    required this.closingTime,
    required this.onTap,
  }) : super(key: key);

  String formatTime(String time) {
    try {
      // Convertir la hora de texto a DateTime
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      // Formatear en AM/PM
      return DateFormat.jm().format(parsedTime);
    } catch (e) {
      // Retornar la hora original en caso de error
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(location, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    "${formatTime(openingTime)} - ${formatTime(closingTime)}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
