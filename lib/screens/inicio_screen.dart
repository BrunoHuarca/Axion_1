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
    "Sumérgete en el mundo de las telecomunicaciones con información sobre fibra óptica",
    "Herramientas avanzadas para desarrollar y gestionar proyectos tecnológicos en telecomunicaciones.",
    "Genera y visualiza reportes detallados sobre el rendimiento de tus proyectos.",
    "Conéctate con la comunidad y comparte tus proyectos con otros profesionales del área.",
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

  print("📌 Sugerencias encontradas: $filteredResults"); // Debug

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
    backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
    body: Column(
      children: [
        // Cabecera fija
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Color(0xFF0B3A90),
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
                        print('Imagen de perfil presionada');
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? Colors.grey[700] : Colors.white,
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
                // Íconos en la parte superior
                Container(
                  height: 100,
                  width: double.infinity,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _titles.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isActive = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });

                          // 🔹 Desplazamiento dinámico para centrar el icono activo y ver solo 2
                          double screenWidth = MediaQuery.of(context).size.width;
                          double itemWidth = screenWidth / 2; // 2 elementos por pantalla
                          double scrollTo = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

                          _scrollController.animateTo(
                            scrollTo.clamp(0.0, _scrollController.position.maxScrollExtent),
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                          _pageController.jumpToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width / 2, // Mostrar solo 2 íconos en pantalla
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: isActive ? 70 : 60,
                                height: isActive ? 70 : 60,
                                decoration: BoxDecoration(
                                  color: _iconColors[index],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    _iconList[index],
                                    color: Colors.white,
                                    size: isActive ? 34 : 28,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _titles[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _iconColors[index],
                                  fontWeight: FontWeight.bold,
                                  fontSize: isActive ? 16 : 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),
                // Título "NUESTRAS CATEGORÍAS"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "NUESTRAS CATEGORÍAS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Slider
                Container(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });

                      // 🔹 Asegurar que el ícono activo SIEMPRE sea visible
                      double itemWidth = 150; // Estimación del ancho de cada ícono
                      double screenWidth = MediaQuery.of(context).size.width;
                      double scrollTo = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

                      // 🔹 Evita que el scroll pase el máximo disponible
                      _scrollController.animateTo(
                        scrollTo.clamp(0.0, _scrollController.position.maxScrollExtent),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },


                    itemCount: _titles.length,
                    itemBuilder: (context, index) {
                    bool isActive = _selectedIndex == index;

                    double width = isActive ? 300 : 230;  // Reducimos más los inactivos
                    double height = isActive ? 500 : 280; // Misma lógica con la altura
                    double opacity = isActive ? 1.0 : 0.6; // Baja opacidad para inactivos
                    double marginRight = isActive ? 20 : 0; // Mantiene espacio entre slides

                    return Align(
                      alignment: Alignment.centerLeft, // Alinea el slider activo a la izquierda
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut, // Suaviza la animación
                        width: width,
                        height: height,
                        margin: EdgeInsets.only(right: marginRight), // Espaciado solo en el activo
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Opacity(
                          opacity: opacity, // Opacidad para sliders inactivos
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                // Imagen de fondo
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/slider_image${index + 1}.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Efecto de desenfoque en la parte inferior
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
                                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Contenido sobre la imagen
                                Positioned(
                                  bottom: 10,
                                  left: 20,
                                  right: 20,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => _screens[index]),
                                              );
                                            },
                                            child: Text(
                                              _titles[index],
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Icon(
                                              _iconList[index],
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          _descriptions[index],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }



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
