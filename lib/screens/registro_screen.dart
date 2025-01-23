import 'package:flutter/material.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/models/auth_models.dart';
import '../api/st_api_service.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _roles = ['client', 'user']; //lista de roles
  String _selectedRole = 'client';
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
          role: roleFromString(_selectedRole),
          name: nameController.text,
          email: emailController.text,
          passwordHash: passwordController.text,
          businessName: additionalFields['businessName'] ?? "",
          businessAddress: additionalFields['businessAddress'] ?? "",
          phoneNumber: additionalFields['phoneNumber'] ?? "",
        );
        await _authService.register(registerDto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro Completado!")),
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
                SizedBox(height: 20),

                // Campo "Name"
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borde redondeado
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name.";
                    }
                    return null;
                  },
                ),

                // Añadir espacio entre Name y los demás elementos
                SizedBox(height: 40),

                // Dropdown de roles
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Tipo de Rol',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borde redondeado
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email.";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Password
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borde redondeado
                    ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password.";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters long.";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20), // Espaciado entre los campos

                // Campo Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borde redondeado
                    ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password.";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                if (_selectedRole == 'client') ...[
                  TextFormField(
                    controller: _businessNameController,
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, complete este campo.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _businessAddressController,
                    decoration: InputDecoration(
                      labelText: 'Business Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, complete este campo.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, complete este campo.";
                      }
                      return null;
                    },
                  ),
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
                        'I have read and accept the Terms and Conditions and Privacy Policy.',
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
                    'Create',
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
