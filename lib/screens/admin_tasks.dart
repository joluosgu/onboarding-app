import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class Admintasks extends StatefulWidget {
  @override
  _AdmintasksState createState() => _AdmintasksState();
}

class _AdmintasksState extends State<Admintasks> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> tareas = [];

  @override
  void initState() {
   
    super.initState();
    cargarTareas();
  }

  
Future<void> cargarTareas() async {
  final resultado = await supabase.obtenerTodasLasTareas();
  if (mounted) {
    setState(() {
      tareas = resultado;
      print('Tareas actualizadas: ${tareas.length}');
    });
  }
}



  void _confirmarEliminacion(int tareaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003057),
            ),
          ),
          content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF003057)),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo
                await supabase.eliminarTarea(tareaId); // Elimina en Supabase
                
                await cargarTareas(); // Recarga la lista desde Supabase

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tarea eliminada correctamente')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF003057),
          ),
        ),
        title: Text(
          'Administrar Tareas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          final tarea = tareas[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Tarea: ${tarea['title'] ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003057),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(tarea['id']),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Descripción: ${tarea['description'] ?? ''}'),
                  SizedBox(height: 4),
                  Text('Role: ${tarea['role'] ?? ''}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
