import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });

      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final authManager = Provider.of<AuthManager>(context, listen: false);

      final isAuthenticated = await authManager.login(email, password);

      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });

      if (isAuthenticated) {
        if (authManager.userType == 'client') {
          Navigator.pushReplacementNamed(context, '/clientHome');
        } else if (authManager.userType == 'business') {
          Navigator.pushReplacementNamed(context, '/businessHome');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder para imagen o logo
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24.0),

                  // Título
                  Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),

                  // Campo de texto para email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email.";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  // Campo de texto para contraseña
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
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
                  SizedBox(height: 16.0),

                  // Botón "Forgot password?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Acción para recuperar contraseña
                      },
                      child: Text("Forgot password?"),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Botón de inicio de sesión
                  _isLoading
                      ? CircularProgressIndicator() // Indicador de carga
                      : ElevatedButton(
                    onPressed: _login,
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Opciones de registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Client? "),
                      GestureDetector(
                        onTap: () {
                          // Navega a pantalla de registro de usuarios
                        },
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Are you a Business? "),
                      GestureDetector(
                        onTap: () {
                          // Navega a pantalla de registro de negocios
                        },
                        child: Text(
                          "Login here",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
