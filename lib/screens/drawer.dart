import 'package:axion_app/screens/codigo_colores_screen.dart';
import 'package:axion_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculo_potencia_screen.dart'; // Asegúrate de importar la pantalla de Cálculo de Potencia
import 'login_screen.dart';
import 'package:axion_app/screens/cuenta_screen.dart';


class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _userName = 'Cargando...';
  String _userEmail = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar datos del usuario desde SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario'; // Establecer el nombre por defecto
      _userEmail = prefs.getString('user_email') ?? 'Email no disponible'; // Establecer el email por defecto
    });
  }

  // Método para cerrar sesión
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Elimina todos los datos de SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige a LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9, // 80% del ancho
      child: Container(
        color: Color(0xFF0083F7), // Establece el color de fondo a #0083F7
        padding: const EdgeInsets.only(top: 40.0, right: 20.0, bottom: 20.0, left: 20.0),
        child: Column(
          children: <Widget>[
            // Cabecera del Drawer con la imagen y los datos del usuario a la derecha
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset('assets/images/axionlogo2.png') // Icono con color azul
                  ),
                  SizedBox(width: 16), // Espacio entre la imagen y el texto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName, // Mostrar el nombre del usuario
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _userEmail, // Mostrar el correo del usuario
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Aquí eliminamos los márgenes a la izquierda en los ListTile con contentPadding vacío


            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Aprendizaje',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                // Redirigir a la vista de Cálculo de Potencia
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Cálculo Óptico',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                // Redirigir a la vista de Cálculo de Potencia
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculoOpticoScreen()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Código de Colores',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                  // Acción al presionar 'Codigo de colores'
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CodigoColoresScreen()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'GeoAxion (Pronto)',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                  // Acción al presionar 'Generar reporte'
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ReportesScreen()),
                // );
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Generar Reporte (Pronto)',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                  // Acción al presionar 'Generar reporte'
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ReportesScreen()),
                // );
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Comunidad (Pronto)',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                  // Acción al presionar 'Comunidad'
              },
            ),

            Divider(color: Colors.white), // Línea separadora blanca

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // Elimina los márgenes a la izquierda
              title: Text(
                'Gestionar cuenta',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: () {
                // Acción al presionar 'Gestionar cuenta'
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditarPerfilScreen()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),  // Elimina los márgenes a la izquierda
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onTap: _logout, // Llama a la función _logout al presionar
            ),
            // ListTile(
            //   contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
            //   title: Text(
            //     'Suscripciones',
            //     style: TextStyle(color: Colors.white), // Texto blanco
            //   ),
            //   onTap: () {
            //     // Acción al presionar 'Suscripciones'
            //   },
            // ),
            // ListTile(
            //   contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Elimina los márgenes a la izquierda
            //   title: Text(
            //     'Ajustes',
            //     style: TextStyle(color: Colors.white), // Texto blanco
            //   ),
            //   onTap: () {
            //     // Acción al presionar 'Ajustes'
            //   },
            // ),
            Spacer(), // Asegura que la imagen esté en la parte inferior
            Image.asset(
              'assets/images/axionlogo.png',
              height: 50, // Ajusta el tamaño de la imagen si es necesario
              width: 100,
              fit: BoxFit.contain,
            ),
            // Agregar el texto debajo de la imagen
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                children: [
                  Text(
                    'Versión Beta V1.001',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4), // Espacio entre los textos
                  Text(
                    '2025 - © All rights reserved',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Espacio adicional al final
          ],
        ),
      ),
    );
  }
}
