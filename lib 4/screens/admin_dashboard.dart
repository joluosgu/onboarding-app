
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel de Administrador')),
      body: Center(child: Text('Aquí se verá el avance de tareas y se podrán crear nuevas.')),
    );
  }
}
