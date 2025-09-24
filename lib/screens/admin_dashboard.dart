import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
  }

  void redirectTo(String route) async {
    Navigator.pushNamed(context, route);
  }

  void crearTarea() async {
    Navigator.pushNamed(context, '/admintaskcreate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Acciones rápidas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 2.2,
            children: [
              _buildAdminCard(
                icon: Icons.add_circle_outline,
                label: 'Crear tarea',
                onTap: crearTarea,
              ),
              _buildAdminCard(
                icon: Icons.list_alt,
                label: 'Administrar tareas',
                onTap: () => redirectTo('/admintask'),
              ),
              _buildAdminCard(
                icon: Icons.bar_chart,
                label: 'Ver avances onboarding',
                onTap: () => redirectTo('/adminreport'),
              ),
              _buildAdminCard(
                icon: Icons.add_circle,
                label: 'Crear pregunta evaluación',
                onTap: () => redirectTo('/admin_create_question'),
              ),
              _buildAdminCard(
                icon: Icons.quiz,
                label: 'Administrar preguntas',
                onTap: () => redirectTo('/admin_questions'),
              ),
              _buildAdminCard(
                icon: Icons.assignment_turned_in,
                label: 'Resultados evaluación',
                onTap: () => redirectTo('/admin_exam_results'),
              ),
              
              _buildAdminCard(
                icon: Icons.lightbulb_outline,
                label: 'Sugerencias recibidas',
                onTap: () => redirectTo('/adminsuggestions'),
              ),
              _buildAdminCard(
                icon: Icons.admin_panel_settings,
                label: 'Administrar perfiles',
                onTap: () => redirectTo('/adminroles'),
              ),
              _buildAdminCard(
                icon: Icons.accessibility_new,
                label: 'Administrar líderes',
                onTap: () => redirectTo('/adminleads'),
              ),
              // NUEVAS OPCIONES COMO CARD
              
            ],
          ),
          SizedBox(height: 32),
          Divider(color: Color(0xFFB0B0B0)),
          SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          height: 40,
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text(
                'Salir',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                backgroundColor: Color(0xFFB0B0B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0), // Menos padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Color(0xFF333333)), // Ícono más pequeño
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
