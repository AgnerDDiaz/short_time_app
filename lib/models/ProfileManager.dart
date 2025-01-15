import 'package:flutter/foundation.dart';
import 'user_profile.dart';

class ProfileManager extends ChangeNotifier{
  UserProfile? _userProfile;

  UserProfile? get userprofile => _userProfile;

  bool get isCliente => _userProfile?.role == 'cliente';


  bool get isUsuario => _userProfile?.role == 'usuario';


  void setProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }


  Future<void> updateProfile({
    String? nombre,
    String? email,
    String? fotoPerfil,
  }) async {
    if (_userProfile == null) return;


    try {

      await Future.delayed(Duration(seconds: 1));

      _userProfile = _userProfile!.copyWith(
        nombre: nombre,
        email: email,
        fotoPerfil: fotoPerfil,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar el perfil');
    }
  }


  Future<void> updateProfilePhoto(String newPhotoUrl) async {
    if (_userProfile == null) return;

    try {

      await Future.delayed(Duration(seconds: 1));

      _userProfile = _userProfile!.copyWith(
        fotoPerfil: newPhotoUrl,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar la foto de perfil');
    }
  }


  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }
}
