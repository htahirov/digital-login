import 'package:flutter/material.dart';
import 'dart:developer' as logger;
import 'package:digital_login/digital_login.dart';

void main() => runApp(const MyApp());

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Login Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

/// The login page where users can initiate digital authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// The digital login controller instance.
  final _digitalLoginController = DigitalLoginController.instance;

  @override
  void initState() {
    super.initState();

    /// Listen for digital login authentication code from the stream.
    _digitalLoginController.digitalCodeStream.listen((code) {
      logger.log('Digital code received: $code');
      /// Handle login success or further authentication steps here.
    });
  }

  @override
  void dispose() {
    /// Dispose of the controller to prevent memory leaks.
    _digitalLoginController.dispose();
    super.dispose();
  }

  /// Starts the digital login process by invoking the login method.
  void _startLogin() => _digitalLoginController.performLogin(
        url: 'your digital login base url', // The base URL for digital login.
        clientId: 'your clientId', // The application client ID.
        redirectUri: 'your redirectUri', // The deep link redirect URI.
        scheme: 'your scheme', // The deep link scheme.
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _startLogin,
          child: const Text('Digital Login'),
        ),
      ),
    );
  }
}
