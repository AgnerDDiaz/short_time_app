import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/user_service.dart';
import 'package:short_time_app/screens/login_screen.dart';
import 'package:short_time_app/screens/verify_mail_screen.dart';

import '../states/auth_state.dart';

class AuthCheck extends StatelessWidget {
  final UserService userService = UserService(apiClient: ShortTimeApiClient());
  final Widget loggedInWidget;

  AuthCheck({required this.loggedInWidget });



  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        if (authState.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.blue));
        }
        if(!authState.isLoggedIn){
          return LoginScreen();
        }
        print(authState.verifyTokenResponseDto);
        return FutureBuilder(
          future: userService.getUserById(authState.verifyTokenResponseDto!.sub),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            }
            if(snapshot.hasError){
              return const Center(child: Text("Error al cargar los datos del usuario"));
            }
            if(snapshot.data!.verified){
              return loggedInWidget;
            } 
            return VerifyMailScreen();
          });
        
      },
    );
  }
}