
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UserTasksScreen extends StatefulWidget {
  @override
  _UserTasksScreenState createState() => _UserTasksScreenState();
}

class _UserTasksScreenState extends State<UserTasksScreen> {
  final supabase = SupabaseService();
  List<dynamic> tasks = [];
  int userId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)!.settings.arguments as int;
    loadTasks();
  }

  void loadTasks() async {
    final data = await supabase.getUserTasks(userId);
    setState(() {
      tasks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text(task['description'] ?? ''),
            trailing: task['completed'] ? Icon(Icons.check, color: Colors.green) : null,
          );
        },
      ),
    );
  }
}
