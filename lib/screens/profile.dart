import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mime/mime.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/api/profile_service.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/components/custom_dialog.dart';
import 'package:short_time_app/models/tab_manager.dart';
import 'package:short_time_app/models/user.dart'; // Importa google_fonts
import 'package:provider/provider.dart';
import 'package:short_time_app/states/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;
  final UserService userService;
  const ProfileScreen({required this.authService, required this.userService});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService =
      ProfileService(apiClient: ShortTimeApiClient());
  late Future<GetUserByIdResponseDto> _userProfile;

  Future<GetUserByIdResponseDto> getProfileData() async {
    final userId =
        await widget.authService.verifyToken().then((value) => value.sub);
    return await widget.userService.getUserById(userId);
  }

  @override
  void initState() {
    super.initState();
    _userProfile = getProfileData();
    // _userProfile = widget.userService.getUserById(widget.authService.verifyToken().then((value) => value.sub));
  }

  // Datos ficticios del usuario (puedes reemplazarlos por datos reales o dinámicos)
  // final String userName = "Kelvin García";
  // final String userEmail = "kelvin.garcia@example.com";

  // Método para seleccionar una imagen desde la galería o la cámara
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final mimeType = lookupMimeType(pickedFile.path)?.split('/');
        await _profileService.uploadProfilePicture(await MultipartFile.fromPath(
            'file', pickedFile.path,
            filename: pickedFile.path.split('/').last,
            contentType: MediaType(mimeType![0], mimeType[1])));
        setState(() {
          _userProfile = getProfileData();
        });
        showDialog(
            context: context,
            builder: (context) => AcceptDialog(
                  title: const Text('Success'),
                  content: const Text('Profile picture uploaded successfully'),
                  onAccept: () {
                    Navigator.of(context).pop();
                  },
                ));
      } catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AcceptDialog(
                  title: const Text('Error'),
                  content: const Text('Failed to upload profile picture'),
                  onAccept: () {
                    Navigator.of(context).pop();
                  },
                ));
      }
      // setState(() {
      //   _profileImage = File(pickedFile.path);
      // });
    }
  }

  void _logout() {
    // Navegar a la pantalla de inicio de sesión
    // await widget.authState.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        return Scaffold(
            body: FutureBuilder(
                future: _userProfile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.blue));
                  }
                  final user = snapshot.data as GetUserByIdResponseDto;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Imagen de perfil
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: user.profilePicture != null
                                  ? NetworkImage(user.profilePicture!)
                                  : null,
                              child: user.profilePicture == null
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.grey)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: const Icon(Icons.edit,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Nombre del usuario
                        Text(
                          user.name,
                          style: GoogleFonts.inter(
                            // Aplicar la fuente "Inter"
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Correo electrónico del usuario
                        Text(
                          user.email,
                          style: GoogleFonts.inter(
                            // Aplicar la fuente "Inter"
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Opciones de perfil
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.list),
                          title: Text('bussines prueba'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pushNamed(context, '/homebussines');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.nature_people),
                          title: Text(
                            "Modificar Perfil",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.nature_people),
                          title: Text(
                            "Cambiar Contraseña",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pushNamed(context, '/changePassword');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(
                            "Notifications",
                            style: GoogleFonts
                                .inter(), // Aplicar la fuente "Inter"
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.color_lens),
                          title: Text(
                            "Appearance",
                            style: GoogleFonts
                                .inter(), // Aplicar la fuente "Inter"
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                }),
            bottomNavigationBar:
                Consumer<TabManager>(builder: (context, tabManager, child) {
              return BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      await authState
                          .logout(); // Use the logout method from AuthState
                      // Reset Navigator stack
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => route.isFirst);
                      tabManager.selectedTab = 0;
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/login', (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text(
                          "Cerrar sesión",
                          style: GoogleFonts.inter(
                            // Aplicar la fuente "Inter"
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
      },
    );
  }
}
