import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ManageAvailabilityScreen extends StatefulWidget {
  final int clientId; // ID del cliente

  const ManageAvailabilityScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ManageAvailabilityScreen> createState() => _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  Map<String, Map<String, dynamic>> availability = {}; // Disponibilidad por día
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    try {
      // Cargar datos del JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(response);

      final availabilities = data['availability'] ?? [];

      // Filtrar disponibilidad para el cliente
      final clientAvailability = availabilities.where((entry) {
        return entry['client_id'] == widget.clientId;
      }).toList();

      for (var entry in clientAvailability) {
        final day = entry['day'];
        availability[day] = {
          "opening_time": entry['opening_time'],
          "closing_time": entry['closing_time'],
          "is_day_off": entry['is_day_off'] ?? false,
        };
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar disponibilidad: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateAvailability(String day, String openingTime, String closingTime, bool isDayOff) {
    setState(() {
      availability[day] = {
        "opening_time": openingTime,
        "closing_time": closingTime,
        "is_day_off": isDayOff,
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Disponibilidad para $day actualizada.')),
    );
  }

  Future<void> selectTime(BuildContext context, String day, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      final currentDayAvailability = availability[day] ?? {};

      setState(() {
        availability[day] = {
          ...currentDayAvailability,
          if (isOpeningTime) "opening_time": formattedTime else "closing_time": formattedTime,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Disponibilidad'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          final day = daysOfWeek[index];
          final currentDayAvailability = availability[day] ?? {};
          final openingTime = currentDayAvailability["opening_time"] ?? "No definido";
          final closingTime = currentDayAvailability["closing_time"] ?? "No definido";
          final isDayOff = currentDayAvailability["is_day_off"] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: isDayOff,
                        onChanged: (value) {
                          setState(() {
                            availability[day] = {
                              "opening_time": "No definido",
                              "closing_time": "No definido",
                              "is_day_off": value ?? false,
                            };
                          });
                        },
                      ),
                      const Text("Día no laborable"),
                    ],
                  ),
                  if (!isDayOff)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hora de Apertura:'),
                            ElevatedButton(
                              onPressed: () => selectTime(context, day, true),
                              child: Text(openingTime),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hora de Cierre:'),
                            ElevatedButton(
                              onPressed: () => selectTime(context, day, false),
                              child: Text(closingTime),
                            ),
                          ],
                        ),
                      ],
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
