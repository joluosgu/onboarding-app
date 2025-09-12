import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final supabase = SupabaseService();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final linkController = TextEditingController();
  final roleController = TextEditingController();

   final List<String> opciones = ['Mobile', 'Web', 'Back'];
  String? opcionSeleccionada;

  List<Map<String, dynamic>> resumen = [];

@override
void initState() {
  super.initState();
  
}





void redirect() async {
           Navigator.pushNamed(context, '/admintask');
                                          
  }
void redirect2() async {
           Navigator.pushNamed(context, '/adminreport');
                                          
  }
  void crearTarea() async {
    
    Navigator.pushNamed(context, '/admintaskcreate');
  }

  void redirectSuggestions() async {
    Navigator.pushNamed(context, '/adminsuggestions');
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
        'Panel de Administrador',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          ElevatedButton.icon(
            onPressed: crearTarea,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffcd00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(Icons.add_circle, color: Colors.black),
            label: Text('Crear Tarea'),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: redirect,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffcd00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(Icons.list, color: Colors.black),
            label: Text('Administrar tareas'),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: redirect2,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffcd00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(Icons.bar_chart, color: Colors.black),
            label: Text('Reporte avances'),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: redirectSuggestions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffcd00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(Icons.lightbulb_outline, color: Colors.black),
            label: Text('Administrar sugerencias'),
          ),
        ],
      ),
    ),
  );
}

}
