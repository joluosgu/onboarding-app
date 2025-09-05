
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<bool> signUp(String email, String password) async {
    final response = await client.from('users').insert({
      'email': email,
      'password': password,
    });
    return response != null;
  }

  Future<bool> signIn(String email, String password) async {
    final response = await client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    return response != null;
  }
}
