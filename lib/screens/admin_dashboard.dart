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
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Text(
          'Panel de Administrador',
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
              crossAxisCount: 3, // Más columnas para reducir tamaño
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 2.2, // Más ancho, menos alto
              children: [
                _buildAdminCard(
                  icon: Icons.add_circle_outline,
                  label: 'Crear Tarea',
                  onTap: crearTarea,
                ),
                _buildAdminCard(
                  icon: Icons.list_alt,
                  label: 'Administrar tareas',
                  onTap: () => redirectTo('/admintask'),
                ),
                _buildAdminCard(
                  icon: Icons.bar_chart,
                  label: 'Reporte avances',
                  onTap: () => redirectTo('/adminreport'),
                ),
                _buildAdminCard(
                  icon: Icons.lightbulb_outline,
                  label: 'Sugerencias',
                  onTap: () => redirectTo('/adminsuggestions'),
                ),
                _buildAdminCard(
                  icon: Icons.admin_panel_settings,
                  label: 'Administrar roles',
                  onTap: () => redirectTo('/adminroles'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Divider(color: Color(0xFFB0B0B0)),
            SizedBox(height: 16),
          ],
        ),
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
