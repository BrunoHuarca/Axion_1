import 'dart:convert';
import 'dart:io'; 
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para detectar si es Web
import 'package:image_picker/image_picker.dart';
import 'package:axion_app/models/user.dart';
import 'package:axion_app/services/api_service.dart';

class EditarPerfilScreen extends StatefulWidget {
  final User user;

  EditarPerfilScreen({required this.user});

  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usuarioController;
  late TextEditingController emailController;
  late TextEditingController celularController;
  String? _fotoPerfil; 

  final ApiService apiService = ApiService();
  File? _imageFile;
  String? _base64Image;
  int? userId;

  @override
  void initState() {
    super.initState();
    _cargarUserId();
    usuarioController = TextEditingController(text: widget.user.usuario);
    emailController = TextEditingController(text: widget.user.email);
    celularController = TextEditingController(text: widget.user.celular);
    _cargarFotoPerfil();
  }

  Future<void> _cargarUserId() async {
    int? id = await ApiService().obtenerIdUsuario();
    setState(() {
      userId = id;
    });
  }

  @override
  void dispose() {
    usuarioController.dispose();
    emailController.dispose();
    celularController.dispose();
    super.dispose();
  }

  void _cargarFotoPerfil() async {
    if (userId != null) {
      String? url = await ApiService().obtenerFotoPerfil(userId!);
      if (url != null) {
        setState(() {
          _fotoPerfil = url;
        });
      }
    }
  }

  Future<void> _seleccionarImagen(int userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // 🌐 Código para Web
        final bytes = await pickedFile.readAsBytes();
        _base64Image = base64Encode(bytes);
      } else {
        // 📱 Código para Android/iOS
        File imageFile = File(pickedFile.path);
        String? imageUrl = await ApiService().subirImagen(imageFile, userId);

        if (imageUrl != null) {
          print("✅ Imagen actualizada correctamente: $imageUrl");
          setState(() {
            _fotoPerfil = imageUrl;
          });
        } else {
          print("❌ Error al actualizar la imagen.");
        }
      }
    } else {
      print("⚠️ No se seleccionó ninguna imagen.");
    }
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      User usuarioActualizado = User(
        id: widget.user.id,
        usuario: usuarioController.text,
        email: emailController.text,
        celular: celularController.text,
        imagenBase64: _base64Image, 
      );

      bool actualizado = await apiService.actualizarUsuario(usuarioActualizado);

      if (actualizado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Usuario actualizado correctamente.")),
        );
        Navigator.pop(context, usuarioActualizado);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Error al actualizar el usuario.")),
        );
      }
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
            title: Text("Editar Perfil"),
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
                      GestureDetector(
                        // onTap: () {
                        //   if (userId != null) {
                        //     _seleccionarImagen(userId!);
                        //   } else {
                        //     print("⚠️ Error: userId no está disponible.");
                        //   }
                        // },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _fotoPerfil != null
                              ? NetworkImage(_fotoPerfil!)
                              : AssetImage("assets/images/usuarioaxion.png") as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                _buildTextField("Usuario", usuarioController, Icons.person),
                _buildTextField("Email", emailController, Icons.email),
                _buildTextField("Celular", celularController, Icons.phone),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(Icons.check, Colors.white, _guardarCambios),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
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
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.blueGrey),
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
