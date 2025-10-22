// main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:newcollegefinder/core/widgets/upload_scholarships.dart';
import 'package:newcollegefinder/features/auth/presentation/pages/login_page.dart';
import 'package:newcollegefinder/features/auth/presentation/pages/signup_page.dart';
import 'package:newcollegefinder/services/remove_null_values.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/dashboard/presentation/pages/application_tracker_page.dart';
import 'features/dashboard/presentation/pages/main_dashboard.dart';
import 'features/dashboard/presentation/pages/profile_page.dart';
import 'features/dashboard/presentation/pages/recommendations_page.dart';
import 'features/dashboard/presentation/pages/scholarship_page.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'services/college_upload_service.dart';

// ...



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await CollegeUploadService().uploadColleges(); //to upload college data
  // cleanFirestoreCollection("colleges");
  await di.init();
  print('Dependency injection completed');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStream(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LoginPage(); // Show login if no user is signed in
          } else {
            return MainDashboard(); // Redirect to dashboard if user is signed in
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()), // Show loading
        );
      },
    );
  }
}

class AuthStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(), // Ensures instant updates
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LoginPage(); // If no user is signed in, show login
          } else {
            return MainDashboard(); // If signed in, go to dashboard
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()), // Show loading state
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduZapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/dashboard': (context) => const MainDashboard(),
        '/recommendations': (context) => const RecommendationsPage(),
        '/tracker': (context) => const ApplicationTrackerPage(),
        '/scholarships': (context) => ScholarshipPage(),
        '/profile': (context) => ProfilePage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
}
