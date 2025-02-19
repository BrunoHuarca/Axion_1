class User {
  final int id;
  final String name;
  final String apellido;
  final String usuario;
  final String email;
  final String password;
  final String celular;
  final String? imagenBase64; // 🔹 Nuevo campo opcional

  User({
    this.id = -1,
    this.name = '',
    this.apellido = '',
    required this.usuario,
    required this.email,
    this.password = '',
    required this.celular,
    this.imagenBase64, // 🔹 Ahora el usuario puede tener una imagen
  });

  User copyWith({
    int? id,
    String? name,
    String? apellido,
    String? usuario,
    String? email,
    String? password,
    String? celular,
    String? imagenBase64,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      apellido: apellido ?? this.apellido,
      usuario: usuario ?? this.usuario,
      email: email ?? this.email,
      password: password ?? this.password,
      celular: celular ?? this.celular,
      imagenBase64: imagenBase64 ?? this.imagenBase64, // 🔹 Mantiene la imagen
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'apellido': apellido,
      'usuario': usuario,
      'email': email,
      'contraseña': password,
      'celular': celular,
      'imagenBase64': imagenBase64, // 🔹 Guardamos la imagen en JSON
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Usuario_ID'] ?? -1,
      name: json['Nombre'] ?? '',
      apellido: json['Apellido'] ?? '',
      usuario: json['Usuario'] ?? '',
      email: json['Email'] ?? '',
      password: json['Contraseña'] ?? '',
      celular: json['Celular'] ?? '',
      imagenBase64: json['imagenBase64'], // 🔹 Cargamos la imagen si existe
    );
  }
}
