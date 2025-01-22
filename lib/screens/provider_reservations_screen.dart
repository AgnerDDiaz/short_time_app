import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProviderReservationsScreen extends StatefulWidget {
  final int clientId;

  const ProviderReservationsScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ProviderReservationsScreen> createState() => _ProviderReservationsScreenState();
}

class _ProviderReservationsScreenState extends State<ProviderReservationsScreen> {
  List<Map<String, dynamic>> providerReservations = [];
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
      if (!data.containsKey('reservations') || !data.containsKey('services')) {
        throw Exception("Datos incompletos en el archivo JSON.");
      }

      final List<dynamic> reservations = data['reservations'];
      final List<dynamic> services = data['services'];

      // Filtrar las reservaciones del proveedor actual
      providerReservations = reservations
          .where((reservation) {
        final service = services.firstWhere(
              (s) => s['id'] == reservation['service_id'] && s['client_id'] == widget.clientId,
          orElse: () => null,
        );
        return service != null;
      })
          .map<Map<String, dynamic>>((reservation) {
        final service = services.firstWhere(
              (s) => s['id'] == reservation['service_id'],
          orElse: () => <String, dynamic>{},
        );

        return {
          ...reservation,
          'service_name': service['name'] ?? "Servicio desconocido",
          'comment': reservation['comment'] ?? "Sin comentarios",
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
      reservationsForSelectedDay = providerReservations.where((reservation) {
        return reservation['date'] == selectedDateString;
      }).toList();
    });
  }

  Future<void> deleteAllReservationsForDay() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar todas las reservaciones de este día? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white),
              )
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      setState(() {
        providerReservations.removeWhere((reservation) => reservation['date'] == DateFormat('yyyy-MM-dd').format(selectedDate));
        reservationsForSelectedDay.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todas las reservaciones del día han sido eliminadas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservaciones"),
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
              return providerReservations
                  .where((reservation) => reservation['date'] == dayStr)
                  .toList();
            },
          ),
          const SizedBox(height: 16),
          // Lista de reservaciones
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(reservation['service_name']),
                    subtitle: Text("Comentario: ${reservation['comment']}\nHora: ${reservation['start_time']} - ${reservation['end_time']}"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Botón para eliminar todas las reservaciones
          ElevatedButton(
            onPressed: reservationsForSelectedDay.isEmpty
                ? null
                : deleteAllReservationsForDay,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Eliminar todas las reservaciones del día"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
