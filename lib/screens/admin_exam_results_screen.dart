import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminExamResultsScreen extends StatefulWidget {
  @override
  _AdminExamResultsScreenState createState() => _AdminExamResultsScreenState();
}

class _AdminExamResultsScreenState extends State<AdminExamResultsScreen> {
  final supabase = SupabaseService();
  List<Map<String, dynamic>> examenes = [];
  bool cargando = true;
  List<String> roles = [];
  String? roleSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarRoles();
  }

  void cargarRoles() async {
    final res = await supabase.obtenerRoles();
    setState(() {
      roles = res;
      if (roles.isNotEmpty) {
        roleSeleccionado = roles.first;
        cargarResultados();
      }
    });
  }

  void cargarResultados() async {
    if (roleSeleccionado == null) return;
    setState(() {
      cargando = true;
    });
    final res = await supabase.obtenerResultadosExamenesPorRole(roleSeleccionado!);
    setState(() {
      examenes = res;
      cargando = false;
    });
  }

  void verDetalle(int userExamId) async {
    final detalles = await supabase.obtenerDetalleExamen(userExamId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle del examen'),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: detalles.map<Widget>((d) {
              return ListTile(
                title: Text(d['questions']['question_text'] ?? ''),
                subtitle: Text('Respuesta: ${d['question_options']['option_text'] ?? ''}'),
                trailing: Icon(
                  d['is_correct'] ? Icons.check : Icons.close,
                  color: d['is_correct'] ? Colors.green : Colors.red,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        title: Text('Resultados de exámenes'),
        backgroundColor: Color(0xFF333333),
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: roleSeleccionado,
                    decoration: InputDecoration(
                      labelText: 'Filtrar por rol',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (valor) {
                      setState(() {
                        roleSeleccionado = valor;
                        cargando = true;
                      });
                      cargarResultados();
                    },
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: examenes.isEmpty
                        ? Center(child: Text('No hay exámenes para este rol'))
                        : ListView.builder(
                            itemCount: examenes.length,
                            itemBuilder: (context, index) {
                              final e = examenes[index];
                              final usuario = e['users'];
                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.person, color: Color(0xFF333333)),
                                  title: Text(
                                    usuario != null
                                        ? usuario['email'] ?? 'Sin email'
                                        : 'Usuario no encontrado',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    usuario != null
                                        ? 'Rol: ${usuario['role']}'
                                        : '',
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Score',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                      ),
                                      Text(
                                        '${e['score']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => verDetalle(e['id']),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}