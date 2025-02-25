import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculoOpticoScreen extends StatefulWidget {
  @override
  _CalculoOpticoScreenState createState() => _CalculoOpticoScreenState();
}

class _CalculoOpticoScreenState extends State<CalculoOpticoScreen> {
  final TextEditingController _potenciaBaseController = TextEditingController();
  final Map<String, TextEditingController> _cantidadControllers = {};
  bool _isDarkMode = false;

  final List<Map<String, dynamic>> _elementos = [
    {"nombre": "Fusión", "atenuacion": 0.2},
    {"nombre": "Distancia por KM", "atenuacion": 0.35},
    {"nombre": "SPL 1X8", "atenuacion": 10.3},
    {"nombre": "SPL 1X16", "atenuacion": 13.6},
    {"nombre": "Enfrentadores", "atenuacion": 0.5},
    {"nombre": "Conectores Mecánicos", "atenuacion": 0.7},
  ];

  double _totalAtenuacion = 0.0;
  double _totalPotencia = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarPreferenciaModoOscuro();
    for (var elemento in _elementos) {
      _cantidadControllers[elemento["nombre"]] = TextEditingController();
    }
  }

  Future<void> _cargarPreferenciaModoOscuro() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  void _calcularTotales() {
    double totalAtenuacion = 0.0;
    for (var elemento in _elementos) {
      int cantidad = int.tryParse(_cantidadControllers[elemento["nombre"]]!.text) ?? 0;
      totalAtenuacion += elemento["atenuacion"] * cantidad;
    }

    double potenciaBase = double.tryParse(_potenciaBaseController.text) ?? 0.0;
    double totalPotencia = potenciaBase - totalAtenuacion;

    setState(() {
      _totalAtenuacion = totalAtenuacion;
      _totalPotencia = totalPotencia;
    });
  }

  @override
  void dispose() {
    _potenciaBaseController.dispose();
    for (var controller in _cantidadControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color fondo = _isDarkMode ? Colors.black : Colors.white;
    Color textoPrimario = _isDarkMode ? Colors.white : Colors.black;
    Color textoSecundario = _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color inputFondo = _isDarkMode ? Colors.grey[900]! : Color(0xFFF1F6FB);
    Color bordeInput = _isDarkMode ? Colors.grey[700]! : Color(0xFFB1B1B1);

    return Scaffold(
      backgroundColor: fondo,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          color: fondo,
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textoPrimario),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Cálculo Óptico",
              style: TextStyle(color: textoPrimario, fontSize: 20),
            ),
            backgroundColor: fondo,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Potencia Base
            TextField(
              controller: _potenciaBaseController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textoPrimario),
              decoration: InputDecoration(
                labelText: 'Potencia Base (dBm)',
                labelStyle: TextStyle(color: textoSecundario),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: bordeInput),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: bordeInput),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: inputFondo,
                suffixText: "dBm",
                suffixStyle: TextStyle(color: textoPrimario, fontSize: 16),
              ),
              onChanged: (_) => _calcularTotales(),
            ),

            SizedBox(height: 20),

            // Lista de elementos
            Expanded(
              child: ListView(
                children: _elementos.map((elemento) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      bool tieneTexto = _cantidadControllers[elemento["nombre"]]!.text.isNotEmpty;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5, left: 5),
                            child: Text(
                              elemento["nombre"],
                              style: TextStyle(
                                color: textoPrimario,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Atenuación
                              Container(
                                width: 80,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: inputFondo,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  "${elemento["atenuacion"]} dB",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: textoPrimario, fontSize: 15),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Cantidad
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: tieneTexto ? Colors.blue[900] : inputFondo,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextField(
                                    controller: _cantidadControllers[elemento["nombre"]],
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: textoPrimario),
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      hintText: elemento["nombre"],
                                      hintStyle: TextStyle(color: textoSecundario),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (_) {
                                      setState(() {});
                                      _calcularTotales();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Totales
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalCard("Total Atenuación", _totalAtenuacion, Colors.blue),
                  SizedBox(height: 15),
                  _buildTotalCard("Total de Potencia", _totalPotencia, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            "${value.toStringAsFixed(2)} dB",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}