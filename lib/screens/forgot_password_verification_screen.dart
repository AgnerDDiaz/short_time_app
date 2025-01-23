import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/components/custom_dialog.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  static const routeName = '/forgotPassword';

  @override
  _ForgotPasswordVerificationScreenState createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(apiClient: ShortTimeApiClient());
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });

      final email = emailController.text;
      final newPassword = passwordController.text;
      // Obtener el código de verificación del campo de texto como un número
      final otp = int.tryParse(otpController.text) ?? 0;
      print('Email: $email, New Password: $newPassword, OTP: $otp');

      try {
        await _authService.verifyChangePassword(email, newPassword, otp);
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (ctx) => AcceptDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            onAccept: () {
              Navigator.of(ctx).pop();
            },
          ),
        );
        setState(() {
          _isLoading = false; // Ocultar indicador de carga
        });
        return;
      }
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
              title: Text('Password Reset'),
              content: Text(
                  'Your password has been reset successfully. Please login.'),
              onAccept: () {
                Navigator.pushNamed(context, '/login');
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    emailController.text = email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password Verification"),
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
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),

                  // Campo de texto para el correo electrónico
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Borde redondeado
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
                  SizedBox(height: 12.0),

                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Esquinas redondeadas
                      ),
                      prefixIcon: const Icon(Icons.lock),
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
                        return "Please enter your password.";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 4.0),
                  ListTile(
                    title: Text('Código de verificación'),
                    subtitle: Text(
                        'Introduce el código de verificación enviado a tu correo electrónico'),
                  ),

                  SizedBox(height: 2.0),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Colors.black,
                    focusedBorderColor: Colors.blue,
                    onSubmit: (value) {
                      otpController.text = value;
                    },
                  ),
                  SizedBox(height: 16.0),

                  // Botón para enviar el correo de restablecimiento de contraseña
                  _isLoading
                      ? CircularProgressIndicator() // Indicador de carga
                      : ElevatedButton(
                          onPressed: _resetPassword,
                          child: Text("Reset Password"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                  SizedBox(height: 16.0),

                  // Enlace para volver a la pantalla de login
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(); // Volver al Login
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
