import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';  // Importa google_fonts


class ProfilePageBussines extends StatefulWidget {
  @override
  _ProfilePageBussinesState createState() => _ProfilePageBussinesState();
}

class _ProfilePageBussinesState extends State<ProfilePageBussines> {
  File? _profileImage;

  // Datos ficticios del usuario (puedes reemplazarlos por datos reales o dinámicos)
  final String userName = "Kelvin García";
  final String userEmail = "kelvin.garcia@example.com";

  // Método para seleccionar una imagen desde la galería o la cámara
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _logout() {
    // Navegar a la pantalla de inicio de sesión
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Imagen de perfil
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
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
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Nombre del usuario
            Text(
              userName,
              style: GoogleFonts.inter( // Aplicar la fuente "Inter"
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Correo electrónico del usuario
            Text(
              userEmail,
              style: GoogleFonts.inter( // Aplicar la fuente "Inter"
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Opciones de perfil
            const Divider(),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Manage Availability'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/manageAvailability');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_business),
              title: Text(
                "Add Service",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/add_service'); // Navega a la nueva pantalla
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Manage Services'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/manageServices');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(
                "Notifications",
                style: GoogleFonts.inter(), // Aplicar la fuente "Inter"
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(
                "Appearance",
                style: GoogleFonts.inter(), // Aplicar la fuente "Inter"
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: _logout, // Llamar al método de cerrar sesión
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.blue),
                const SizedBox(width: 5),
                Text(
                  "Logout",
                  style: GoogleFonts.inter( // Aplicar la fuente "Inter"
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
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
