import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserTasksScreen extends StatefulWidget {
  @override
  _UserTasksScreenState createState() => _UserTasksScreenState();
}

class _UserTasksScreenState extends State<UserTasksScreen> {
  final supabase = SupabaseService();

  List<Map<String, dynamic>> tareas = [];
  int? userId;
  String? userRole;
  bool yaHizoExamen = false;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final route = ModalRoute.of(context);
  if (route != null && route.settings.arguments != null) {
    final args = route.settings.arguments as Map<String, dynamic>;


        print("args");
print(args);
    userId = args['id'];
    userRole = args['role'];

    cargarTareas();
    verificarExamen();
  } else {
   
    // Manejar el caso en que no hay argumentos: 
    // por ejemplo, mostrar un error, asignar valores por defecto, o navegar a otra pantalla
    print('No se recibieron argumentos en la ruta.');
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

  void verificarExamen() async {
    if (userId != null) {
      final examenes = await supabase.obtenerResultadosExamenes();
      final yaHizo = examenes.any((e) => e['user_id'] == userId);
      setState(() {
        yaHizoExamen = yaHizo;
      });
    }
  }

  void irAPrueba() {
    print("userid");
print(userId);
    print("userrole");
print(userRole);

    Navigator.pushNamed(
      context,
      '/user_exam',
      arguments: {'userId': userId, 'role': userRole},
    );
  }

  void marcarComoCompletada(int tareaId) async {
    await supabase.marcarTareaCompletada(tareaId);
    cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0), // Gris muy claro
      appBar: AppBar(
        backgroundColor: Color(0xFF333333), // Gris oscuro
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tareas Onboarding Galatea',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/usersuggestions',
                    arguments: userId);
              },
              child: Text(
                'Sugerencias',
                style: TextStyle(
                  color: Color(0xFFB0B0B0), // Gris medio
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(width: 16),
            if (!yaHizoExamen)
              ElevatedButton(
                onPressed: irAPrueba,
                child: Text('Tomar prueba'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            color: Colors.white, // Fondo blanco para la tarjeta
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
                            color: Color(0xFF333333), // Gris oscuro
                            fontSize: 16,
                          ),
                        ),
                      ),
                      tarea['completed'] == true
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : IconButton(
                              icon: Icon(Icons.check_box_outline_blank,
                                  color: Color(0xFFB0B0B0)), // Gris medio
                              onPressed: () =>
                                  marcarComoCompletada(tarea['id']),
                            ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Descripción: ${tarea['description'] ?? ''}',
                    style: TextStyle(color: Color(0xFF333333)), // Gris oscuro
                  ),
                  SizedBox(height: 8),
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
                            'Link',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF333333), // Gris oscuro
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
