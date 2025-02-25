import 'package:flutter/material.dart';
import 'package:axion_app/screens/home_screen.dart';
import 'package:axion_app/screens/herramientas_screen.dart';
import 'package:axion_app/screens/proyectos_screen.dart';
import 'package:axion_app/screens/comunidad_screen.dart';
import 'drawer.dart';
import 'dart:ui'; // Agrega esta línea
import 'package:axion_app/models/user.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/screens/calculo_potencia_screen.dart';
import 'package:axion_app/screens/codigo_colores_screen.dart';
import 'package:axion_app/screens/perfil_screen.dart';
import 'package:axion_app/screens/geoaxion_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  
  InicioScreen({required this.toggleTheme, required this.isDarkMode});
  @override
  _InicioScreenState createState() => _InicioScreenState();
}
class _InicioScreenState extends State<InicioScreen> {
  late Map<String, Widget> _screenMap; // Declarar sin inicializar
  late List<Widget> _screens;
  late bool _isDarkMode;

  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  User? _user; // Variable para almacenar el usuario
  String userName = "Usuario"; // Aquí debes reemplazar con el nombre del usuario logueado
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Clave para controlar el Scaffold
  int _selectedIndex = 0; // Variable para trackear el ícono seleccionado
  // Listas de títulos, colores y descripciones de los íconos
  final List<String> _titles = ['Aprendizaje','Herramientas','Reportes','Comunidad',
  ];
  final List<Color> _iconColors = [
    Color(0xFF0083F7), Colors.red, Colors.orange, Colors.green,
  ];
  final List<String> _descriptions = [
    "Aprende más sobre la fibra óptica",
    "Desarrollar y gestionar proyectos",
    "Crea y visualiza reportes detallados",
    "Conversa con los mejores en el rubro",
  ];
  final List<IconData> _iconList = [
  Icons.book,
  Icons.build,
  Icons.report,
  Icons.group,
];
  // Controlador del PageView con viewportFraction para ajustar el ancho de cada página
  final PageController _pageController = PageController(viewportFraction: 0.85); // Establecer a 1.0
  // Controlador de desplazamiento para la fila de iconos
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose(); // Limpia el controlador cuando ya no se necesite
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos al iniciar la pantalla
      _getDarkModePreference().then((value) {
    setState(() {
      _isDarkMode = value;
    });
  });
    _isDarkMode = widget.isDarkMode;
        _screenMap = {
      "Aprendizaje": HomeScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      "Herramientas": HerramientasScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      "Reportes": ProyectsScreen(),
      "Comunidad": ComunidadScreen(),
      "Cálculo Óptico": CalculoOpticoScreen(),
      "Código de Colores": CodigoColoresScreen(),
      "GeoAxion": GeoAxionScreen(),
      "Perfil": PerfilScreen(),
    };
        _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      HerramientasScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      ProyectsScreen(),
      ComunidadScreen(),
    ];
  }
  void _changeTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.toggleTheme(value);
  }
    // Función para obtener los datos del usuario
  void _loadUserData() async {
    final apiService = ApiService();
    final userData = await apiService.obtenerDatosUsuario();

    if (userData != null) {
      setState(() {
        _user = User.fromJson(userData); // Convertir los datos a objeto User
        userName = _user!.usuario; // Asigna el nombre del usuario
      });
      print('✅ Usuario cargado: $_user');
    } else {
      print('⚠️ No se pudieron obtener los datos del usuario.');
    }
  }
void _updateSearchResults(String query) {
  if (query.isEmpty) {
    setState(() {
      _searchResults.clear();
    });
    _overlayEntry?.remove();
    _overlayEntry = null;
    return;
  }

  List<String> filteredResults = _screenMap.keys
      .where((title) => title.toLowerCase().contains(query.toLowerCase()))
      .toList();

  setState(() {
    _searchResults = filteredResults;
  });

  if (_searchResults.isNotEmpty) {
    _showOverlay();
  } else {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

void _navigateToScreen(String selectedTitle) {
  if (_screenMap.containsKey(selectedTitle)) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _screenMap[selectedTitle]!),
    );
  } else {
    print("⚠️ No se encontró la pantalla para '$selectedTitle'");
  }
}
Future<bool> _getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
}

void _showOverlay() {
  _overlayEntry?.remove();
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      width: MediaQuery.of(context).size.width - 20,
      child: CompositedTransformFollower(
        link: _layerLink,
        offset: Offset(0, 50),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                  onTap: () {
                    _navigateToScreen(_searchResults[index]);
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                    });
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(_overlayEntry!);
}
@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double sliderWidth = screenWidth * 0.80;
  return Scaffold(
    key: _scaffoldKey,
    drawer: CustomDrawer(
      toggleTheme: widget.toggleTheme,
      isDarkMode: widget.isDarkMode,
    ),
    backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
    body: Column(
      children: [
        // Cabecera fija
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.black : Color(0xFF0B3A90),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? Colors.grey[700] : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.menu, 
                          color: widget.isDarkMode ? Colors.white : Colors.black, 
                          size: 30),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PerfilScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? Colors.white : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          './assets/images/usuarioaxion.png',
                          height: 45,
                          width: 45,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hola, $userName 🖐",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "¿Qué deseas hacer hoy?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Notificaciones presionadas');
                      },
                      child: Icon(Icons.notifications, color: Colors.white, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CompositedTransformTarget(
                  link: _layerLink,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.black, // 🔥 Ahora el cursor será negro
                      onChanged: (query) {
                        print("🔍 Buscando: $query"); // Debug
                        _updateSearchResults(query);
                      },
                      decoration: InputDecoration(
                        hintText: "Buscar...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        // Contenido desplazable
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 10),
                // // Título "NUESTRAS CATEGORÍAS"
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "NUESTRAS CATEGORÍAS",
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: widget.isDarkMode ? Colors.white : Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 🔹 2 columnas
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.6, // 🔹 Más alto
    ),
    itemCount: _titles.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _screens[index]),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/images/slider_image${index + 1}.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // 🔹 Ícono en la parte superior
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _iconList[index],
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),

              // 🔹 Fondo desenfocado con botón y descripción
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 🔹 Alineado a la izquierda
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔹 Botón con el nombre de la tarjeta
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => _screens[index]),
                              );
                            },
                            child: Text(
                              _titles[index], // 🔹 Texto dinámico con el nombre de la tarjeta
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                          SizedBox(height: 10),

                          // 🔹 Descripción debajo del botón
                          Text(
                            _descriptions[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
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


                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
