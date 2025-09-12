import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminSuggestions extends StatefulWidget {
  @override
  _AdminSuggestionsState createState() => _AdminSuggestionsState();
}

class _AdminSuggestionsState extends State<AdminSuggestions> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> sugerencias = [];

  @override
  void initState() {
    super.initState();
    cargarSugerencias();
  }

  Future<void> cargarSugerencias() async {
    final resultado = await supabase.obtenerSugerencias();
    if (mounted) {
      setState(() {
        sugerencias = resultado;
      });
    }
  }

  void _confirmarEliminacion(int sugerenciaId) {
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
          content: Text('¿Estás seguro de que deseas eliminar esta sugerencia?'),
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
                Navigator.of(context).pop();
                await supabase.eliminarSugerencia(sugerenciaId);
                await cargarSugerencias();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sugerencia eliminada correctamente')),
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
          'Administrar Sugerencias',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: sugerencias.length,
        itemBuilder: (context, index) {
          final sugerencia = sugerencias[index];
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
                          'Sugerencia: ${sugerencia['name'] ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003057),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(sugerencia['id']),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Descripción: ${sugerencia['description'] ?? ''}'),
                  SizedBox(height: 4),
                  Text('Rol: ${sugerencia['role'] ?? ''}'),
                  SizedBox(height: 4),
                  Text('Usuario: ${sugerencia['user_id'] ?? ''}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
