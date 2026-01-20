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

  List<String> opciones = [];
  String? opcionSeleccionada;

  @override
  void initState() {
    super.initState();
    cargarRoles();
  }

  Future<void> cargarRoles() async {
    final roles = await supabase.obtenerRoles(); // Debe retornar List<String>
    setState(() {
      opciones = roles;
      if (opciones.isNotEmpty) {
        opcionSeleccionada = opciones.first;
      }
    });
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
      backgroundColor: Color(0xFFE0E0E0), // Gris muy claro
      appBar: AppBar(
        backgroundColor: Color(0xFF333333), // Gris oscuro
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
                color: Color(0xFF333333), // Gris oscuro
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.title, color: Color(0xFF333333)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
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
                prefixIcon: Icon(Icons.description, color: Color(0xFF333333)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
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
                prefixIcon: Icon(Icons.link, color: Color(0xFF333333)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: opcionSeleccionada,
              decoration: InputDecoration(
                labelText: 'Selecciona un rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: opciones.map((opcion) {
                return DropdownMenuItem(
                  value: opcion,
                  child: Text(opcion, style: TextStyle(color: Color(0xFF333333))),
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
                backgroundColor: Color(0xFFB0B0B0), // Gris medio
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
