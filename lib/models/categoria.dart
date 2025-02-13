import 'package:flutter/material.dart'; // Importa esto para usar Color

class Categoria {
  int id;
  String nombre;
  String descripcion;
  String color; // Asegúrate de tener un campo de color

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
  }) : color = _generateColorFromNombre(nombre);

  // Método para generar un color único basado en el nombre
  static String _generateColorFromNombre(String nombre) {
    // Usamos el hashCode del nombre de la categoría y lo convertimos a un color hexadecimal
    int colorCode = nombre.hashCode & 0xFFFFFF; // Limitamos el valor a 24 bits
    return '0xFF0083F7'; // Devuelve un color hexadecimal
  }

  // Método para obtener el color como un valor de tipo Color
  Color get colorAsColor {
    return Color(int.parse(color)); // Usamos Color de material.dart
  }

  // Método de fábrica para convertir el JSON a un objeto Categoria
    factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
        id: json['Categoria_ID'], // Asegúrate de que 'Categoria_ID' sea el nombre correcto
        nombre: json['Nombre'],
        descripcion: json['Descripcion'],
    );
    }


}
