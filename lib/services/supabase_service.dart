import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;
   int clientid =0 ;

//Registro de usuario

  Future<bool> signUp(String email, String password, String role) async {
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
      'role': role,


    });

    

  print("insertado");
// Obtener tareas del tipo correspondiente
  final tareas = await client
      .from('tasks')
      .select('*')
      .eq('role', role); // o 'role' si así se llama

  final clientid = await client
      .from('users')
      .select('id')
      .eq('email', email)
      .maybeSingle();

// Crear entradas en tasks_by_user
  final tareasAsignadas = tareas.map((tarea) => {
    'user_id': clientid['id'],
    'task_id': tarea['id'], // <-- Agrega el id de la tarea
    'title': tarea['title'],
    'description': tarea['description'],
    'link': tarea['link'],
    'completed': false,
  }).toList();
    print("cliente id consultado");
    print(clientid['id']);




if (tareasAsignadas.isNotEmpty) {
    await client.from('tasks_by_user').insert(tareasAsignadas);
  }




    return response != null;
  }

  // Login de usuario
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

  // Obtener tareas del usuario
  Future<List<Map<String, dynamic>>> obtenerTareas(int userId) async {
    final response = await client
        .from('tasks_by_user')
        .select('*')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);


  }
//Porcentaje por usuario
Future<Map<String, double>> obtenerPorcentajePorEmail() async {
  final response = await client
      .from('tasks_by_user')
      .select('completed, users(email)');

  final tareas = List<Map<String, dynamic>>.from(response);
  final Map<String, int> totalPorEmail = {};
  final Map<String, int> completadasPorEmail = {};

  for (var tarea in tareas) {
    final email = tarea['users']?['email'] ?? 'Desconocido';
    final completada = tarea['completed'] == true;

    totalPorEmail[email] = (totalPorEmail[email] ?? 0) + 1;
    if (completada) {
      completadasPorEmail[email] = (completadasPorEmail[email] ?? 0) + 1;
    }
  }

  final Map<String, double> porcentajePorEmail = {};
  totalPorEmail.forEach((email, total) {
    final completadas = completadasPorEmail[email] ?? 0;
    final porcentaje = total > 0 ? (completadas / total) * 100 : 0;
    porcentajePorEmail[email] = double.parse(porcentaje.toStringAsFixed(2));
  });

  return porcentajePorEmail;
}



// Mostrar todas las tareas
Future<List<Map<String, dynamic>>> obtenerTodasLasTareas() async {
  final response = await client
      .from('tasks')
      .select('*')
      .order('role')
      .then((data) => List<Map<String, dynamic>>.from(data));
  return response;
}




// Borra una tarea
Future<void> eliminarTarea(int tareaId) async {
  final response = await client
      .from('tasks')
      .delete()
      .eq('id', tareaId);
      
      print(tareaId);
  print("tareaId");
    print(response.status);
if (response.status != 200)  {
    throw Exception('Error al eliminar la tarea: ${response.status}');
  }

}


  // Marcar tarea como completada
  Future<void> marcarTareaCompletada(int tareaId) async {
    await client
        .from('tasks_by_user')
        .update({'completed': true})
        .eq('id', tareaId);
  }

  // Crear nueva tarea
  Future<void> crearTarea(String titulo, String descripcion, String link, String role) async {
     print(titulo);
          print(descripcion);
               print(link);
                    print(role);
    await client.from('tasks').insert({
      'title': titulo,
      'description': descripcion,
      'role': role,
      
      'link': link,
    });
  }
  // Crear nueva tarea
  Future<void> crearSugerencia(String titulo, String descripcion, String link, String role, int userId) async {
     
                    print(titulo );
                                        print(descripcion );

                    print(link );

                    print(role );

                    print(userId );

    await client.from('tasksuggestions').insert({
      'name': titulo,
      'description': descripcion,
      'role': role,  
      'link': link,
      'user_id': userId
    });
  }

  // Obtener todas las sugerencias
  Future<List<Map<String, dynamic>>> obtenerSugerencias() async {
    final response = await client
      .from('tasksuggestions')
      .select('*')
      .order('id')
      .then((data) => List<Map<String, dynamic>>.from(data));
    return response;
  }

  // Eliminar una sugerencia
  Future<void> eliminarSugerencia(int sugerenciaId) async {
    final response = await client
      .from('tasksuggestions')
      .delete()
      .eq('id', sugerenciaId);
    
    print('Intento de eliminar sugerencia con ID: $sugerenciaId');
    if (response.status != 200) {
      throw Exception('Error al eliminar la sugerencia: ${response.status}');
    }
  }

  Future<List<String>> obtenerRoles() async {
  final response = await client
  .from('role')
  .select('role');
  return 
  (response as List).map((r) => r['role'] as String).toList();
}

Future<void> crearRole(String role) async {
  await client.from('role').insert({'role': role});
}

Future<void> eliminarRole(String role) async {
  await client.from('role').delete().eq('role', role);
}

Future<Map<String, double>> obtenerPorcentajePorEmailPorRole(String role) async {
  // Trae todas las tareas asignadas a usuarios, incluyendo el id de la tarea y el usuario
  final response = await client
      .from('tasks_by_user')
      .select('completed, users(email), task_id');

  final tareasByUser = List<Map<String, dynamic>>.from(response);

  // Trae todas las tareas con su id y rol
  final tareas = await client
      .from('tasks')
      .select('id, role');

  final tareasList = List<Map<String, dynamic>>.from(tareas);

  // Crea un mapa de id de tarea a rol
  final Map<int, String> tareaIdARol = {
    for (var tarea in tareasList) tarea['id'] as int: tarea['role'] as String
  };

  final Map<String, int> totalPorEmail = {};
  final Map<String, int> completadasPorEmail = {};

  for (var tareaUser in tareasByUser) {
    final email = tareaUser['users']?['email'] ?? 'Desconocido';
    final completada = tareaUser['completed'] == true;
    final taskId = tareaUser['task_id'];
    final tareaRole = tareaIdARol[taskId];

    if (tareaRole == role) {
      totalPorEmail[email] = (totalPorEmail[email] ?? 0) + 1;
      if (completada) {
        completadasPorEmail[email] = (completadasPorEmail[email] ?? 0) + 1;
      }
    }
  }

  final Map<String, double> porcentajePorEmail = {};
  totalPorEmail.forEach((email, total) {
    final completadas = completadasPorEmail[email] ?? 0;
    final porcentaje = total > 0 ? (completadas / total) * 100 : 0;
    porcentajePorEmail[email] = double.parse(porcentaje.toStringAsFixed(2));
  });

  return porcentajePorEmail;
}
}
