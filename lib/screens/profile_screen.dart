// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ProfileManager.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          final user = profileManager.userprofile;
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: user.fotoPerfil != null
                              ? NetworkImage(user.fotoPerfil!)
                              : null,
                          child: user.fotoPerfil == null
                              ? Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 18,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit_profile');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.nombre,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${user.email.split('@')[0]}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              _buildMenuItem(
                context,
                'Servicios',
                Icons.miscellaneous_services_outlined,
                () => Navigator.pushNamed(context, '/services'),
              ),
              _buildMenuItem(
                context,
                'Notificaciones',
                Icons.notifications_none,
                () => Navigator.pushNamed(context, '/notifications'),
              ),
              _buildMenuItem(
                context,
                'Apariencia',
                Icons.palette_outlined,
                () => Navigator.pushNamed(context, '/appearance'),
              ),
              _buildMenuItem(
                context,
                'Idioma',
                Icons.language,
                () => Navigator.pushNamed(context, '/language'),
              ),
              _buildMenuItem(
                context,
                'Privacidad',
                Icons.lock_outline,
                () => Navigator.pushNamed(context, '/privacy'),
              ),
              _buildMenuItem(
                context,
                'Almacenamiento',
                Icons.storage_outlined,
                () => Navigator.pushNamed(context, '/storage'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
