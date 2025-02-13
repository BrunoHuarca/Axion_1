import 'package:flutter/material.dart';
import 'package:axion_app/screens/home_screen.dart';
import 'package:axion_app/screens/calculo_potencia_screen.dart';
import 'package:axion_app/screens/codigo_colores_screen.dart'; // Asegúrate de importar la vista para el Código de Colores
import 'drawer.dart';  // Asegúrate de importar el CustomDrawer
import 'package:axion_app/screens/proyectos_screen.dart';
import 'package:axion_app/screens/herramientas_screen.dart';
import 'package:axion_app/screens/comunidad_screen.dart';

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),  // Usamos el CustomDrawer aquí
      body: Column(
        children: [
          // Cabecera personalizada
          Container(
            height: MediaQuery.of(context).size.height * 0.3,  // 30% del alto de la pantalla
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF00001B),  // Fondo oscuro
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),  // Esquinas redondeadas inferiores
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    '¿Qué deseas \nhacer hoy?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      print('Imagen de perfil presionada');
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        './assets/images/axionlogo2.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Parte inferior que ocupa el 70% de la pantalla
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4, // Hay 4 opciones en total
                itemBuilder: (context, index) {
                  String title = '';
                  Widget targetScreen = Placeholder(); 
                  Color backgroundColor = Colors.blue;
                  
                  switch(index) {
                    case 0:
                      title = 'Aprendizaje';
                      targetScreen = HomeScreen();
                      backgroundColor = Color(0xFF0083F7);
                      break;
                    case 1:
                      title = 'Herramientas';
                      targetScreen = HerramientasScreen(); 
                      backgroundColor = Color(0xFF0083F7);
                      break;
                    case 2:
                      title = 'Reportes\n(Pronto..)';
                      targetScreen = ProyectsScreen();
                      backgroundColor = Color(0xFF0083F7);
                      break;
                    case 3:
                      title = 'Comunidad\n(Pronto..)';
                      targetScreen = ComunidadScreen(); 
                      backgroundColor = Color(0xFF0083F7);
                      break;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => targetScreen),
                      );
                    },
                    child: Card(
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
