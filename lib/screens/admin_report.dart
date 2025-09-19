import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminReport extends StatefulWidget {
  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  final supabase = SupabaseService();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final linkController = TextEditingController();
  final roleController = TextEditingController();

  List<String> opciones = [];
  String? opcionSeleccionada;
  List<Map<String, dynamic>> resumen = [];

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
        cargarResumen(); // Cargar el resumen del primer rol
      }
    });
  }

  void cargarResumen() async {
    if (opcionSeleccionada == null) return;
    final porcentajes = await supabase.obtenerPorcentajePorEmailPorRole(opcionSeleccionada!);
    setState(() {
      resumen = porcentajes.entries
          .map((entry) => {
                'email': entry.key,
                'porcentaje': entry.value,
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        elevation: 2,
        title: Text(
          'Reporte de Avances',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Avance por usuario',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: opcionSeleccionada,
              decoration: InputDecoration(
                labelText: 'Filtrar por rol',
                floatingLabelBehavior: FloatingLabelBehavior.always,
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
                cargarResumen();
              },
            ),
            SizedBox(height: 24),
            ...resumen.map((usuario) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuario: ${usuario['email']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (usuario['porcentaje'] ?? 0) / 100,
                              backgroundColor: Color(0xFFE0E0E0),
                              color: Color(0xFFB0B0B0),
                              minHeight: 8,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${usuario['porcentaje']}% completado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
