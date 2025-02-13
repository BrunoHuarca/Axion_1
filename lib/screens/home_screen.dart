import 'package:flutter/material.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/models/categoria.dart';
import 'drawer.dart';  // Asegúrate de importar el CustomDrawer
import 'package:axion_app/screens/secciones_screen.dart';  // Asegúrate de que la ruta sea correcta


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categoria> categorias = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  // Obtener categorías desde el servidor
  Future<void> _fetchCategorias() async {
    try {
      final response = await _apiService.getCategorias();
      setState(() {
        categorias = response;
      });
    } catch (e) {
      print('Error al obtener las categorías: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Builder para asegurarnos de que el contexto tenga el Scaffold
      drawer: CustomDrawer(),  // Usamos el CustomDrawer aquí
      body: Column(
        children: [
          // Cabecera personalizada
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
                  top: 40,
                  right: 20,
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
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    '¿Qué deseas \naprender hoy?',
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
          
          // Parte inferior que ocupa el 70% de la pantalla
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: categorias.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = categorias[index];
                        return GestureDetector(
                          onTap: () {
                            if (categoria.id != null) {
                              // Navegar a la pantalla de secciones
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeccionesScreen(categoriaId: categoria.id, categoriaNombre: categoria.nombre,),
                                ),
                              );
                            } else {
                              print('Error: ID de categoría es nulo');
                            }
                          },
                          child: Card(
                            color: categoria.colorAsColor, // Usamos el método colorAsColor
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),  // Añadimos el padding de 20
                              child: Align(
                                alignment: Alignment.topLeft,  // Alineamos el texto arriba a la izquierda
                                child: Text(
                                  categoria.nombre,
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
