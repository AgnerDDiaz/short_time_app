import 'package:flutter/material.dart';

class EditServiceScreen extends StatefulWidget {
  final Map<String, dynamic> serviceData; // Datos del servicio a editar

  const EditServiceScreen({Key? key, required this.serviceData}) : super(key: key);

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController serviceNameController;
  late TextEditingController servicePriceController;
  late TextEditingController serviceDurationController;
  late TextEditingController serviceDescriptionController;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores con datos existentes
    serviceNameController = TextEditingController(text: widget.serviceData['name']);
    servicePriceController = TextEditingController(text: widget.serviceData['price'].toString());
    serviceDurationController = TextEditingController(text: widget.serviceData['service_duration'].toString());
    serviceDescriptionController = TextEditingController(text: widget.serviceData['description']);
  }

  @override
  void dispose() {
    // Liberar recursos
    serviceNameController.dispose();
    servicePriceController.dispose();
    serviceDurationController.dispose();
    serviceDescriptionController.dispose();
    super.dispose();
  }

  void _updateService() {
    if (_formKey.currentState!.validate()) {
      // Simular actualización en backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio actualizado exitosamente.')),
      );

      Navigator.pop(context); // Volver a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el servicio. Verifique los datos ingresados.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Servicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                      return 'El nombre del servicio es obligatorio.';
                    }
                    if (value.length < 4 || value.length > 40) {
                      return 'El nombre debe tener entre 4 y 40 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                      return 'El precio es obligatorio.';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'El precio debe ser un número válido mayor a 0.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                      return 'La duración es obligatoria.';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration < 15 || duration > 480) {
                      return 'La duración debe estar entre 15 y 480 minutos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Descripción del servicio
                TextFormField(
                  controller: serviceDescriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria.';
                    }
                    if (value.length < 10 || value.length > 160) {
                      return 'La descripción debe tener entre 10 y 160 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit Service',
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
