import 'package:flutter/material.dart';
import 'package:axion_app/screens/calculo_potencia_screen.dart';
import 'package:axion_app/screens/codigo_colores_screen.dart'; 
import 'drawer.dart';  
import 'package:axion_app/screens/geoaxion_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HerramientasScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  HerramientasScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _HerramientasScreenState createState() => _HerramientasScreenState();
}

class _HerramientasScreenState extends State<HerramientasScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          color: Color(0xFF00136D),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Herramientas", style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: Color(0xFF00136D),
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      drawer: CustomDrawer(
        toggleTheme: widget.toggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight,
            color: Color(0xFF00136D),
          ),
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF00136D),
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
                            'Optimiza tu trabajo con tecnología',
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
                            'Accede a un conjunto de herramientas diseñadas para facilitar el diseño, implementación y mantenimiento de redes de telecomunicaciones que harán más eficiente tu trabajo en el campo.',
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 30.0, bottom: 20.0, left: 30.0),
                    child: Column(
                      children: [
                        _buildToolItem(
                          title: 'Código de Colores',
                          icon: Icons.palette,
                          iconColor: Colors.blue,
                          backgroundColor: Colors.blue.shade50,
                          targetScreen: CodigoColoresScreen(),
                        ),
                        _buildToolItem(
                          title: 'Cálculo Óptico',
                          icon: Icons.calculate,
                          iconColor: Colors.green,
                          backgroundColor: Colors.green.shade50,
                          targetScreen: CalculoOpticoScreen(),
                        ),
                        _buildToolItem(
                          title: 'GeoAxion',
                          icon: Icons.map,
                          iconColor: Colors.red,
                          backgroundColor: Colors.red.shade50,
                          targetScreen: GeoAxionScreen(),
                        ),
                      ],
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

  Widget _buildToolItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Widget targetScreen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            // Nueva flecha con fondo redondeado
            Container(
              padding: EdgeInsets.all(8), // Espaciado interno
              decoration: BoxDecoration(
                color: iconColor, // Mismo color que el icono principal
                shape: BoxShape.circle, // Hace que sea completamente redondeado
              ),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
