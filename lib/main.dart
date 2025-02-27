import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/calculo_potencia_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDarkMode = await getThemePreference();
  final username = await getUsernamePreference(); // 🔥 Nuevo: Obtener nombre del usuario
  runApp(MyApp(isDarkMode: isDarkMode, username: username));
}

Future<bool> getThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
}

Future<String> getUsernamePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name') ?? 'Usuario';
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final String username; // 🔥 Nuevo: Almacenar el nombre del usuario

  MyApp({required this.isDarkMode, required this.username});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  late String _username; // 🔥 Nuevo: Variable para el nombre del usuario

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _username = widget.username;
  }

  void _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: SplashScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/calculo_potencia': (context) => CalculoOpticoScreen(),
        '/inicio': (context) => InicioScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  SplashScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_token');

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/inicio');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Color(0xFF000021),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Image.asset(
              'assets/images/axionlogo3.png',
              width: 150,
              height: 150,
            ),
          ),
          Spacer(),
          Column(
            children: [
              Text(
                'Versión 1.2.0',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                '© 2024 Todos los derechos reservados',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
