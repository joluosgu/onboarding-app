
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = SupabaseService();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;
    final success = await supabase.signIn(email, password);
    if (success) {
      if (email == 'jlospina') {
        Navigator.pushNamed(context, '/admin');
      } else {
        Navigator.pushNamed(context, '/tasks');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: login, child: Text('Login')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: Text('Crear cuenta')),
          ],
        ),
      ),
    );
  }
}
