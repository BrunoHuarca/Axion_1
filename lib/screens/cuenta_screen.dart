import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class EditarPerfilScreen extends StatefulWidget {
  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _isChangingPassword = false;

  String _nombre = "";
  String _email = "";
  String _passwordActual = "";
  String _passwordNueva = "";
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
      _nombre = prefs.getString('user_name') ?? '';
      _email = prefs.getString('user_email') ?? '';
    });
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await _apiService.updateUser(_userId, _nombre, _email, _passwordActual, _passwordNueva);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nombre);
      await prefs.setString('user_email', _email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado con éxito')),
      );

      setState(() {
        _isEditing = false;
        _isChangingPassword = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow("Nombre", _nombre),
                    _buildInfoRow("Email", _email),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        _isEditing ? "Cancelar" : "Editar Información",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0083F7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // Misma distancia que la tarjeta
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _isChangingPassword = !_isChangingPassword),
                icon: Icon(Icons.lock, color: Colors.white),
                label: Text(
                  _isChangingPassword ? "Cancelar" : "Cambiar Contraseña",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            if (_isEditing) _buildEditForm(),
            if (_isChangingPassword) _buildPasswordChangeForm(),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _nombre,
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
            onSaved: (value) => _nombre = value!,
          ),
          TextFormField(
            initialValue: _email,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Ingrese su email' : null,
            onSaved: (value) => _email = value!,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _updateUser,
            child: Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordChangeForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña Actual'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Ingrese su contraseña actual' : null,
            onSaved: (value) => _passwordActual = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nueva Contraseña'),
            obscureText: true,
            validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
            onSaved: (value) => _passwordNueva = value!,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _updateUser,
            child: Text('Actualizar Contraseña'),
          ),
        ],
      ),
    );
  }
}
