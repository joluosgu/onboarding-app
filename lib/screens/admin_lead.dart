import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ChangeAdminScreen extends StatefulWidget {
  @override
  _ChangeAdminScreenState createState() => _ChangeAdminScreenState();
}

class _ChangeAdminScreenState extends State<ChangeAdminScreen> {
  final supabase = SupabaseService();
  final emailController = TextEditingController();
  bool isLoading = false;

  Future<void> hacerAdmin() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa un email')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final exito = await supabase.marcarComoAdmin(email);

    setState(() {
      isLoading = false;
    });

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario $email ahora es administrador')),
      );
      emailController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró usuario con email $email')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        title: Text(
          'Cambiar a Admin',
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email del usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : hacerAdmin,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Hacer Admin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB0B0B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
