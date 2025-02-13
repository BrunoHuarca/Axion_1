import 'package:flutter/material.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false; // Estado para "Recordarme"

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Por favor, ingrese ambos campos.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.loginUser(email, password);
      if (response != null && response['token'] != null) {
        print("🔑 Token recibido: ${response['token']}");

        if (_rememberMe) {
          _saveCredentials(email, password);
        } else {
          _clearSavedCredentials();
        }

        await _saveUserSession(response);
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        _showErrorDialog('No se recibieron datos válidos del servidor.');
      }
    } catch (e) {
      _showErrorDialog('Error en login: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', userData['token']);
    prefs.setInt('user_id', userData['id']);
    prefs.setString('user_name', userData['name']);
    prefs.setString('user_email', userData['email']);
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('saved_email', email);
    prefs.setString('saved_password', password);
    prefs.setBool('remember_me', true);
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? "";
    final savedPassword = prefs.getString('saved_password') ?? "";
    final rememberMe = prefs.getBool('remember_me') ?? false;

    setState(() {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      _rememberMe = rememberMe;
    });
  }

  Future<void> _clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_email');
    prefs.remove('saved_password');
    prefs.setBool('remember_me', false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/loginfondo.png',
                width: screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Expanded(child: SizedBox()),
                  Center(
                    child: Image.asset(
                      'assets/images/axionlogo2.png',
                      height: 35,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E3E5C)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Por favor, introduzca su cuenta',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.blue),
                            filled: true,
                            fillColor: Color(0xFFF1F6FB), // Fondo color azul claro
                            border: InputBorder.none, // Sin borde
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // Sin borde
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // Sin borde
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                            filled: true,
                            fillColor: Color(0xFFF1F6FB), // Fondo color azul claro
                            border: InputBorder.none, // Sin borde
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // Sin borde
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // Sin borde
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // "Recordarme" Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text('Recordarme'),
                          ],
                        ),

                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF163C9F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        // NUEVO: Texto de "¿No tienes cuenta? Regístrate"
                        SizedBox(height: 20), // Espacio entre el botón y el texto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2E3E5C),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/register'),
                              child: Text(
                                'Regístrate',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF163C9F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          'Al hacer clic en Continuar, acepta nuestras',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Condiciones de servicio',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0F80FD),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(' y la ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Política de privacidad',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0F80FD),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
