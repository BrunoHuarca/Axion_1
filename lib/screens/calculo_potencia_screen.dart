import 'package:flutter/material.dart';

class CalculoOpticoScreen extends StatefulWidget {
  @override
  _CalculoOpticoScreenState createState() => _CalculoOpticoScreenState();
}

class _CalculoOpticoScreenState extends State<CalculoOpticoScreen> {
  final TextEditingController _potenciaBaseController = TextEditingController();
  final Map<String, TextEditingController> _cantidadControllers = {};
  
  final List<Map<String, dynamic>> _elementos = [
    {"nombre": "FUSION", "atenuacion": 0.2},
    {"nombre": "DISTANCIA POR KM", "atenuacion": 0.35},
    {"nombre": "SPL 1X8", "atenuacion": 10.3},
    {"nombre": "SPL 1X16", "atenuacion": 13.6},
    {"nombre": "ENFRENTADORES", "atenuacion": 0.5},
    {"nombre": "CONECTORES MECANICOS", "atenuacion": 0.7},
  ];

  double _totalAtenuacion = 0.0;
  double _totalPotencia = 0.0;

  @override
  void initState() {
    super.initState();
    for (var elemento in _elementos) {
      _cantidadControllers[elemento["nombre"]] = TextEditingController();
    }
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
    return Scaffold(

      appBar: AppBar(
      title: Text(
        'Cálculo Óptico', 
        style: TextStyle(color: Colors.white),
        ), 
        backgroundColor: Color(0xFF00001B),
        iconTheme: IconThemeData(color: Colors.white) 
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Potencia Base
            TextField(
              controller: _potenciaBaseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Potencia Base (dBm)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _calcularTotales(),
            ),
            SizedBox(height: 20),

            // Tabla de elementos
            Expanded(
              child: ListView(
                children: _elementos.map((elemento) {
                  return Card(
                    color: Color(0xFF0083F7),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nombre del elemento
                          Expanded(
                            child: Text(
                              elemento["nombre"],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 15),
                            ),
                          ),

                          // Atenuación (valor fijo)
                          Text(
                            "${elemento["atenuacion"]} dB ",
                            style: TextStyle(color: Colors.white),
                          ),

                          // Campo de cantidad
                          Container(
                            width: 60,
                            child: TextField(
                              controller: _cantidadControllers[elemento["nombre"]],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "0",
                                hintStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                              onChanged: (_) => _calcularTotales(),
                            ),
                          ),

                          // Resultado por elemento
                          // Text(
                          //   "${(elemento["atenuacion"] * (int.tryParse(_cantidadControllers[elemento["nombre"]]!.text) ?? 0)).toStringAsFixed(2)} dB",
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Totales
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Atenuación:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_totalAtenuacion.toStringAsFixed(2)} dB",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total de Potencia:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_totalPotencia.toStringAsFixed(2)} dBm",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
