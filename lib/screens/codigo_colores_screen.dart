import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodigoColoresScreen extends StatefulWidget {
  @override
  _CodigoColoresScreenState createState() => _CodigoColoresScreenState();
}

class _CodigoColoresScreenState extends State<CodigoColoresScreen> {
late bool _isDarkMode;

  @override
  void initState() {
  _getDarkModePreference().then((value) {
    setState(() {
      _isDarkMode = value;
    });
  });
  }
Future<bool> _getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
}
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          color: _isDarkMode ? Colors.black : Color(0xFF004CFF),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Código de Colores", style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: _isDarkMode ? Colors.black : Color(0xFF004CFF),
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
    backgroundColor: _isDarkMode ? Colors.black : Color(0xFF004CFF), // Fondo del Scaffold igual al color del encabezado
    body: Column(
      children: [
        // Encabezado sin bordes redondeados
        Container(
          height: MediaQuery.of(context).size.height * 0.35, // Ajustado para más espacio
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.black : Color(0xFF004CFF), // Color sólido sin bordes
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen y título en una fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen a la izquierda
                  Container(
                    width: 80, // Tamaño de la imagen
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),  // Imagen circular
                      image: DecorationImage(
                        image: AssetImage('assets/images/colorescable.png'), // Ruta de la imagen
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Espaciado entre imagen y título

                  // Título a la derecha
                  Expanded(
                    child: Text(
                      'Organización y precisión en tus conexiones',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10), // Espaciado entre título e información

              // Texto descriptivo debajo
              Text(
                'Consulta de manera rápida y sencilla el orden de colores de cada cable, '
                'te ayudará a realizar conexiones precisas y cumplir con los estándares de instalación, '
                'facilitando tu trabajo en campo.',
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),

        // Contenedor con bordes superiores redondeados
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), // Bordes superiores redondeados
                topRight: Radius.circular(50),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.only(top: 25.0, right: 16.0, bottom: 16.0, left: 16.0),
              children: [
                _buildListItem(context, "Estandar Europeo", CableeuropeoHilosScreen(_isDarkMode)),
                _buildListItem(context, "Estandar Americano", CableamericanoHilosScreen(_isDarkMode)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


// Método para construir los ítems de la lista
Widget _buildListItem(BuildContext context, String title, Widget targetScreen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: _isDarkMode ? Colors.grey[700] : Color(0xFFE0F2FE),
      ),
      child: Row(
        children: [
          // Contenedor para el icono de fotografía a la izquierda
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[800] : Color(0xFFA1BEF5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                color: _isDarkMode ? Colors.white : Color(0xFF123AA0),
                size: 30,
              ),
            ),
          ),

          SizedBox(width: 12),

          // Texto del título (Nombre del cable)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Flecha ">" a la derecha
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: _isDarkMode ? Colors.white : Color(0xFF000012),
              size: 20,
            ),
          ),
        ],
      ),
    ),
  );
}


}

// Diferentes pantallas con imágenes


class CableeuropeoHilosScreen extends StatelessWidget {
  final bool isDarkMode;
  CableeuropeoHilosScreen(this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    return buildFullScreenImage(
      context,
      "IEC 60304",
      "assets/images/tabla2.jpg",
      isDarkMode, // Pasar el estado del modo oscuro
    );
  }
}

class CableamericanoHilosScreen extends StatelessWidget {
  final bool isDarkMode;
  CableamericanoHilosScreen(this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    return buildFullScreenImage(
      context,
      "ANSI/TIA-598-D",
      "assets/images/tabla1.jpg",
      isDarkMode, // Pasar el estado del modo oscuro
    );
  }
}



Widget buildFullScreenImage(BuildContext context, String title, String imagePath, bool isDarkMode) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Fondo del AppBar
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // Cambia el color del icono de "atrás"
    ),
    backgroundColor: isDarkMode ? Colors.black : Colors.white, // Fondo blanco
    body: InteractiveViewer(
      panEnabled: true, // Permite mover la imagen
      boundaryMargin: EdgeInsets.zero,
      minScale: 1.0, // Zoom mínimo (tamaño original)
      maxScale: 5.0, // Zoom máximo
      child: Center(
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain, // Ajuste sin recortes
        ),
      ),
    ),
  );
}


