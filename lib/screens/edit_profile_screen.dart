import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/components/custom_dialog.dart';
import 'package:short_time_app/models/user.dart';
import 'package:short_time_app/components/custom_text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<GetUserByIdResponseDto> profileData;
  final _formKey = GlobalKey<FormState>();
  // Create all the necesary controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _businessName = TextEditingController();
  final _businessAddress = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final UserService _userService = UserService(apiClient: ShortTimeApiClient());
  final AuthService _authService = AuthService(apiClient: ShortTimeApiClient());

  @override
  void initState() {
    super.initState();
    profileData = _authService
        .verifyToken()
        .then((value) => _userService.getUserById(value.sub));
  }

  // UpdateUserDto userData = UpdateUserDto();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Perfil'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: FutureBuilder(
            future: profileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              final user = snapshot.data as GetUserByIdResponseDto;
              _nameController.text = user.name;
              _emailController.text = user.email;
              _businessName.text = user.businessName ?? '';
              _businessAddress.text = user.businessAddress ?? '';
              _phoneNumberController.text = user.phoneNumber ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Nombre',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su nombre.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: 'Correo Electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su correo electrónico.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                            return 'Por favor ingrese una dirección de correo válida.';
                          }
                          return null;
                        },
                      ),
                      ...(user.role == 'client'
                          ? [
                      SizedBox(height: 20),
                              CustomTextFormField(
                                controller: _businessName,
                                labelText: 'Nombre del Negocio',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese el nombre del negocio.';
                                  }
                                  return null;
                                },
                              ),

                      SizedBox(height: 20),
                              CustomTextFormField(
                                controller: _businessAddress,
                                labelText: 'Dirección del Negocio',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese la dirección del negocio.';
                                  }
                                  return null;
                                },
                              ),
                            ]
                          : []),

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
                      // IntlPhoneField(
                      //     controller: _phoneNumber,
                          
                      //     decoration: InputDecoration(
                      //       labelText: 'Número de Teléfono',
                      //       labelStyle: TextStyle(color: Colors.blue),
                      //       focusedBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.blue),
                      //       ),
                      //     )),
                      // ...additional fields based on UpdateUserDto...
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final result = await _userService.updateUser(
                              user.id,
                              UpdateUserDto(
                                name: _nameController.text,
                                email: _emailController.text,
                                businessName: _businessName.text,
                                businessAddress: _businessAddress.text,
                                phoneNumber: _phoneNumberController.text,
                              ),
                            );
                            showDialog(context: context, builder: (context) => AcceptDialog(
                              title: Text('Perfil Actualizado'),
                              content: Text('Tu perfil ha sido actualizado correctamente'),
                              onAccept: () => Navigator.of(context).pop(),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, llena todos los campos'),
                              ),
                            );
                          }
                        },
                        child: Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
