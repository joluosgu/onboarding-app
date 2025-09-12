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

   final List<String> opciones = ['Mobile', 'Web', 'Back'];
  String? opcionSeleccionada;

  List<Map<String, dynamic>> resumen = [];

@override
void initState() {
  super.initState();
  cargarResumen();
}

void cargarResumen() async {
  final porcentajes = await supabase.obtenerPorcentajePorEmail();
  setState(() {
    resumen = porcentajes.entries.map((entry) => {
      'email': entry.key,
      'porcentaje': entry.value,
    }).toList();
  });
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
          'Reporte de Avances',
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
            Text(
              'Avance por usuario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003057),
              ),
            ),
            SizedBox(height: 20),
            ...resumen.map((usuario) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
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
                          color: Color(0xFF003057),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (usuario['porcentaje'] ?? 0) / 100,
                              backgroundColor: Colors.grey[300],
                              color: Color(0xFFffcd00), // Amarillo vibrante
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${usuario['porcentaje']}% completado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
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
