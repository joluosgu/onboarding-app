
import 'package:flutter/material.dart';

class UserTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: Center(child: Text('Aquí se mostrarán las tareas asignadas al usuario.')),
    );
  }
}
