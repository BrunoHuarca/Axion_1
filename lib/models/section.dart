class Section {
  final int id;
  final String nombre;
  final String descripcion;

  // Constructor
  Section({required this.id, required this.nombre, required this.descripcion});

  // Factory constructor para convertir JSON a objeto Section
  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['Seccion_ID'],  // Asegúrate de que este nombre sea correcto según tu API
      nombre: json['Nombre'],   // Asegúrate de que este nombre sea correcto según tu API
      descripcion: json['Descripcion'],  // Asegúrate de que este nombre sea correcto según tu API
    );
  }
}
