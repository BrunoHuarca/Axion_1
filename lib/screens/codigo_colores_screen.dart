import 'package:flutter/material.dart';

class CodigoColoresScreen extends StatefulWidget {
  @override
  _CodigoColoresScreenState createState() => _CodigoColoresScreenState();
}

class _CodigoColoresScreenState extends State<CodigoColoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Encabezado
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF00001B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    'Código de Colores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Lista de opciones con navegación a diferentes pantallas
          Expanded(
            child: ListView(
              children: [
                _buildListItem(context, "Cable 18 hilos", Cable18HilosScreen()),
                _buildListItem(context, "Cable 14 hilos", Cable14HilosScreen()),
                _buildListItem(context, "Cable 12 hilos", Cable12HilosScreen()),
                _buildListItem(context, "Cable 10 hilos", Cable10HilosScreen()),
                _buildListItem(context, "Cable 8 hilos", Cable8HilosScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir los ítems de la lista
  Widget _buildListItem(BuildContext context, String title, Widget targetScreen) {
    return Card(
      color: Color(0xFF0083F7), // Fondo azul
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }
}

// Diferentes pantallas con imágenes
class Cable18HilosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildDetailScreen(context, "Cable 18 Hilos", "assets/images/cable18.png");
  }
}

class Cable14HilosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildDetailScreen(context, "Cable 14 Hilos", "assets/images/cable14.png");
  }
}

class Cable12HilosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildDetailScreen(context, "Cable 12 Hilos", "assets/images/cable12.png");
  }
}

class Cable10HilosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildDetailScreen(context, "Cable 10 Hilos", "assets/images/cable10.png");
  }
}

class Cable8HilosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildDetailScreen(context, "Cable 8 Hilos", "assets/images/cable8.png");
  }
}

// Método para construir la pantalla de detalle con imagen
Widget buildDetailScreen(BuildContext context, String title, String imagePath) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        title, style: TextStyle(color: Colors.white),
        ), 
        backgroundColor: Color(0xFF00001B),
        iconTheme: IconThemeData(color: Colors.white) 
        ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 200, height: 200),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200)),
        ],
      ),
    ),
  );
}
