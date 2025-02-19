import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarContrasenaScreen extends StatefulWidget {
  final int userId;

  const EditarContrasenaScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EditarContrasenaScreenState createState() => _EditarContrasenaScreenState();
}

class _EditarContrasenaScreenState extends State<EditarContrasenaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contrasenaActualController = TextEditingController();
  final TextEditingController _nuevaContrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController = TextEditingController();
  bool _isLoading = false;
  bool _ocultarContrasenaActual = true;
  bool _ocultarNuevaContrasena = true;
  bool _ocultarConfirmarContrasena = true;

  Future<void> _actualizarContrasena() async {
    if (!_formKey.currentState!.validate()) return;

    if (_nuevaContrasenaController.text != _confirmarContrasenaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Las contraseñas no coinciden")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.put(
      Uri.parse("https://api.axioneduca.com/apii/usuarios/${widget.userId}/contrasena"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contrasenaActual": _contrasenaActualController.text,
        "nuevaContrasena": _nuevaContrasenaController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Contraseña actualizada con éxito")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? "❌ Error al actualizar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 25),
          color: Colors.white,
          child: AppBar(
            title: Text("Editar Contraseña"),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Completa tu Perfil",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "No te preocupes, sólo tú puedes ver tus datos personales. Nadie más podrá verlos.",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage("assets/images/usuarioaxion.png"),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                // ✅ CAMPOS SIN BORDE, TÍTULOS ARRIBA Y CON ICONOS
                _buildTextField(
                  "Contraseña Actual",
                  _contrasenaActualController,
                  Icons.lock,
                  true,
                  _ocultarContrasenaActual,
                  () {
                    setState(() {
                      _ocultarContrasenaActual = !_ocultarContrasenaActual;
                    });
                  },
                ),
                _buildTextField(
                  "Nueva Contraseña",
                  _nuevaContrasenaController,
                  Icons.lock_outline,
                  true,
                  _ocultarNuevaContrasena,
                  () {
                    setState(() {
                      _ocultarNuevaContrasena = !_ocultarNuevaContrasena;
                    });
                  },
                ),
                _buildTextField(
                  "Confirmar Nueva Contraseña",
                  _confirmarContrasenaController,
                  Icons.lock_outline,
                  true,
                  _ocultarConfirmarContrasena,
                  () {
                    setState(() {
                      _ocultarConfirmarContrasena = !_ocultarConfirmarContrasena;
                    });
                  },
                ),

                SizedBox(height: 30),

                // ✅ BOTONES REDONDOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : _buildActionButton(Icons.check, Colors.white, _actualizarContrasena),
                    SizedBox(width: 20),
                    _buildActionButton(Icons.close, Colors.white, () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isPassword, bool isObscured, VoidCallback toggleVisibility) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF1F6FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? isObscured : false, // 🔹 Usa el estado para ocultar/mostrar
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blueGrey),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.blueGrey),
                      onPressed: toggleVisibility,
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: InputBorder.none,
            ),
            validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 28),
        onPressed: onPressed,
      ),
    );
  }
}
