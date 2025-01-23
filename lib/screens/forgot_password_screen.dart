import 'package:flutter/material.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/components/custom_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotPassword';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(apiClient: ShortTimeApiClient());
  bool _isLoading = false;

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });

      await Future.delayed(Duration(seconds: 2)); // Simular un retraso para la carga

      String email = emailController.text;

       await _authService.forgotPassword(email);

      // Simulación del envío del correo para restablecer la contraseña
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });

      // Simulación de éxito
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AcceptDialog(
        title: Text('Success'),
        content: Text('A password reset link has been sent to your email.'),
        onAccept: () {
          Navigator.of(ctx).pop();
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    "Reset your Password",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),

                  // Campo de texto para el correo electrónico
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), // Borde redondeado
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
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
                  SizedBox(height: 16.0),

                  // Botón para enviar el correo de restablecimiento de contraseña
                  _isLoading
                      ? CircularProgressIndicator() // Indicador de carga
                      : ElevatedButton(
                    onPressed: _sendPasswordResetEmail,
                    child: Text("Send Reset Link"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgotPasswordVerification'); // Volver al Login
                    },
                    child: Text(
                      "I already have a code",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),



                  // Enlace para volver a la pantalla de login
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login'); // Volver al Login
                    },
                    child: Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
