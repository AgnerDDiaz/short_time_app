import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/states/auth_state.dart';
import '../api/auth_service.dart';
import '../api/user_service.dart';
import '../components/custom_text_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final AuthService _authService = AuthService(apiClient: ShortTimeApiClient());
  final UserService _userService = UserService(apiClient: ShortTimeApiClient());
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text('Cambiar Contraseña', style: TextStyle(color: Colors.white)),
                    foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<String>(
          future: _userService
              .getUserById(value.verifyTokenResponseDto!.sub)
              .then((user) => user.email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextFormField(
                        controller: TextEditingController(text: snapshot.data),
                        labelText: "Correo Electrónico",
                        enabled: false,
                      ),
                      SizedBox(height: 30),
                        CustomTextFormField(
                        controller: _oldPasswordController,
                        labelText: 'Contraseña Antigua',
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        obscureText: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                          return 'Por favor, ingrese su contraseña antigua';
                          }
                          return null;
                        },
                        ),

                        SizedBox(height: 10),
                        CustomTextFormField(
                        controller: _newPasswordController,
                        labelText: 'Nueva Contraseña',
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        obscureText: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                          return 'Por favor, ingrese su nueva contraseña';
                          }
                          return null;
                        },
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _changePassword(snapshot.data!),
                        child: Text('Cambiar Contraseña'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  void _changePassword(String email) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        await _authService.changePassword(
          email,
          _oldPasswordController.text,
          _newPasswordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña cambiada con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña antigua inválida')),
        );
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}

