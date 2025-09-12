import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UserSuggestions extends StatefulWidget {
  @override
  _UserSuggestionsState createState() => _UserSuggestionsState();
}

class _UserSuggestionsState extends State<UserSuggestions> {
  final supabase = SupabaseService();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final linkController = TextEditingController();

  final List<String> opciones = ['Mobile', 'Web', 'Back'];
  String? opcionSeleccionada;

  @override
  void initState() {
    super.initState();
  }

  void crearTarea() async {
    final int? userId = ModalRoute.of(context)!.settings.arguments as int?;

    final titulo = tituloController.text;
    final descripcion = descripcionController.text;
    final link = linkController.text;
    if (titulo.isNotEmpty && descripcion.isNotEmpty && link.isNotEmpty) {
      print("opcionSeleccionada");
      print(opcionSeleccionada);
      await supabase.crearSugerencia(titulo, descripcion, link, opcionSeleccionada ?? 'Web', userId ?? 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sugerencia enviada exitosamente')),
      );
      tituloController.clear();
      descripcionController.clear();
      linkController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0), // Fondo gris claro
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF003057), // Color de fondo azul oscuro
          ),
        ),
        title: Text(
          'Sugerencias',
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
              'Envíanos tus ideas para nuevas tareas',
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
                labelText: 'Título de la Sugerencia',
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
                labelText: 'Descripción detallada',
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
                labelText: 'Link de referencia',
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
                  'Enviar sugerencia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFffcd00), // Amarillo vibrante
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
