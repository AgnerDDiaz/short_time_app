import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
import 'package:short_time_app/components/custom_dialog.dart';

class VerifyMailScreen extends StatefulWidget {
  @override
  _VerifyMailScreenState createState() => _VerifyMailScreenState();
}

class _VerifyMailScreenState extends State<VerifyMailScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService authService = AuthService(apiClient: ShortTimeApiClient());
  bool isSendingEmail = false;
  bool isSendingVerificationCode = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void resendVerificationCode() async {
    try {
      setState(() {
        isSendingEmail = true;
      });
      await authService.resendVerificationCode();
      // Show success message
      await showDialog(
          context: context,
          builder: (context) => AcceptDialog(
                title: Text('Success'),
                content: Text('Verification code sent successfully'),
                onAccept: () {
                  Navigator.of(context).pop();
                },
              ));
    } catch (e) {
      // Show error message
      await showDialog(
          context: context,
          builder: (context) => AcceptDialog(
                title: Text('Error'),
                content: Text('Failed to resend verification code'),
                onAccept: () {
                  Navigator.of(context).pop();
                },
              ));
    } finally {
      setState(() {
        isSendingEmail = false;
      });
    }
  }

  void sendVerificationCode() async {
    if (_otpController.text.length != 6) {
      return;
    }
    try {
      setState(() {
        isSendingVerificationCode = true;
      });
      await authService.verifyEmail(int.parse(_otpController.text));
      // Show success message
      await showDialog(
          context: context,
          builder: (context) => AcceptDialog(
                title: Text('Success'),
                content: Text('Email verified successfully'),
                onAccept: () {
                  Navigator.of(context).pop();
                },
              ));
      Navigator.of(context).pushNamed('/home');
    } catch (e) {
      // Show error message
      await showDialog(
          context: context,
          builder: (context) => AcceptDialog(
                title: Text('Error'),
                content: Text('Failed to resend verification code'),
                onAccept: () {
                  Navigator.of(context).pop();
                },
              ));
    } finally {
      setState(() {
        isSendingVerificationCode = false;
      });
    }
  }

  void _verifyOtp() {
    // Implement OTP verification logic here
    final otp = _otpController.text;
    if (otp.isNotEmpty) {
      sendVerificationCode();
      // Call your verification API
    } else {
      showDialog(context: context, builder: (context) => AcceptDialog(
        title: Text('Error'),
        content: Text('Please enter the OTP code'),
        onAccept: () {
          Navigator.of(context).pop();
        },
      ));
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  bottom: 50.0), // Agregar margen superior
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/icon/Short_Time Logo Claro.jpg'), // Ruta del logo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              title: Text('Código de verificación'),
              subtitle: Text(
                  'Introduce el código de verificación enviado a tu correo electrónico'),
            ),
            SizedBox(height: 2.0),
            OtpTextField(
              focusedBorderColor: Colors.blue,

              // controller: _otpController,
              numberOfFields: 6,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
              onSubmit: (value) {
                _otpController.text = value;
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Botón redondeado
                  ),
                ),
                child: !isSendingEmail
                    ? const Text(
                        "Verify",
                        style: TextStyle(fontSize: 18),
                      )
                    : CircularProgressIndicator(
                        color: Colors.blue,
                      ),
              ),
            ),
            SizedBox(height: 20),
            if (isSendingEmail)
              CircularProgressIndicator(
                color: Colors.blue,
              )
            else
              TextButton(
                onPressed: () {
                  resendVerificationCode();
                },
                child: const Text(
                  "Resend Email",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
