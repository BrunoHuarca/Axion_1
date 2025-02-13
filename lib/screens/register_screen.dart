import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordValid = false;
  bool _showPasswordRequirements = false;
  bool _acceptTerms = false;
  bool _passwordsMatch = true;
  String _passwordStrength = "Débil";

  final _formKey = GlobalKey<FormState>();

  void _validatePassword(String value) {
    bool hasMinLength = value.length >= 8;
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>0-9]').hasMatch(value);
    bool hasNoSpaces = !value.contains(' ');
    bool doesNotContainNameOrEmail =
        !_nameController.text.contains(value) && !_emailController.text.contains(value);

    setState(() {
      _isPasswordValid = hasMinLength && hasSpecialChar && hasNoSpaces && doesNotContainNameOrEmail;
      _passwordStrength = _isPasswordValid ? "Fuerte" : "Débil";
      _showPasswordRequirements = !_isPasswordValid;
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _passwordsMatch = value == _passwordController.text;
    });
  }

  void _register() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms || !_isPasswordValid || !_passwordsMatch) {
      setState(() => _showPasswordRequirements = !_isPasswordValid);
      return;
    }

    setState(() => _isLoading = true);

    final user = User(
      name: _nameController.text.trim(),
      apellido: _apellidoController.text.trim(),
      usuario: _usuarioController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      celular: "$_selectedCountryCode ${_celularController.text.trim()}",
    );

    try {
      await _apiService.registerUser(user);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showErrorDialog('Error al registrar usuario: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> _countryCodes = [
    {"name": "Argentina", "code": "+54"},
    {"name": "Bolivia", "code": "+591"},
    {"name": "Chile", "code": "+56"},
    {"name": "Colombia", "code": "+57"},
    {"name": "Costa Rica", "code": "+506"},
    {"name": "Cuba", "code": "+53"},
    {"name": "Ecuador", "code": "+593"},
    {"name": "El Salvador", "code": "+503"},
    {"name": "Guatemala", "code": "+502"},
    {"name": "Honduras", "code": "+504"},
    {"name": "México", "code": "+52"},
    {"name": "Nicaragua", "code": "+505"},
    {"name": "Panamá", "code": "+507"},
    {"name": "Paraguay", "code": "+595"},
    {"name": "Perú", "code": "+51"},
    {"name": "Rep. Dominicana", "code": "+1"},
    {"name": "Uruguay", "code": "+598"},
    {"name": "Venezuela", "code": "+58"},
  ];

  String _selectedCountryCode = "+51"; // Código por defecto (Perú)


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // ✅ Correcto: esto centra todo horizontalmente
              mainAxisAlignment: MainAxisAlignment.center, // ✅ Asegura mejor alineación vertical
              children: [
              SizedBox(height: 20),
              /// 🌟 Envuelve los textos en un `Align` para asegurarte de que se centran bien
              Align(
                alignment: Alignment.center, // ✅ Centrado
                child: Column(
                  children: [
                    Text(
                      "Regístrate",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Ingrese la información para crear su cuenta con nosotros",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

                SizedBox(height: 20),

                _buildTextField(_nameController, "Nombre"),
                _buildTextField(_apellidoController, "Apellido"),
                _buildTextField(_usuarioController, "Usuario"),
                _buildEmailField(),
                _buildPasswordField(),
                SizedBox(height: 15),
                _buildConfirmPasswordField(),
                SizedBox(height: 20),

                _buildPhoneField(),

                SizedBox(height: 15),
                _buildTermsAndConditions(),

                if (_showPasswordRequirements) _buildPasswordRequirements(),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _acceptTerms ? _register : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _acceptTerms ? Color(0xFF163C9F) : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Registrarse', style: TextStyle(fontSize: 16)),
                  ),
                ),
                 SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes una cuenta?",
                        style: TextStyle(fontSize: 14, color: Color(0xFF2E3E5C)), // Color gris azulado
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                          "Ingresar",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF163C9F)), // Azul y en negrita
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15), // Espaciado entre campos
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F6FB),
          borderRadius: BorderRadius.circular(11),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ),
    );
  }
  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F6FB),
          borderRadius: BorderRadius.circular(11),
        ),
        child: TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Correo electrónico",
            labelStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es obligatorio';
            }
            bool emailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value);
            if (!emailValid) {
              return 'Ingrese un correo válido';
            }
            return null;
          },
        ),
      ),
    );
  }


  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Fuerza de la contraseña: $_passwordStrength",
            style: TextStyle(color: _isPasswordValid ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _passwordRequirement("Mínimo 8 caracteres", _passwordController.text.length >= 8),
        _passwordRequirement("Debe contener un número o símbolo", RegExp(r'[!@#$%^&*(),.?":{}|<>0-9]').hasMatch(_passwordController.text)),
        _passwordRequirement("No debe contener espacios", !_passwordController.text.contains(" ")),
        _passwordRequirement("No debe contener su nombre o email",
            !_nameController.text.contains(_passwordController.text) && !_emailController.text.contains(_passwordController.text)),
      ],
    );
  }

  Widget _passwordRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? Colors.green : Colors.red),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: isValid ? Colors.green : Colors.red)),
      ],
    );
  }
  Widget _buildPhoneField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F6FB),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCountryCode = newValue!;
                  });
                },
                items: _countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country["code"],
                    child: Text(country["code"]!, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
                underline: SizedBox(), // Ocultar la línea predeterminada del dropdown
              ),
            ),
            Container(
              height: 40,
              width: 1.5, // Línea divisoria
              color: Colors.grey[400],
            ),
            Expanded(
              child: TextFormField(
                controller: _celularController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Número de celular',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese un número válido';
                  }
                  if (!RegExp(r'^\d{6,12}$').hasMatch(value)) {
                    return 'Ingrese solo números (6-12 dígitos)';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(value: _acceptTerms, onChanged: (value) => setState(() => _acceptTerms = value!)),
        Expanded(child: Text("Acepto la Política de Usuario y las Condiciones de Uso")),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F6FB),
        borderRadius: BorderRadius.circular(11),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: "Contraseña",
          labelStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
        onChanged: _validatePassword,
      ),
    );
  }


  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F6FB),
        borderRadius: BorderRadius.circular(11),
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: !_isConfirmPasswordVisible,
        decoration: InputDecoration(
          labelText: "Confirmar contraseña",
          labelStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Confirme su contraseña';
          }
          if (value != _passwordController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
      ),
    );
  }


}
