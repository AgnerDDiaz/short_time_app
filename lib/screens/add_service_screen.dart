import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceDescriptionController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDurationController = TextEditingController();

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  void _clearFields() {
    serviceNameController.clear();
    serviceDescriptionController.clear();
    servicePriceController.clear();
    serviceDurationController.clear();
    setState(() {
      openingTime = null;
      closingTime = null;
    });
  }

  Future<void> _selectTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isOpeningTime) {
          openingTime = picked;
        } else {
          closingTime = picked;
        }
      });
    }
  }

  void _addService() {
    if (_formKey.currentState!.validate()) {
      // Simular el registro del servicio
      setState(() {
        _clearFields();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service registered successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register service.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del servicio
                TextFormField(
                  controller: serviceNameController,
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the service name.';
                    }
                    if (value.length < 4 || value.length > 40) {
                      return 'Name must be between 4 and 40 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Descripción del servicio
                TextFormField(
                  controller: serviceDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Service Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 10 || value.length > 160) {
                      return 'Description must be between 10 and 160 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Precio del servicio
                TextFormField(
                  controller: servicePriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price of the service.';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Duración del servicio
                TextFormField(
                  controller: serviceDurationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the duration of the service.';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration < 15 || duration > 480) {
                      return 'Duration must be between 15 and 480 minutes.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Tiempo de apertura y cierre
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Opening Time'),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            openingTime == null
                                ? 'Select Time'
                                : openingTime!.format(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Closing Time'),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            closingTime == null
                                ? 'Select Time'
                                : closingTime!.format(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // Botón de agregar servicio
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Add Service',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
