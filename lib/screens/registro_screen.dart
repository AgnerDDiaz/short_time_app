import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/components/custom_dropdown_form_field.dart';
import 'package:short_time_app/models/auth_models.dart';
import '../api/st_api_service.dart';
import '../components/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _roles = ['Trabajador', 'Usuario']; //lista de roles
  String mapRole(String role) {
    switch (role) {
      case 'Trabajador':
        return 'client';
      case 'Usuario':
        return 'user';
      default:
        return 'user';
    }
  }
  String _selectedRole = 'Usuario';
  final AuthService _authService = AuthService(apiClient: ShortTimeApiClient());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Control de visibilidad de la contraseña
  bool _isTermsAccepted = false; // Estado de la casilla de verificación
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  late final InputDecoration decoration;

  void _register() async {
    if (_formKey.currentState!.validate() && _isTermsAccepted) {
      try {
        final Map<String, String> additionalFields = {};
        if (_selectedRole == 'client') {
          additionalFields['businessName'] = _businessNameController.text;
          additionalFields['businessAddress'] = _businessAddressController.text;
          additionalFields['phoneNumber'] = _phoneNumberController.text;
        }
        final registerDto = RegisterDto(
          role: roleFromString(mapRole(_selectedRole)),
          name: nameController.text,
          email: emailController.text,
          passwordHash: passwordController.text,
          businessName: additionalFields['businessName'] ?? "",
          businessAddress: additionalFields['businessAddress'] ?? "",
          phoneNumber: additionalFields['phoneNumber'] ?? "",
        );
        await _authService.register(registerDto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Registro Completado!")),
        );
        Navigator.pushReplacementNamed(
            context, '/login'); // Usamos pushReplacement
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Por favor, complete todos los campos y acepte los términos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // Alinear a la izquierda
                children: [
                // Espaciado adicional al inicio para bajar el contenido
                SizedBox(height: 150),
                Text(
                  'Formulario de Registro',
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // Botón de regresar
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  ),
                ),
                SizedBox(height: 20),

                // Campo "Nombre"
                CustomTextFormField(
                  controller: nameController,
                  labelText: 'Nombre',
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese su nombre.";
                  }
                  return null;
                  },
                ),

                // Añadir espacio entre Nombre y los demás elementos
                SizedBox(height: 40),

                // Dropdown de roles
                CustomDropdownFormField(items: 
                _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(
                ), labelText: 'Tipo de Rol', onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                }, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor seleccione un rol.";
                  }
                  return null;
                }),
                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Email
                CustomTextFormField(
                  controller: emailController,
                  labelText: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese su correo electrónico.";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    return "Por favor ingrese una dirección de correo válida.";
                  }
                  return null;
                  },
                ),

                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Contraseña
                CustomTextFormField(
                  controller: passwordController,
                  labelText: 'Contraseña',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                    _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                    ),
                    onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                    },
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese una contraseña.";
                  }
                  if (value.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres.";
                  }
                  return null;
                  },
                ),

                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Confirmar Contraseña
                CustomTextFormField(
                  controller: confirmPasswordController,
                  labelText: 'Confirmar Contraseña',
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                    _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                    ),
                    onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                    },
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor confirme su contraseña.";
                  }
                  if (value != passwordController.text) {
                    return "Las contraseñas no coinciden.";
                  }
                  return null;
                  },
                ),
                SizedBox(height: 20),

                if (mapRole(_selectedRole) == 'client') ...[
                  CustomTextFormField(
                  controller: _businessNameController,
                  labelText: 'Nombre del Negocio',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return "Por favor, complete este campo.";
                    }
                    return null;
                  },
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                  controller: _businessAddressController,
                  labelText: 'Dirección del Negocio',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return "Por favor, complete este campo.";
                    }
                    return null;
                  },
                  ),
                  SizedBox(height: 20),
                  IntlPhoneField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de Teléfono',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder
                    (
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    ),
                  )),
                  SizedBox(height: 20),
                ],
                // Checkbox de Términos y Condiciones
                Row(
                  children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (value) {
                    setState(() {
                      _isTermsAccepted = value!;
                    });
                    },
                  ),
                  Expanded(
                    child: Text(
                    'He leído y acepto los Términos y Condiciones y la Política de Privacidad.',
                    style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ],
                ),

                SizedBox(height: 30), // Espaciado adicional

                // Botón de registro
                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color del botón
                  minimumSize: Size(double.infinity, 50),
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
