import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AvailabilityScreen extends StatefulWidget {
  final int serviceId; // ID del servicio
  final String serviceName; // Nombre del servicio
  final int serviceDuration; // Duración del servicio en minutos

  const AvailabilityScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDuration,
  }) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime selectedDate = DateTime.now(); // Día seleccionado
  List<String> availableSlots = []; // Horarios disponibles
  List<String> reservedSlots = []; // Horarios reservados
  Map<String, bool> buttonStates = {}; // Estado individual de cada botón
  String openingTime = "09:00"; // Hora de apertura (por defecto)
  String closingTime = "17:00"; // Hora de cierre (por defecto)
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    loadServiceAvailability();
  }

  Future<void> loadServiceAvailability() async {
    try {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Obtener disponibilidad del servicio
      final availability = data['availability'] ?? [];
      final serviceAvailability = availability
          .where((slot) => slot['service_id'] == widget.serviceId)
          .toList();

      if (serviceAvailability.isNotEmpty) {
        final todayAvailability = serviceAvailability.firstWhere(
              (slot) => slot['day'] == DateFormat('EEEE').format(selectedDate).toLowerCase(),
          orElse: () => null,
        );

        if (todayAvailability != null) {
          openingTime = todayAvailability['opening_time'];
          closingTime = todayAvailability['closing_time'];
        }
      }

      // Cargar horarios reservados
      final reservations = data['reservations'] ?? [];
      reservedSlots = reservations
          .where((res) =>
      res['service_id'] == widget.serviceId &&
          res['date'] == DateFormat('yyyy-MM-dd').format(selectedDate))
          .map<String>((res) {
        return "${res['start_time']} - ${res['end_time']}";
      }).toList();

      // Generar horarios disponibles
      generateTimeSlots();
    } catch (e) {
      print('Error al cargar datos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void generateTimeSlots() {
    final opening = DateFormat("HH:mm").parse(openingTime);
    final closing = DateFormat("HH:mm").parse(closingTime);
    final duration = widget.serviceDuration;

    List<String> slots = [];
    DateTime current = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      opening.hour,
      opening.minute,
    );

    final endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      closing.hour,
      closing.minute,
    );

    while (current.isBefore(endOfDay)) {
      final nextSlot = current.add(Duration(minutes: duration));
      if (nextSlot.isAfter(endOfDay)) break;

      final slotString =
          "${DateFormat.jm().format(current)} - ${DateFormat.jm().format(nextSlot)}";
      if (!reservedSlots.contains(slotString)) {
        slots.add(slotString);
        buttonStates[slotString] = false; // Inicializa como no reservado
      }
      current = nextSlot;
    }

    setState(() {
      availableSlots = slots;
      isLoading = false;
    });
  }

  void reserveSlot(String slot) {
    setState(() {
      reservedSlots.add(slot);
      availableSlots.remove(slot);
      buttonStates[slot] = true; // Actualiza el estado del botón a reservado
    });

    // Simular el envío al backend
    print('Reservación realizada para el horario: $slot');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilidad de ${widget.serviceName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Calendario
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                isLoading = true;
              });
              loadServiceAvailability();
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Horarios disponibles
          Expanded(
            child: availableSlots.isEmpty && reservedSlots.isEmpty
                ? const Center(child: Text('No hay horarios disponibles.'))
                : ListView.builder(
              itemCount: availableSlots.length + reservedSlots.length,
              itemBuilder: (context, index) {
                final isReserved = index >= availableSlots.length;
                final slot = isReserved
                    ? reservedSlots[index - availableSlots.length]
                    : availableSlots[index];

                return ListTile(
                  title: Text(
                    slot,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    onPressed: isReserved || buttonStates[slot] == true
                        ? null
                        : () {
                      reserveSlot(slot);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReserved || buttonStates[slot] == true
                          ? Colors.grey
                          : Colors.blue,
                    ),
                    child: Text(
                      isReserved || buttonStates[slot] == true
                          ? 'Reservado'
                          : 'Reservar',
                      style: const TextStyle(color: Colors.white),
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
