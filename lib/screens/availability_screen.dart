import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AvailabilityScreen extends StatefulWidget {
  final int clientId; // ID del cliente
  final String clientName; // Nombre del cliente
  final String openingTime; // Hora de apertura (por ejemplo, "09:00:00")
  final String closingTime; // Hora de cierre (por ejemplo, "18:00:00")
  final int serviceDuration; // Duración del servicio en minutos

  const AvailabilityScreen({
    Key? key,
    required this.clientId,
    required this.clientName,
    required this.openingTime,
    required this.closingTime,
    required this.serviceDuration,
  }) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime selectedDate = DateTime.now(); // Día seleccionado
  List<String> availableSlots = []; // Horarios disponibles
  List<String> reservedSlots = []; // Horarios reservados (simulados)

  @override
  void initState() {
    super.initState();
    loadReservedSlots();
    generateTimeSlots();
  }

  Future<void> loadReservedSlots() async {
    // Aquí simulamos las reservaciones cargadas desde el JSON (o backend)
    final simulatedReservedSlots = [
      "2025-01-13 10:00 AM - 11:00 AM", // Horario reservado de prueba
      "2025-01-13 02:00 PM - 03:00 PM"
    ];

    setState(() {
      reservedSlots = simulatedReservedSlots
          .where((slot) => slot.startsWith(DateFormat('yyyy-MM-dd').format(selectedDate)))
          .toList();
    });
  }

  void generateTimeSlots() {
    final openingTime = DateFormat("HH:mm:ss").parse(widget.openingTime);
    final closingTime = DateFormat("HH:mm:ss").parse(widget.closingTime);
    final duration = widget.serviceDuration;

    List<String> slots = [];
    DateTime current = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      openingTime.hour,
      openingTime.minute,
    );

    final endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      closingTime.hour,
      closingTime.minute,
    );

    while (current.isBefore(endOfDay)) {
      final nextSlot = current.add(Duration(minutes: duration));
      if (nextSlot.isAfter(endOfDay)) break;

      slots.add("${DateFormat.jm().format(current)} - ${DateFormat.jm().format(nextSlot)}");
      current = nextSlot;
    }

    //while (current.isBefore(endOfDay)) {
    //  final nextSlot = current.add(Duration(minutes: duration));
    //  if (nextSlot.isAfter(endOfDay)) break;

      //final slotString =
        //  "${DateFormat.jm().format(current)} - ${DateFormat.jm().format(nextSlot)}";
    //  if (!reservedSlots.contains("${DateFormat('yyyy-MM-dd').format(selectedDate)} $slotString")) {
      //  slots.add(slotString);
      //}
     // current = nextSlot;
    //}

    setState(() {
      availableSlots = slots;
    });
  }

  void reserveSlot(String slot) {
    setState(() {
      reservedSlots.add("${DateFormat('yyyy-MM-dd').format(selectedDate)} $slot");
      availableSlots.remove(slot);
    });

    // Aquí simulamos el envío al backend
    print('Reservación realizada para el horario: $slot');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilidad de ${widget.clientName}'),
      ),
      body: Column(
        children: [
          // Calendario para seleccionar un día
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
              loadReservedSlots();
              generateTimeSlots();
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
          Expanded(
            child: availableSlots.isEmpty
                ? const Center(child: Text('No hay horarios disponibles.'))
                : ListView.builder(
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final slot = availableSlots[index];
                return ListTile(
                  title: Text(slot),
                  trailing: ElevatedButton(
                    onPressed: () {
                      reserveSlot(slot);
                    },
                    child: const Text('Reservar'),
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
