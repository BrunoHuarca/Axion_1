import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComunidadScreen extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Mantiene la altura estándar
        child: Container(
          padding: EdgeInsets.only(top: 25), // 🔹 Agrega el espacio superior
          color: Colors.white, // Asegura que el fondo sea blanco
          child: AppBar(
            title: Text("Comunidad"),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Imagen de fondo alineada abajo
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/fondomp.png', // Asegúrate de tener esta imagen en tu proyecto
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Contenido centrado
          // Contenido centrado y un poco más arriba
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15, // Ajusta la altura
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  'MUY\nPRONTO',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w900, // Peso 900
                    color: Color(0xFF001520), // Color del título
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Pronto estaremos\nabriendo esta función',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w400, // Peso 400
                    color: Color(0xFF023047), // Color del texto de abajo
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
