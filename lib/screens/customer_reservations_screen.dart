import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CustomerReservationsScreen extends StatefulWidget {
  final int userId;

  const CustomerReservationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CustomerReservationsScreen> createState() =>
      _CustomerReservationsScreenState();
}

class _CustomerReservationsScreenState extends State<CustomerReservationsScreen> {
  List<Map<String, dynamic>> userReservations = [];
  List<Map<String, dynamic>> reservationsForSelectedDay = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  Future<void> loadReservations() async {
    try {
      // Cargar el archivo JSON desde assets
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Verificar que las claves del JSON existan
      if (!data.containsKey('reservations') ||
          !data.containsKey('services') ||
          !data.containsKey('users')) {
        throw Exception("Datos incompletos en el archivo JSON.");
      }

      final List<dynamic> reservations = data['reservations'];
      final List<dynamic> services = data['services'];
      final List<dynamic> users = data['users'];

      // Filtrar las reservaciones del usuario actual
      userReservations = reservations
          .where((reservation) => reservation['user_id'] == widget.userId)
          .map<Map<String, dynamic>>((reservation) {
        // Buscar el servicio relacionado
        final service = services.cast<Map<String, dynamic>>().firstWhere(
              (s) => s['id'] == reservation['service_id'],
          orElse: () => <String, dynamic>{},
        );

        // Buscar el cliente relacionado con el servicio
        final client = service.isNotEmpty
            ? users.cast<Map<String, dynamic>>().firstWhere(
              (u) => u['id'] == service['client_id'],
          orElse: () => <String, dynamic>{},
        )
            : null;

        return {
          ...reservation,
          'service_name': service.isNotEmpty
              ? service['name'] ?? "Servicio desconocido"
              : "Servicio desconocido",
          'business_name': client != null && client.isNotEmpty
              ? client['business_name'] ?? "Negocio desconocido"
              : "Negocio desconocido",
        };
      }).toList();

      // Actualizar las reservaciones para la fecha seleccionada
      updateReservationsForSelectedDay();

      setState(() {
        isLoading = false;
        errorMessage = "";
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error al cargar las reservaciones. Intenta nuevamente.";
        print("Error: $e");
      });
    }
  }

  void updateReservationsForSelectedDay() {
    final selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);

    setState(() {
      reservationsForSelectedDay = userReservations.where((reservation) {
        return reservation['date'] == selectedDateString;
      }).toList();
    });
  }

  void cancelReservation(int reservationId) {
    setState(() {
      // Eliminar la reservación de ambas listas
      userReservations.removeWhere((reservation) => reservation['id'] == reservationId);
      reservationsForSelectedDay.removeWhere((reservation) => reservation['id'] == reservationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservación cancelada con éxito.')),
    );
  }

  void showCancelDialog(int reservationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reservación'),
        content: const Text('¿Estás seguro de que deseas cancelar esta reservación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cancelReservation(reservationId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white),
            )
          ),
        ],
      ),
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
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      )
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
          // Lista de reservaciones
          Expanded(
            child: reservationsForSelectedDay.isEmpty
                ? const Center(
                child: Text("No hay reservaciones para este día."))
                : ListView.builder(
              itemCount: reservationsForSelectedDay.length,
              itemBuilder: (context, index) {
                final reservation = reservationsForSelectedDay[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(reservation['service_name']),
                    subtitle: Text(
                      "Hora: ${reservation['start_time']} - ${reservation['end_time']}\nLocal: ${reservation['business_name']}",
                    ),
                    trailing: TextButton(
                      onPressed: () => showCancelDialog(reservation['id']),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.red),
                      ),
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
