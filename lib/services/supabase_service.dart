
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<bool> signUp(String email, String password) async {
    final existingUser = await client
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (existingUser != null) {
      return false;
    }

    final response = await client.from('users').insert({
      'email': email,
      'password': password,
    });
    return response != null;
  }

  Future<int?> signIn(String email, String password) async {
    final response = await client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    if (response != null && response['id'] != null) {
      return response['id'] as int;
    }
    return null;
  }
}


  Future<List<Map<String, dynamic>>> obtenerTareas(int userId) async {
    final response = await client
        .from('tareas')
        .select()
        .eq('usuario_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> marcarTareaCompletada(int tareaId) async {
    await client
        .from('tareas')
        .update({'completada': true})
        .eq('id', tareaId);
  }
