
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final supabase = SupabaseService();
  List<dynamic> allTasks = [];
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();
  final userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllTasks();
  }

  void loadAllTasks() async {
    final data = await supabase.getAllTasks();
    setState(() {
      allTasks = data;
    });
  }

  void createTask() async {
    final userId = int.tryParse(userIdController.text);
    if (userId != null) {
      await supabase.createTask(
        userId,
        titleController.text,
        descController.text,
        linkController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea creada')),
      );
      loadAllTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel de Administrador')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear nueva tarea', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: userIdController, decoration: InputDecoration(labelText: 'ID del usuario')),
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Título')),
              TextField(controller: descController, decoration: InputDecoration(labelText: 'Descripción')),
              TextField(controller: linkController, decoration: InputDecoration(labelText: 'Enlace')),
              SizedBox(height: 10),
              ElevatedButton(onPressed: createTask, child: Text('Crear Tarea')),
              Divider(),
              Text('Avance de tareas de todos los usuarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allTasks.length,
                itemBuilder: (context, index) {
                  final task = allTasks[index];
                  return ListTile(
                    title: Text(task['title']),
                    subtitle: Text('Usuario ID: ${task['user_id']}
${task['description'] ?? ''}'),
                    trailing: task['completed'] ? Icon(Icons.check, color: Colors.green) : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
