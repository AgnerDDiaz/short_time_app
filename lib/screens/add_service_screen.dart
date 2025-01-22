import 'package:flutter/material.dart';

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

  void _clearFields() {
    serviceNameController.clear();
    serviceDescriptionController.clear();
    servicePriceController.clear();
    serviceDurationController.clear();
  }

  void _addService() {
    if (_formKey.currentState!.validate()) {
      // Simular el registro del servicio
      _clearFields();
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
                  decoration: InputDecoration(
                    labelText: 'Nombre del Servicio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                  decoration: InputDecoration(
                    labelText: 'Precio (\$)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                  decoration: InputDecoration(
                    labelText: 'Duración (minutos)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                const SizedBox(height: 32.0),

                // Botón de agregar servicio
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
