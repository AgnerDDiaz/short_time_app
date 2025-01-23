import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/reservation_service.dart';
import 'package:short_time_app/models/availability.dart';
import 'package:short_time_app/models/reservation.dart';
import 'package:short_time_app/states/auth_state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../api/api_availability.dart';

class AvailabilityScreen extends StatefulWidget {
  final int serviceId;
  final int clientId;
  final String serviceName;
  final int serviceDuration;

  const AvailabilityScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDuration,
    required this.clientId,
  }) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final _availabilityApi = AvailabilityService(apiClient: ShortTimeApiClient());
  final _reservationApi = ReservationService(apiClient: ShortTimeApiClient());
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

      GetAvailabilityOfDateDto getAvailabilityOfDateDto = GetAvailabilityOfDateDto(
        userId: widget.clientId,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        duration: widget.serviceDuration,
      );

      final data = await _availabilityApi.getAvailabilityOfDate(getAvailabilityOfDateDto);
      setState(() {
        reservedSlots = data.results
            .where((slot) => !slot.available)
            .map((slot) => "${slot.startTime} - ${slot.endTime}")
            .toList();
        generateTimeSlots(data);
        isLoading = false;
      });

    } catch (e) {
      print(e);
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar disponibilidad'))
      );
    }
  }

  void generateTimeSlots(GetAvailabilityOfDateResponseDto data) {
    List<String> slots = [];
    for (var slot in data.results) {
      final slotString = "${slot.startTime} - ${slot.endTime}";
      if (slot.available) {
        slots.add(slotString);
        buttonStates[slotString] = false;
      }
    }

    setState(() {
      availableSlots = slots;
    });
  }

  DateTime convertTimeToDate(String time) {
    return DateFormat('yyyy-MM-dd HH:mm').parse('${selectedDate.year}-${selectedDate.month}-${selectedDate.day} $time');
  }

  Future<void> reserveSlot(String slot, int userId) async {
    try {
      final [startTime, endTime] = slot.split(' - ');

      CreateReservationDto dto = CreateReservationDto(
        userId: userId,
        serviceId: widget.serviceId,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        startTime: convertTimeToDate(startTime).toIso8601String() + 'Z',
        endTime: convertTimeToDate(endTime).toIso8601String() + 'Z',
        status: 'pending',
      );

      await _reservationApi.createReservation(dto);

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
      body: Consumer<AuthState>(builder: (context, auth, ds) {
        return isLoading
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
                          : () => reserveSlot(slot, auth.verifyTokenResponseDto!.sub),
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
        );
      }),
    );
  }
}