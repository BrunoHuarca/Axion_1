import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:axion_app/models/user.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/screens/editar_perfil_screen.dart';
import 'package:axion_app/screens/editar_contrasena_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  User? _user;
  bool _isPasswordVisible = false; // Estado para controlar la visibilidad

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario desde SharedPreferences
void _loadUserData() async {
  final apiService = ApiService();
  final userData = await apiService.obtenerDatosUsuario();
  final prefs = await SharedPreferences.getInstance();
  
  final storedPassword = prefs.getString('user_password') ?? '********'; // Contraseña ingresada en login

  if (userData != null) {
    print('✅ Datos obtenidos del usuario: $userData');
    setState(() {
      _user = User.fromJson(userData).copyWith(password: storedPassword);
    });
  } else {
    print('⚠️ No se pudieron obtener los datos del usuario.');
  }
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight), // Mantiene la altura estándar
      child: Container(
        padding: EdgeInsets.only(top: 25), // 🔹 Agrega el espacio superior
        color: Colors.white, // Asegura que el fondo sea blanco
        child: AppBar(
          title: Text("Perfil"),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
    ),

    backgroundColor: Colors.white, // Fondo del Scaffold en blanco
    body: Padding(
      padding: const EdgeInsets.only(top: 40.0, right: 20.0, bottom: 20.0, left: 20.0),
      child: _user == null
          ? Center(child: CircularProgressIndicator()) // Muestra cargando si no hay datos
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de perfil y nombre de usuario
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Alinea los elementos a la izquierda
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/usuarioaxion.png'),
                    ),
                    SizedBox(width: 20), // Espacio entre la imagen y el texto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                      children: [
                        Text(
                          "${_user!.usuario}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Usuario",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Campos de información
                _buildInfoField("Usuario", _user!.usuario, Icons.person),
                _buildPasswordField("Contraseña", _user!.password),
                _buildInfoField("Email", _user!.email, Icons.email),
                _buildInfoField("Celular", _user!.celular, Icons.phone),
                SizedBox(height: 30),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE91E1E),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder( // 🔹 Agregar border radius
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final usuarioActualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarPerfilScreen(user: _user!),
                            ),
                          );

                          if (usuarioActualizado != null) {
                            setState(() {
                              _user = usuarioActualizado;
                            });
                          }
                        },

                        child: Text(
                          "Editar Información",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF163C9F),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder( // 🔹 Agregar border radius
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarContrasenaScreen(userId: _user!.id),
                          ),
                        );
                        },
                        child: Text(
                          "Cambiar Contraseña",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
    ),
  );
}


// Widget para mostrar los campos de información con iconos
Widget _buildInfoField(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 🔹 Mismo padding en todos
          decoration: BoxDecoration(
            color: Color(0xFFF1F6FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey), // 📌 Ícono a la izquierda
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget para el campo de contraseña con icono e ícono de visibilidad
Widget _buildPasswordField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 🔹 Mismo padding
          decoration: BoxDecoration(
            color: Color(0xFFF1F6FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.grey), // 📌 Ícono de candado
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isPasswordVisible ? value : '********',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: SizedBox(
                  width: 24, // 🔹 Tamaño fijo para que no altere la altura
                  height: 24,
                  child: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


}
