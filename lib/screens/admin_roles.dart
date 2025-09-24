import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminRolesScreen extends StatefulWidget {
  @override
  _AdminRolesScreenState createState() => _AdminRolesScreenState();
}

class _AdminRolesScreenState extends State<AdminRolesScreen> {
  final supabase = SupabaseService();
  final roleController = TextEditingController();
  List<String> roles = [];

  @override
  void initState() {
    super.initState();
    cargarRoles();
  }

  Future<void> cargarRoles() async {
    final resultado = await supabase.obtenerRoles(); // Debe retornar List<String>
    setState(() {
      roles = resultado;
    });
  }

  Future<void> crearRole() async {
    final nuevoRole = roleController.text.trim();
    if (nuevoRole.isNotEmpty) {
      await supabase.crearRole(nuevoRole); // Debes implementar este método
      roleController.clear();
      await cargarRoles();
    }
  }

  Future<void> eliminarRole(String role) async {
    await supabase.eliminarRole(role); // Debes implementar este método
    await cargarRoles();
  }

  void _confirmarEliminacion(String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar rol'),
        content: Text('¿Seguro que deseas eliminar el rol "$role"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await eliminarRole(role);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        title: Text(
          'Administrar Roles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Nuevo rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: crearRole,
              child: Text('Crear rol'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB0B0B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        role,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(role),
                      ),
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