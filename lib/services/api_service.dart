import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria.dart'; // Importar correctamente el modelo Categoria
import '../models/section.dart';  // Importar correctamente el modelo Section
import '../models/user.dart'; // O la ruta correcta a tu archivo User
import '../models/documento.dart'; // O la ruta correcta a tu archivo Documento

class ApiService {
  static const String baseUrl = 'https://api.axioneduca.com/apii'; // Asegúrate de que la URL esté bien

  // Registrar un usuario
  Future<void> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      print('Usuario registrado');
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  // Login de usuario
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'contraseña': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Login exitoso: ${data['message']}');
      return data; // Retorna la respuesta para que puedas manejarla en la UI
    } else {
      print('Error al iniciar sesión: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      throw Exception('Error al hacer login');
    }
  }

  // Obtener categorías
  Future<List<Categoria>> getCategorias() async {
    final response = await http.get(Uri.parse('$baseUrl/categorias'));

    if (response.statusCode == 200) {
      List<dynamic> categoriasJson = jsonDecode(response.body);
      return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las categorías');
    }
  }

  // Obtener secciones por categoría
  Future<List<Section>> getSecciones(int categoriaId) async {
    final response = await http.get(Uri.parse('$baseUrl/secciones/categoria/$categoriaId'));

    if (response.statusCode == 200) {
      List<dynamic> seccionesJson = jsonDecode(response.body);
      return seccionesJson.map((json) => Section.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las secciones');
    }
  }

  // Obtener documentos por sección
  Future<List<Documento>> getDocumentosPorSeccion(int seccionId) async {
    final response = await http.get(Uri.parse('$baseUrl/documentos/seccion/$seccionId'));

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print('Respuesta de la API: $responseBody');

      try {
        List<dynamic> json = jsonDecode(responseBody);

        if (json is List) {
          return json.map((documento) => Documento.fromJson(documento)).toList();
        } else {
          throw Exception('La respuesta no es una lista válida de documentos');
        }
      } catch (e) {
        print('Error al decodificar la respuesta: $e');
        throw Exception('Error al decodificar los documentos');
      }
    } else {
      print('Error al cargar documentos: ${response.statusCode}');
      throw Exception('Error al cargar documentos: ${response.statusCode}');
    }
  }

  // Almacenar el token de sesión localmente (puedes usar `shared_preferences` o cualquier otra forma)
  Future<void> storeToken(String token) async {
    // Aquí puedes usar shared_preferences o cualquier otro paquete para almacenar el token
    print('Token almacenado: $token');
  }


Future<void> updateUser(int id, String nombre, String email, String passwordActual, String passwordNueva) async {
  final url = '$baseUrl/usuarios/$id';
  final body = {
    "nombre": nombre,
    "email": email,
  };

  if (passwordNueva.isNotEmpty) {
    body["contraseñaActual"] = passwordActual;
    body["nuevaContraseña"] = passwordNueva;
  }
  print('📤 Enviando datos al servidor: ${jsonEncode(body)}'); // Agregar esto
  final response = await http.put(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    print('Usuario actualizado correctamente');
  } else {
    print('Error al actualizar usuario: ${response.body}');
    throw Exception('Error al actualizar usuario');
  }
}


}



