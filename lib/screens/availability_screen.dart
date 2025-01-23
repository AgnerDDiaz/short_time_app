import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../api/api_availability.dart';

class AvailabilityScreen extends StatefulWidget {
  final int serviceId;
  final String serviceName;
  final int serviceDuration;

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
  final _availabilityApi = AvailabilityApi();
  DateTime selectedDate = DateTime.now();
  List<String> availableSlots = [];
  List<String> reservedSlots = [];
  Map<String, bool> buttonStates = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadServiceAvailability();
  }

  Future<void> loadServiceAvailability() async {
    try {
      setState(() => isLoading = true);

      final data = await _availabilityApi.getServiceAvailability(
          widget.serviceId,
          DateFormat('yyyy-MM-dd').format(selectedDate)
      );

      final openingTime = data['opening_time'] ?? "09:00";
      final closingTime = data['closing_time'] ?? "17:00";

      setState(() {
        reservedSlots = List<String>.from(data['reserved_slots'] ?? []);
        generateTimeSlots(openingTime, closingTime);
        isLoading = false;
      });

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar disponibilidad'))
      );
    }
  }

  void generateTimeSlots(String openingTime, String closingTime) {
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

      final slotString = "${DateFormat.jm().format(current)} - ${DateFormat.jm().format(nextSlot)}";

      if (!reservedSlots.contains(slotString)) {
        slots.add(slotString);
        buttonStates[slotString] = false;
      }
      current = nextSlot;
    }

    setState(() {
      availableSlots = slots;
    });
  }

  Future<void> reserveSlot(String slot) async {
    try {
      final [startTime, endTime] = slot.split(' - ');

      await _availabilityApi.createReservation(
          serviceId: widget.serviceId,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
          startTime: startTime,
          endTime: endTime
      );

      setState(() {
        reservedSlots.add(slot);
        availableSlots.remove(slot);
        buttonStates[slot] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reserva creada exitosamente'))
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la reserva'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilidad de ${widget.serviceName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
              loadServiceAvailability();
            },
            calendarStyle: const CalendarStyle(
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
                        : () => reserveSlot(slot),
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