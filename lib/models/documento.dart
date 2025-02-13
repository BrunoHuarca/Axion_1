class Documento {
  final int id;
  final String titulo;
  final String descripcion;
  final String url;
  final String tipo;
  final String fechaSubida;

  Documento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.url,
    required this.tipo,
    required this.fechaSubida,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['Documento_ID'],
      titulo: json['Titulo'],
      descripcion: json['Descripcion'],
      url: json['Documento_Url'],
      tipo: json['Tipo'],
      fechaSubida: json['Fecha_Subida'],
    );
  }
}
