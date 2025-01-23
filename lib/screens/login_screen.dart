import 'package:flutter/material.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/api/st_api_service.dart';
import 'forgot_password_screen.dart'; // Importar la pantalla de recuperación de contraseña

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService(apiClient: ShortTimeApiClient());
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await authService.login(
            emailController.text, passwordController.text);

        if (!mounted) return;

        if (result.accessToken != null) {
          // Store the accessToken
          // Store the accessToken
          await authService.storeAccessToken(result.accessToken);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog('Credenciales invalidas. ');
        }
      } catch (e) {
        print('\n\n\n');
        print('Error en el login: $e');
        _showErrorDialog('Credenciales invalidas. ');
        print('\n\n\n');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter', // Establecer la fuente global
      ),
      home: Scaffold(
        backgroundColor: Colors.white, // Fondo blanco
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo personalizable con margen superior
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 50.0), // Agregar margen superior
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/icon/Short_Time Logo Claro.jpg'), // Ruta del logo
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Título
                    Align(
                      alignment: Alignment
                          .centerLeft, // Alinea el texto hacia la izquierda
                      child: Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Campo de texto para email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Esquinas redondeadas
                        ),
                        prefixIcon: const Icon(Icons.email),
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
                    const SizedBox(height: 14.0),

                    // Campo de texto para contraseña
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
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
                    const SizedBox(height: 14.0),

                    // Enlace "Forgot password?"
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName);
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Añadir un SizedBox antes del botón para separarlo más
                    const SizedBox(
                        height: 30.0), // Ajusta la cantidad de espacio aquí

                    // Botón de inicio de sesión
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Botón redondeado
                              ),
                            ),
                          ),
                    const SizedBox(height: 16.0),

                    // Enlace "Register now"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a Client? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Enlace "Are you a Business?"
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text("Are you a Business? "),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pushNamed(context, '/emptyPage');
                    //       },
                    //       child: const Text(
                    //         "Login here",
                    //         style: TextStyle(
                    //           color: Colors.blue,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
