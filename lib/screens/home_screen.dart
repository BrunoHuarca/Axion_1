import 'package:flutter/material.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/models/categoria.dart';
import 'drawer.dart';
import 'package:axion_app/screens/secciones_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:axion_app/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  
  HomeScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isDarkMode;
  List<Categoria> categorias = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
      _getDarkModePreference().then((value) {
        setState(() {
          _isDarkMode = value;
        });
      });
    _isDarkMode = widget.isDarkMode;
    _fetchCategorias();
  }

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

  // Lista de colores para rotar
  final List<Color> colores = [
    Colors.blue,
    Colors.amber,
    Colors.red,
    Colors.green,
    Colors.purple
  ];

  // Método para asignar icono según el nombre de la categoría
  IconData getIconForCategory(String name) {
    return FontAwesomeIcons.folderOpen;
  }

Future<bool> _getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          color: _isDarkMode ? Colors.black : Color(0xFF00136D),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Aprendizaje",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      drawer: CustomDrawer(
        toggleTheme: widget.toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      body: Stack(
        children: [
          // Fondo dinámico
          Container(
            width: double.infinity,
            height: screenHeight,
            color: _isDarkMode ? Colors.black : Color(0xFF00136D),
          ),
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    color: _isDarkMode ? Colors.grey[900] : Colors.white,
                  ),
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.black : Color(0xFF00136D),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Conocimiento al\nalcance de tu mano',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'con Axion',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Aquí encontrarás información actualizada, explicaciones y material práctico para fortalecer tus conocimientos y habilidades técnicas.\n¡Aprende desde cualquier lugar!',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: categorias.isEmpty
                        ? Center(child: LoadingWidget(animationPath: 'assets/icons/mano.json'))
                        : ListView.builder(
                            itemCount: categorias.length,
                            itemBuilder: (context, index) {
                              final categoria = categorias[index];
                              final color = colores[index % colores.length];

                              return GestureDetector(
                                onTap: () {
                                  if (categoria.id != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeccionesScreen(
                                          categoriaId: categoria.id,
                                          categoriaNombre: categoria.nombre,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print('Error: ID de categoría es nulo');
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.grey[800] : color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  getIconForCategory(categoria.nombre),
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Text(
                                                categoria.nombre,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: _isDarkMode ? Colors.white : Colors.black87,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
