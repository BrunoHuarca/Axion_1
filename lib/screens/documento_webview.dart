import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart'; // Importar el paquete

class DocumentoWebView extends StatefulWidget {
  final String url;

  DocumentoWebView({required this.url});

  @override
  _DocumentoWebViewState createState() => _DocumentoWebViewState();
}

class _DocumentoWebViewState extends State<DocumentoWebView> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
    _disableScreenshot();  // Deshabilitar las capturas de pantalla al abrir esta pantalla
  }

  // Método para deshabilitar las capturas de pantalla
  Future<void> _disableScreenshot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  // Método para descargar el PDF desde la URL y almacenarlo localmente
  Future<void> _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final filePath = '${documentDirectory.path}/documento.pdf';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localFilePath = filePath;
        });
      } else {
        throw Exception('Error al descargar el archivo PDF');
      }
    } catch (e) {
      print("Error al descargar el PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visor de Documento PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _downloadPdf, // Recargar el PDF si es necesario
          ),
        ],
      ),
      body: localFilePath == null
          ? Center(child: CircularProgressIndicator()) // Espera a que el archivo se descargue
          : PDFView(
              filePath: localFilePath, // Pasa la ruta del archivo local
            ),
    );
  }

  @override
  void dispose() {
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE); // Limpiar los flags al cerrar la pantalla
    super.dispose();
  }
}
