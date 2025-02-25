import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComunidadScreen extends StatefulWidget {
  @override
  _ComunidadScreenState createState() => _ComunidadScreenState();
}

class _ComunidadScreenState extends State<ComunidadScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _getDarkModePreference();
  }

  Future<void> _getDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 25),
          color: _isDarkMode ? Colors.black : Colors.white,
          child: AppBar(
            title: Text("Comunidad"),
            backgroundColor: _isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/fondomp.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  'MUY\nPRONTO',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: _isDarkMode ? Colors.white : Color(0xFF001520),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Pronto estaremos\nabriendo esta función',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: _isDarkMode ? Colors.white : Color(0xFF023047),
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
