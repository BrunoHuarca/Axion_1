import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:axion_app/widgets/loading_widget.dart';

class DocumentoWebView extends StatefulWidget {
  final String url;

  DocumentoWebView({required this.url});

  @override
  _DocumentoWebViewState createState() => _DocumentoWebViewState();
}

class _DocumentoWebViewState extends State<DocumentoWebView> {
  TextEditingController searchController = TextEditingController();
  String? localFilePath;
  bool isLoading = true;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _blockScreenshots();
    _downloadPdf();
  }

  /// Bloquear capturas de pantalla
  void _blockScreenshots() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Oculta UI del sistema
  }

  /// Restaurar configuración normal al salir
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  /// Descargar PDF desde la URL
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
          isLoading = false;
        });
      } else {
        throw Exception('Error al descargar el archivo PDF');
      }
    } catch (e) {
      print("Error al descargar el PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visor de Documento PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _pdfViewerController.searchText(searchController.text);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: LoadingWidget(animationPath: 'assets/icons/mano.json'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Buscar en el PDF",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _pdfViewerController.searchText(searchController.text);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SfPdfViewer.file(
                    File(localFilePath!),
                    controller: _pdfViewerController,
                  ),
                ),
              ],
            ),
    );
  }
}
