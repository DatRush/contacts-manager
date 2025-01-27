import 'package:flut1/screens/Login/login_screen.dart';
import 'package:flut1/screens/Register/register_screen.dart';
import 'package:flut1/screens/Welcome/welcome_screen.dart';
import 'package:flut1/imports.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService('http://10.202.1.10:9090/api')),
        ChangeNotifierProvider(
          create: (context) => ContactModel(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => AuthModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("test1");
    return MaterialApp(
      title: 'Test01',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1A1A40),

        cardColor: const Color(0xFF23232E),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFECEFF1),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFB0BEC5),
          ),
          headlineSmall: TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Color(0xFFFF5722),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF607D8B),
            foregroundColor: Colors.white,
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF607D8B),
          foregroundColor: Colors.white,
          elevation: 6.0,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF23232E),
          labelStyle: TextStyle(
            color: Color(0xFFFFC107),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF5722)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFC107)),
          ),
        ),

        dialogBackgroundColor: const Color(0xFF23232E),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
