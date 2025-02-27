import 'package:axion_app/screens/codigo_colores_screen.dart';
import 'package:axion_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculo_potencia_screen.dart';
import 'login_screen.dart';
import 'package:axion_app/screens/perfil_screen.dart';
import 'package:axion_app/screens/geoaxion_screen.dart';
import 'package:axion_app/screens/comunidad_screen.dart';
import 'package:axion_app/screens/proyectos_screen.dart';
import 'package:flutter/cupertino.dart';


class CustomDrawer extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  CustomDrawer({required this.toggleTheme, required this.isDarkMode});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _userName = 'Cargando...';
  String _userEmail = 'Cargando...';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario';
      _userEmail = prefs.getString('user_email') ?? 'Email no disponible';
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }


void _toggleDarkMode(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark_mode', value); // Guarda la preferencia
  setState(() {
    _isDarkMode = value;
  });
  widget.toggleTheme(value); // Asegura que el tema cambia en toda la app
}


  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isDarkMode ? Colors.white.withOpacity(0.1) : color.withOpacity(0.1),
      ),
      padding: EdgeInsets.all(8),
      child: Icon(icon, color: _isDarkMode ? Colors.white : color),
    );
  }

    void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(
          child: Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Estás seguro de que quieres cerrar sesión?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isDarkMode ? Colors.white70 : Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25), // Más espacio antes del primer botón
            SizedBox(
              width: 200, // Ancho fijo para los botones
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  _logout(); // Llamar a la función de cierre de sesión
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF163C9F), // Fondo azul oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16), // 🔥 Más padding en el alto
                ),
                child: Text(
                  'Sí, Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.white, // Texto en blanco
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15), // Más espacio entre los botones
            SizedBox(
              width: 200, // Ancho fijo para los botones
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4FE), // Fondo azul claro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16), // 🔥 Más padding en el alto
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color(0xFF004CFF), // Texto azul
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: <Widget>[
          Container(
            color: _isDarkMode ? Colors.black : Color(0xFFF0F8FF),
             padding: const EdgeInsets.only(top:50.0, right: 20.0, bottom: 20.0, left: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilScreen()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: ClipRRect( // Asegura que la imagen también sea redondeada
                      borderRadius: BorderRadius.circular(30), // Hace que la imagen dentro del CircleAvatar sea circular
                      child: Image.asset(
                        'assets/images/usuarioaxion.png',
                        fit: BoxFit.cover, // Asegura que la imagen cubra bien el espacio
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _userEmail,
                        style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: _isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: _isDarkMode ? Colors.black : Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  ListTile(
                    leading: _buildIcon(Icons.dark_mode, Colors.black),
                    title: Text('Modo Oscuro', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    trailing: CupertinoSwitch(
                      value: _isDarkMode,
                      onChanged: _toggleDarkMode,
                      activeColor: Colors.grey.shade300, // Color cuando está activado
                      trackColor: Colors.grey.shade300, // Color del fondo cuando está desactivado
                      thumbColor: _isDarkMode ? Colors.black : Colors.white, // Color del "círculo"
                    ),
                  ),

                  SizedBox(height: 15),
                  ListTile(
                    leading: _buildIcon(Icons.school, Colors.blue),
                    title: Text('Aprendizaje', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios, color: _isDarkMode ? Colors.white : Colors.black),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode))),
                  ),
                  SizedBox(height: 7),
                  Divider(color: const Color.fromARGB(255, 196, 196, 196), thickness: 1, indent: 20, endIndent: 20), // 🔹 Línea separadora
                  SizedBox(height: 7),                  
                  ListTile(
                    leading: _buildIcon(Icons.calculate, Colors.orangeAccent),
                    title: Text('Cálculo Óptico', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios, color: _isDarkMode ? Colors.white : Colors.black),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalculoOpticoScreen())),
                  ),
                  SizedBox(height: 15),
                  ListTile(
                    leading: _buildIcon(Icons.color_lens, Colors.red),
                    title: Text('Código de Colores', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios, color: _isDarkMode ? Colors.white : Colors.black),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CodigoColoresScreen())),
                  ),
                  SizedBox(height: 15),
                  ListTile(
                    leading: _buildIcon(Icons.map, Colors.green),
                    title: Text('GeoAxion', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GeoAxionScreen())),
                  ),
                  SizedBox(height: 7),
                  Divider(color: const Color.fromARGB(255, 196, 196, 196), thickness: 1, indent: 20, endIndent: 20), // 🔹 Línea separadora
                  SizedBox(height: 7),     
                  ListTile(
                    leading: _buildIcon(Icons.report, Colors.purple),
                    title: Text('Generar Reporte', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProyectsScreen())),
                  ),
                  SizedBox(height: 7),
                  Divider(color: const Color.fromARGB(255, 196, 196, 196), thickness: 1, indent: 20, endIndent: 20), // 🔹 Línea separadora
                  SizedBox(height: 7),     
                  ListTile(
                    leading: _buildIcon(Icons.people, Colors.deepOrange),
                    title: Text('Comunidad', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ComunidadScreen())),
                  ),
                  SizedBox(height: 15),
                  ListTile(
                    leading: _buildIcon(Icons.people, Colors.deepOrange),
                    title: Text('Chat', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4C6ED7), // Color de fondo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Espaciado interno
                      ),
                      onPressed: () {
                        _showLogoutDialog(context); // Mostrar alerta antes de cerrar sesión
                      },
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
