import 'package:flutter/material.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/models/section.dart';
import 'documentos_screen.dart';

class SeccionesScreen extends StatefulWidget {
  final int categoriaId;
  final String categoriaNombre;

  SeccionesScreen({required this.categoriaId, required this.categoriaNombre});

  @override
  _SeccionesScreenState createState() => _SeccionesScreenState();
}

class _SeccionesScreenState extends State<SeccionesScreen> {
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
                    widget.categoriaNombre,
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

          // Lista de secciones
          Expanded(
            child: FutureBuilder(
              future: _fetchSecciones(widget.categoriaId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final secciones = snapshot.data as List<Section>;
                return ListView.builder(
                  itemCount: secciones.length,
                  itemBuilder: (context, index) {
                    final seccion = secciones[index];
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
                          seccion.nombre,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(seccion.descripcion, style: TextStyle(color: Colors.white70)),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocumentosScreen(seccionId: seccion.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Section>> _fetchSecciones(int categoriaId) async {
    try {
      return await ApiService().getSecciones(categoriaId);
    } catch (e) {
      throw Exception('Error al obtener las secciones: $e');
    }
  }
}
