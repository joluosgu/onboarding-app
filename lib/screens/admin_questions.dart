import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminQuestionsScreen extends StatefulWidget {
  @override
  _AdminQuestionsScreenState createState() => _AdminQuestionsScreenState();
}

class _AdminQuestionsScreenState extends State<AdminQuestionsScreen> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> preguntas = [];

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    final resultado = await supabase.obtenerTodasLasPreguntas();
    if (mounted) {
      setState(() {
        preguntas = resultado;
      });
    }
  }

  void _confirmarEliminacion(int preguntaId) {
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
          content: Text('¿Estás seguro de que deseas eliminar esta pregunta?'),
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
                await supabase.eliminarPregunta(preguntaId);
                await cargarPreguntas();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pregunta eliminada correctamente')),
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
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        title: Text(
          'Administrar Preguntas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          final pregunta = preguntas[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            color: Colors.white,
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
                          'Pregunta: ${pregunta['question_text'] ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(pregunta['id']),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Role: ${pregunta['role'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontStyle: FontStyle.italic,
                    ),
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