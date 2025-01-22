import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ReservationsScreen extends StatefulWidget {
  final int userId; // ID del usuario logueado

  const ReservationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  List<Map<String, dynamic>> userReservations = []; // Reservaciones del usuario
  DateTime selectedDate = DateTime.now(); // Día seleccionado
  List<Map<String, dynamic>> reservationsForSelectedDay = []; // Reservaciones del día seleccionado
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  Future<void> loadReservations() async {
    try {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      // Filtrar las reservaciones por usuario
      final reservations = decodedData['reservations'] ?? [];
      final services = decodedData['services'] ?? [];
      final clients = decodedData['users'] ?? [];

      userReservations = reservations
          .where((reservation) => reservation['user_id'] == widget.userId)
          .map<Map<String, dynamic>>((reservation) {
        // Buscar el servicio relacionado
        final service = services.firstWhere(
              (s) => s['id'] == reservation['service_id'],
          orElse: () => null,
        );

        // Buscar el cliente relacionado con el servicio
        final client = clients.firstWhere(
              (c) => c['id'] == service?['client_id'],
          orElse: () => null,
        );

        return {
          ...reservation,
          'service_name': service?['name'] ?? "Sin Nombre",
          'business_name': client?['business_name'] ?? "Sin Nombre",
        };
      }).toList();

      updateReservationsForSelectedDay();

      setState(() {
        isLoading = false; // Finalizar la carga
      });
    } catch (e) {
      print("Error al cargar reservaciones: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateReservationsForSelectedDay() {
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    reservationsForSelectedDay = userReservations
        .where((reservation) => reservation['date'] == selectedDateStr)
        .toList();
  }

  void cancelReservation(Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancelar Reservación"),
          content: const Text("¿Estás seguro que deseas cancelar esta reservación?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  userReservations.remove(reservation);
                  updateReservationsForSelectedDay();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Reservación cancelada")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Sí"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reservaciones"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Calendario
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 7)),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                updateReservationsForSelectedDay();
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              final dayStr = DateFormat('yyyy-MM-dd').format(day);
              return userReservations
                  .where((reservation) => reservation['date'] == dayStr)
                  .toList();
            },
          ),
          const SizedBox(height: 16),
          // Reservaciones del día seleccionado
          Expanded(
            child: reservationsForSelectedDay.isEmpty
                ? const Center(
              child: Text("No hay reservaciones para este día."),
            )
                : ListView.builder(
              itemCount: reservationsForSelectedDay.length,
              itemBuilder: (context, index) {
                final reservation = reservationsForSelectedDay[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(reservation['service_name']),
                    subtitle: Text(
                      "Hora: ${reservation['start_time']} - ${reservation['end_time']}\nLocal: ${reservation['business_name']}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => cancelReservation(reservation),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Cancelar"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
