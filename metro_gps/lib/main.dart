import 'package:flutter/material.dart';
import '../pantalla_autenticacion.dart';


void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaAutenticacion(
        onLoginSubmit: (json) {
          debugPrint('LOGIN => $json');
        },
        onRegistroSubmit: (json) {
          debugPrint('REGISTRO => $json');
        },
      ),
    );
  }
}