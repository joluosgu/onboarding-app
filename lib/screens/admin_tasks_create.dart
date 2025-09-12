import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminTasksCreate extends StatefulWidget {
  @override
  _AdmintasksCreateState createState() => _AdmintasksCreateState();
}

class _AdmintasksCreateState extends State<AdminTasksCreate> {
  final supabase = SupabaseService();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final linkController = TextEditingController();

   final List<String> opciones = ['Mobile', 'Web', 'Back'];
  String? opcionSeleccionada;

  List<Map<String, dynamic>> resumen = [];

@override
void initState() {
  super.initState();
}

  void crearTarea() async {
    final titulo = tituloController.text;
  
    final descripcion = descripcionController.text;
    final link = linkController.text;
    if (titulo.isNotEmpty && descripcion.isNotEmpty && link.isNotEmpty ) {
      print(opcionSeleccionada);
       print("opcionSeleccionada");
      await supabase.crearTarea(titulo, descripcion, link, opcionSeleccionada ?? 'Web');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea creada exitosamente')),
      );
      tituloController.clear();
      descripcionController.clear();
      linkController.clear();
      
    
    }
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
          'Administrador',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Crear nueva tarea',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003057),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            TextField(
              controller: linkController,
              decoration: InputDecoration(
                labelText: 'Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: opcionSeleccionada,
              decoration: InputDecoration(
                labelText: 'Selecciona un rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: opciones.map((opcion) {
                return DropdownMenuItem(
                  value: opcion,
                  child: Text(opcion),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  opcionSeleccionada = valor;
                });
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: crearTarea,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Crear Tarea',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFffcd00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
