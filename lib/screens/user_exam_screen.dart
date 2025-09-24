import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UserExamScreen extends StatefulWidget {
  @override
  _UserExamScreenState createState() => _UserExamScreenState();
}

class _UserExamScreenState extends State<UserExamScreen> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> preguntas = [];
  Map<int, int> respuestas = {}; // question_id -> option_id
  int? userId;
  String? role;
  bool cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = args['userId'];
    role = args['role'];
    cargarPreguntas();
  }

  void cargarPreguntas() async {
    final res = await supabase.obtenerPreguntasPorRole(role!);
    setState(() {
      preguntas = res;
      cargando = false;
    });
  }

  void enviarExamen() async {
    List<Map<String, dynamic>> respuestasList = [];
    for (var pregunta in preguntas) {
      final qid = pregunta['id'];
      final selectedOptionId = respuestas[qid];
      final opciones = pregunta['question_options'] as List<dynamic>;
      final correcta = opciones.firstWhere((op) => op['id'] == selectedOptionId, orElse: () => null);
      respuestasList.add({
        'question_id': qid,
        'selected_option_id': selectedOptionId,
        'is_correct': correcta != null ? (correcta['is_correct'] == true) : false,
      });
    }
    await supabase.registrarExamen(userId!, respuestasList);
    Navigator.pop(context); // Regresa a la pantalla de tareas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡Examen enviado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text('Prueba de conocimientos')),
      body: ListView(
        children: [
          ...preguntas.map((pregunta) {
            final opciones = pregunta['question_options'] as List<dynamic>;
            return Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pregunta['question_text'], style: TextStyle(fontWeight: FontWeight.bold)),
                    ...opciones.map<Widget>((op) => RadioListTile<int>(
                          title: Text(op['option_text']),
                          value: op['id'],
                          groupValue: respuestas[pregunta['id']],
                          onChanged: (val) {
                            setState(() {
                              respuestas[pregunta['id']] = val!;
                            });
                          },
                        )),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: respuestas.length == preguntas.length ? enviarExamen : null,
              child: Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}