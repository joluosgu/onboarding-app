import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminCreateQuestionScreen extends StatefulWidget {
  @override
  _AdminCreateQuestionScreenState createState() => _AdminCreateQuestionScreenState();
}

class _AdminCreateQuestionScreenState extends State<AdminCreateQuestionScreen> {
  final supabase = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  String questionText = '';
  List<Map<String, dynamic>> opciones = [
    {'option_text': '', 'is_correct': false},
    {'option_text': '', 'is_correct': false},
  ];

  List<String> roles = [];
  String? role;

  @override
  void initState() {
    super.initState();
    cargarRoles();
  }

  void cargarRoles() async {
    final res = await supabase.obtenerRoles();
    setState(() {
      roles = res;
      if (roles.isNotEmpty && role == null) {
        role = roles.first;
      }
    });
  }

  void agregarOpcion() {
    setState(() {
      opciones.add({'option_text': '', 'is_correct': false});
    });
  }

  void guardarPregunta() async {
    if (_formKey.currentState!.validate()) {
      if (!opciones.any((op) => op['is_correct'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debes marcar una opción como correcta')),
        );
        return;
      }
      await supabase.crearPregunta(questionText, role!, opciones);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pregunta creada')));
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crear nueva pregunta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pregunta',
                  prefixIcon: Icon(Icons.help_outline, color: Color(0xFF333333)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (v) => questionText = v,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: role,
                decoration: InputDecoration(
                  labelText: 'Selecciona un rol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: TextStyle(color: Color(0xFF333333))))).toList(),
                onChanged: (v) => setState(() => role = v),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              SizedBox(height: 16),
              Text(
                'Opciones:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              SizedBox(height: 8),
              ...opciones.asMap().entries.map((entry) {
                final idx = entry.key;
                final op = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Opción ${idx + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (v) => op['option_text'] = v,
                          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                        ),
                      ),
                      Checkbox(
                        value: op['is_correct'],
                        onChanged: (val) {
                          setState(() {
                            for (var o in opciones) {
                              o['is_correct'] = false;
                            }
                            op['is_correct'] = val!;
                          });
                        },
                      ),
                      Text('Correcta', style: TextStyle(color: Color(0xFF333333))),
                    ],
                  ),
                );
              }),
              TextButton(
                onPressed: agregarOpcion,
                child: Text('Agregar opción'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: guardarPregunta,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Guardar pregunta',
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
      ),
    );
  }
}