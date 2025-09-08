
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UserTasksScreen extends StatefulWidget {
  @override
  _UserTasksScreenState createState() => _UserTasksScreenState();
}

class _UserTasksScreenState extends State<UserTasksScreen> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> tareas = [];
  int? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)?.settings.arguments as int?;
    if (userId != null) {
      cargarTareas();
    }
  }

  void cargarTareas() async {
    final resultado = await supabase.obtenerTareas(userId!);
    setState(() {
      tareas = resultado;
    });
  }

  void marcarComoCompletada(int tareaId) async {
    await supabase.marcarTareaCompletada(tareaId);
    cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          final tarea = tareas[index];
          return ListTile(
            title: Text(tarea['titulo'] ?? ''),
            subtitle: Text(tarea['descripcion'] ?? ''),
            trailing: tarea['completada'] == true
                ? Icon(Icons.check, color: Colors.green)
                : IconButton(
                    icon: Icon(Icons.check_box_outline_blank),
                    onPressed: () => marcarComoCompletada(tarea['id']),
                  ),
          );
        },
      ),
    );
  }
}
