class User {
  final int id;  
  final String name;
  final String apellido;
  final String usuario;
  final String email;
  final String password;
  final String celular;

  User({
    this.id = -1,  
    required this.name,
    required this.apellido,
    required this.usuario,
    required this.email,
    required this.password,
    required this.celular,
  });

  // Convertir el objeto en un mapa para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'apellido': apellido,
      'usuario': usuario,
      'email': email,
      'contraseña': password,
      'celular': celular,
    };
  }

  // Crear un usuario desde un mapa de datos (por ejemplo, desde la respuesta del servidor)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Usuario_ID'] ?? -1,  
      name: json['Nombre'],
      apellido: json['Apellido'],
      usuario: json['Usuario'],
      email: json['Email'],
      password: json['Contraseña'],
      celular: json['Celular'],
    );
  }
}
