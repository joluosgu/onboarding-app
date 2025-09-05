
import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administrador')),
      body: Column(
        children: [
          const Expanded(child: Center(child: Text('Aquí verás el avance de todos los usuarios.'))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Aquí se integraría el envío de sugerencias por correo
              },
              child: const Text('Ver sugerencias'),
            ),
          )
        ],
      ),
    );
  }
}
