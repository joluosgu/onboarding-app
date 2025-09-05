
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() async {
    final email = emailController.text;
    final password = passwordController.text;

    final supabase = Supabase.instance.client;
    await supabase.from('users').insert({'email': email, 'password': password});

    await supabase.from('tasks').insert([
      {
        'user_id': null,
        'title': 'Leer sobre modelo de versionamiento',
        'description': 'Revisar documentación sobre control de versiones',
        'link': 'https://example.com/versionamiento',
        'completed': false
      },
      {
        'user_id': null,
        'title': 'Aprende sobre nuestros consumidores',
        'description': 'Estudia el perfil de los consumidores actuales',
        'link': 'https://example.com/consumidores',
        'completed': false
      }
    ]);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Usuario')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text('Registrar')),
          ],
        ),
      ),
    );
  }
}
