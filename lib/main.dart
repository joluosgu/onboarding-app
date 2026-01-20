import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app/screens/admin_questions.dart';
import 'package:flutter_onboarding_app/screens/admin_report.dart';
import 'package:flutter_onboarding_app/screens/admin_roles.dart';
import 'package:flutter_onboarding_app/screens/admin_suggestions.dart';
import 'package:flutter_onboarding_app/screens/admin_tasks.dart';
import 'package:flutter_onboarding_app/screens/admin_tasks_create.dart';
import 'package:flutter_onboarding_app/screens/user_suggestions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/user_tasks_screen.dart';
import 'screens/admin_lead.dart';
import 'screens/user_exam_screen.dart';
import 'screens/admin_create_question_screen.dart';
import 'screens/admin_exam_results_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fwgkjzfxjibgpkbuholf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3Z2tqemZ4amliZ3BrYnVob2xmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxMDUyMjMsImV4cCI6MjA3MjY4MTIyM30.fecvBRoXuobja15wfaUUj_er6bUPBqU3mXs7UPnY-cw',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Color(0xFFE0E0E0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF333333),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin': (context) => AdminDashboard(),
        '/admintask': (context) => Admintasks(),
        '/admintaskcreate': (context) => AdminTasksCreate(),
        '/adminreport': (context) => AdminReport(),
        '/tasks': (context) => UserTasksScreen(),
        '/usersuggestions': (context) => UserSuggestions(),
        '/adminsuggestions': (context) => AdminSuggestions(),
        '/adminroles': (context) => AdminRolesScreen(),
        '/adminleads': (context) =>  ChangeAdminScreen (),
        '/user_exam': (context) => UserExamScreen(),
        '/admin_create_question': (context) => AdminCreateQuestionScreen(),
        '/admin_exam_results': (context) => AdminExamResultsScreen(),
        '/admin_questions': (context) => AdminQuestionsScreen(),
      },
    );
  }
}
