import 'package:flutter/material.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/models/section.dart';
import 'documentos_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:axion_app/widgets/loading_widget.dart';

class SeccionesScreen extends StatefulWidget {
  final int categoriaId;
  final String categoriaNombre;

  SeccionesScreen({required this.categoriaId, required this.categoriaNombre});

  @override
  _SeccionesScreenState createState() => _SeccionesScreenState();
}

class _SeccionesScreenState extends State<SeccionesScreen> {
  bool isGridView = false;
  late bool _isDarkMode;

void initState() {
  super.initState();
  _getDarkModePreference().then((value) {
    setState(() {
      _isDarkMode = value;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 40), // Aumenta la altura
          child: Container(
            padding: EdgeInsets.only(top: 30), // Más espacio arriba y abajo
            color: _isDarkMode ? Colors.black : Colors.white,
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black, size: 26), // Aumenta el tamaño del icono si es necesario
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.categoriaNombre, // Muestra el nombre de la categoría
                style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20),
              ),
              backgroundColor: _isDarkMode ? Colors.black : Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),


      body: Column(
        children: [
          Container(
            color: _isDarkMode ? Colors.black : Colors.white, // Fondo blanco
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: _fetchSecciones(widget.categoriaId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "FOLDERS (...)",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "FOLDERS (Error)",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }
                    final secciones = snapshot.data as List<Section>;
                    return Text(
                      "FOLDERS (${secciones.length.toString().padLeft(2, '0')})",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.view_list, color: isGridView ? Colors.grey : Colors.blue),
                      onPressed: () => setState(() => isGridView = false),
                    ),
                    IconButton(
                      icon: Icon(Icons.grid_view, color: isGridView ? Colors.blue : Colors.grey),
                      onPressed: () => setState(() => isGridView = true),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(color: _isDarkMode ? Colors.black : Colors.white),
              child: FutureBuilder(
                future: _fetchSecciones(widget.categoriaId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: LoadingWidget(animationPath: 'assets/icons/mano.json'));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final secciones = snapshot.data as List<Section>;

                  return isGridView ? _buildGridView(secciones) : _buildListView(secciones);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Section> secciones) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      itemCount: secciones.length,
      itemBuilder: (context, index) {
        return _buildListItem(context, secciones[index]);
      },
    );
  }

  Widget _buildGridView(List<Section> secciones) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: secciones.length,
      itemBuilder: (context, index) {
        return _buildGridItem(context, secciones[index]);
      },
    );
  }

  Widget _buildListItem(BuildContext context, Section seccion) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DocumentosScreen(seccionId: seccion.id, seccionNombre: seccion.nombre)),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: _isDarkMode ? Colors.grey[900] : Color(0xFFE0F2FE),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  color: _isDarkMode ? const Color.fromARGB(255, 54, 54, 54) : Color(0xFFA1BEF5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.folder, color: _isDarkMode ? Colors.white : Color(0xFF123AA0), size: 30),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  child: Text(
                    seccion.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w400, color: _isDarkMode ? Colors.white : Colors.black, fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.arrow_forward_ios, color: _isDarkMode ? Colors.white : Color(0xFF000012), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildGridItem(BuildContext context, Section seccion) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocumentosScreen(seccionId: seccion.id, seccionNombre: seccion.nombre)),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: _isDarkMode ? Colors.grey[900] : Color(0xFFE0F2FE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color.fromARGB(255, 54, 54, 54) : Color(0xFFA1BEF5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Center(
              child: Icon(Icons.folder, color: _isDarkMode ? Colors.white : Color(0xFF123AA0), size: 90),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seccion.nombre,
                  maxLines: 2, // Máximo 1 línea
                  overflow: TextOverflow.ellipsis, // Muestra "..."
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  seccion.descripcion ?? "Sin descripción",
                  maxLines: 2, // Máximo 2 líneas antes de truncar
                  overflow: TextOverflow.ellipsis, // Muestra "..." si se excede
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: _isDarkMode ? Colors.white : Colors.black54,
                    fontSize: 12,
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


Future<bool> _getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
}

  Future<List<Section>> _fetchSecciones(int categoriaId) async {
    try {
      return await ApiService().getSecciones(categoriaId);
    } catch (e) {
      throw Exception('Error al obtener las secciones: $e');
    }
  }
}
