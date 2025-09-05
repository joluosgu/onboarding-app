
import 'package:flutter/material.dart';

class UserPanel extends StatelessWidget {
  final String email;
  const UserPanel({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Usuario')),
      body: Center(child: Text('Bienvenido $email. Aquí verás tus tareas.')),
    );
  }
}
