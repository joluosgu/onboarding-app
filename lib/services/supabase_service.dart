import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;
  int clientid = 0;

//Registro de usuario

  Future<bool> signUp(String email, String password, String role) async {
  try {
    // 1. Intenta insertar el nuevo usuario directamente.
    final response = await client.from('users').insert({
      'email': email,
      'password': password,
      'role': role,
      'admin': false,
    }).select(); // Agrega .select() para obtener el registro insertado

    if (response == null || response.isEmpty) {
      // La inserción falló por una razón desconocida
      return false;
    }

    // 2. Obtiene el ID del usuario insertado directamente desde la respuesta.
    final Map<String, dynamic> newUser = response.first;
    final int newUserId = newUser['id'];

    // 3. Obtén las tareas
    final tareas = await client.from('tasks').select('*').or('role.eq.$role,role.eq.Todos');

    // 4. Prepara las tareas para el nuevo usuario
    final tareasAsignadas = tareas.map((tarea) => {
      'user_id': newUserId,
      'task_id': tarea['id'],
      'title': tarea['title'],
      'description': tarea['description'],
      'link': tarea['link'],
      'completed': false,
    }).toList();

    // 5. Asigna las tareas al usuario
    if (tareasAsignadas.isNotEmpty) {
      await client.from('tasks_by_user').insert(tareasAsignadas);
    }
    
    // Si llegas aquí, todo fue exitoso
    return true;
  } catch (e) {
    // 6. Maneja el error de usuario duplicado
    // Supabase lanzará una excepción si el email ya existe
    print('Error during signUp: $e');
    return false;
  }
}

  // Login de usuario
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    final response = await client
        .from('users')
        .select('id, admin, role') // solo seleccionamos los campos necesarios
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    if (response != null && response['id'] != null) {
      return {
        'id': response['id'] as int,
        'admin': response['admin'] as bool,
        'role': response['role'] as String,
      };
    }

    return null;
  }

  // Obtener tareas del usuario
  Future<List<Map<String, dynamic>>> obtenerTareas(int userId) async {
    final response =
        await client.from('tasks_by_user').select('*').eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

//Porcentaje por usuario
  Future<Map<String, double>> obtenerPorcentajePorEmail() async {
    final response =
        await client.from('tasks_by_user').select('completed, users(email)');

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
    final response = await client.from('tasks').delete().eq('id', tareaId).execute();


    if (response.status != 204) {
      throw Exception('Error al eliminar la tarea: ${response.status}');
    }
  }

  // Marcar tarea como completada
  Future<void> marcarTareaCompletada(int tareaId) async {
    await client
        .from('tasks_by_user')
        .update({'completed': true}).eq('id', tareaId);
  }

  // Crear nueva tarea
  Future<void> crearTarea(
      String titulo, String descripcion, String link, String role) async {
    
    await client.from('tasks').insert({
      'title': titulo,
      'description': descripcion,
      'role': role,
      'link': link,
    });
  }

  // Crear nueva tarea
  Future<void> crearSugerencia(String titulo, String descripcion, String link,
      String role, int userId) async {
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
    final response =
        await client.from('tasksuggestions').delete().eq('id', sugerenciaId).execute();

    if (response.status != 204) {
      throw Exception('Error al eliminar la sugerencia: ${response.status}');
    }
  }

  Future<List<String>> obtenerRoles() async {
    final response = await client.from('role').select('role');
    return (response as List).map((r) => r['role'] as String).toList();
  }

  Future<void> crearRole(String role) async {
    await client.from('role').insert({'role': role});
  }

  Future<void> eliminarRole(String role) async {
    await client.from('role').delete().eq('role', role);
  }

  // Tu cliente supabase ya inicializado aquí

  Future<bool> marcarComoAdmin(String email) async {
    final response =
        await client.from('users').update({'admin': true}).eq('email', email);

    // Verifica si se actualizó al menos 1 fila
    return response == null;
  }

  Future<Map<String, double>> obtenerPorcentajePorEmailPorRole(
      String role) async {
    // Trae todas las tareas asignadas a usuarios, incluyendo el id de la tarea y el usuario
    final response = await client
        .from('tasks_by_user')
        .select('completed, users(email), task_id');

    final tareasByUser = List<Map<String, dynamic>>.from(response);

    // Trae todas las tareas con su id y rol
    final tareas = await client.from('tasks').select('id, role');

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

  // Crear pregunta (admin)
  Future<void> crearPregunta(String questionText, String role, List<Map<String, dynamic>> opciones) async {
    final pregunta = await client.from('questions').insert({
      'question_text': questionText,
      'role': role,
    }).select().single();

    final questionId = pregunta['id'];
    final opcionesInsert = opciones.map((op) => {
      'question_id': questionId,
      'option_text': op['option_text'],
      'is_correct': op['is_correct'] ?? false,
    }).toList();

    await client.from('question_options').insert(opcionesInsert);
  }

  // Obtener preguntas y opciones por role
  Future<List<Map<String, dynamic>>> obtenerPreguntasPorRole(String role) async {
    final preguntas = await client

        .from('questions')
        .select('*, question_options(*)')
        .eq('role', role);
        //imprimo el role

    return List<Map<String, dynamic>>.from(preguntas);
  }

  // Registrar intento de examen y respuestas
  Future<void> registrarExamen(int userId, List<Map<String, dynamic>> respuestas) async {
    // Calcular score
    int score = respuestas.where((r) => r['is_correct'] == true).length;

    // Insertar examen
    final examen = await client.from('user_exams').insert({
      'user_id': userId,
      'score': score,
    }).select().single();

    final userExamId = examen['id'];

    // Insertar respuestas
    final respuestasInsert = respuestas.map((r) => {
      'user_exam_id': userExamId,
      'question_id': r['question_id'],
      'selected_option_id': r['selected_option_id'],
      'is_correct': r['is_correct'],
    }).toList();

    await client.from('user_exam_answers').insert(respuestasInsert);
  }

  // Obtener resultados de exámenes para el board admin
  Future<List<Map<String, dynamic>>> obtenerResultadosExamenes() async {
    final examenes = await client
        .from('user_exams')
        .select('id, user_id, score, completed_at, users(email, role)')
        .order('completed_at', ascending: false);

    return List<Map<String, dynamic>>.from(examenes);
  }

  // Obtener resultados de exámenes para un rol específico
  Future<List<Map<String, dynamic>>> obtenerResultadosExamenesPorRole(String role) async {
  // 1. Obtén los ids de usuarios con ese role
  final users = await client.from('users').select('id').eq('role', role);
  final userIds = (users as List).map((u) => u['id']).toList();

  if (userIds.isEmpty) return [];

  // 2. Trae los exámenes de esos usuarios
  final examenes = await client
      .from('user_exams')
      .select('id, user_id, score, completed_at, users(email, role)')
      .in_('user_id', userIds)
      .order('completed_at', ascending: false);

  return List<Map<String, dynamic>>.from(examenes);
}

  // Obtener detalle de respuestas de un examen
  Future<List<Map<String, dynamic>>> obtenerDetalleExamen(int userExamId) async {
    final detalles = await client
        .from('user_exam_answers')
        .select('question_id, selected_option_id, is_correct, questions(question_text), question_options(option_text)')
        .eq('user_exam_id', userExamId);

    return List<Map<String, dynamic>>.from(detalles);
  }

// Obtener todas las preguntas
Future<List<Map<String, dynamic>>> obtenerTodasLasPreguntas() async {
  final preguntas = await client
      .from('questions')
      .select('*, question_options(*)')
      .order('role');
  return List<Map<String, dynamic>>.from(preguntas);
}

// Eliminar una pregunta (y sus opciones asociadas por ON DELETE CASCADE)
Future<void> eliminarPregunta(int preguntaId) async {
  final response = await client.from('questions').delete().eq('id', preguntaId).execute();
  if (response.status != 204) {
    throw Exception('Error al eliminar la pregunta: ${response.status}');
  }
}
}
