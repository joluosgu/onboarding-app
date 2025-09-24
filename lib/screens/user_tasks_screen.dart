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
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      userId = args;
      cargarTareas();
    }
  }

  void cargarTareas() async {
    if (userId != null) {
      final resultado = await supabase.obtenerTareas(userId!);
      setState(() {
        tareas = resultado;
      });
    }
  }

  void marcarComoCompletada(int tareaId) async {
    await supabase.marcarTareaCompletada(tareaId);
    cargarTareas();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0), // Fondo gris claro
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 23, 106, 173), // Color de fondo azul oscuro
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos horizontalmente
          children: [
            // Título principal de la AppBar
            Text(
              'Tareas Onboarding Galatea',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16), // Espacio entre los dos textos
            // Enlace para sugerencias
            GestureDetector(
              onTap: () {
                 Navigator.pushNamed(context, '/usersuggestions', arguments: userId);
              },
              child: Text(
                'Sugerencias',
                style: TextStyle(
                  color: Color(0xFFffcd00),
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          final tarea = tareas[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
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
                            color: Color.fromARGB(255, 6, 44, 74), // Azul oscuro
                            fontSize: 16,
                          ),
                        ),
                      ),
                      tarea['completed'] == true
                ? Icon(Icons.check_circle, color: Colors.green)
                : IconButton(
                    icon: Icon(Icons.check_box_outline_blank, color: Color(0xFFffcd00)),
                    onPressed: () => marcarComoCompletada(tarea['id']),
                  ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Descripción: ${tarea['description'] ?? ''}',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rol: ${tarea['role'] ?? ''}',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
