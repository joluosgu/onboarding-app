import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
        if (tareas.isNotEmpty) {
          print('Primera tarea ejemplo: ${tareas[0]}');
        }
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
                Navigator.of(context).pop(); // Cierra el diálogo primero
                await supabase.eliminarTarea(tareaId); // Elimina en Supabase
                await cargarTareas(); // Espera a que termine de cargar
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarea eliminada correctamente')),
                  );
                }
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
      backgroundColor: Color(0xFFE0E0E0), // Gris muy claro
      appBar: AppBar(
        backgroundColor: Color(0xFF333333), // Gris oscuro
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
            color: Colors.white, // Fondo blanco para la tarjeta
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
                            color: Color(0xFF333333), // Gris oscuro
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

                  // Mostrar el campo role
                  Text(
                    'Role: ${tarea['role'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    'Descripción: ${tarea['description'] ?? ''}',
                    style: TextStyle(color: Color(0xFF333333)), // Gris oscuro
                  ),
                  SizedBox(height: 4),
                  tarea['link'] != null && tarea['link'].toString().isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            final url = tarea['link'].toString();
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            tarea['link'],
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : Text(
                          '',
                          style: TextStyle(color: Color(0xFFB0B0B0)),
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
