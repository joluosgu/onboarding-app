
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<bool> signUp(String email, String password) async {
    final existingUser = await client
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();
    if (existingUser != null) return false;
    await client.from('users').insert({'email': email, 'password': password});
    return true;
  }

  Future<int?> signIn(String email, String password) async {
    final response = await client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    return response != null ? response['id'] as int : null;
  }

  Future<List<dynamic>> getUserTasks(int userId) async {
    final response = await client
        .from('tasks')
        .select()
        .eq('user_id', userId);
    return response;
  }

  Future<List<dynamic>> getAllTasks() async {
    final response = await client
        .from('tasks')
        .select();
    return response;
  }

  Future<void> createTask(int userId, String title, String description, String link) async {
    await client.from('tasks').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'link': link,
      'completed': false
    });
  }
}
