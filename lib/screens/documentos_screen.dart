import 'package:flutter/material.dart';
import 'package:axion_app/models/documento.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/screens/documento_webview.dart';

class DocumentosScreen extends StatefulWidget {
  final int seccionId;

  DocumentosScreen({required this.seccionId});

  @override
  _DocumentosScreenState createState() => _DocumentosScreenState();
}

class _DocumentosScreenState extends State<DocumentosScreen> {
  List<Documento> documentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.seccionId > 0) {
      _fetchDocumentos();
    }
  }

  Future<void> _fetchDocumentos() async {
    try {
      List<Documento> fetchedDocumentos =
          await ApiService().getDocumentosPorSeccion(widget.seccionId);
      setState(() {
        documentos = fetchedDocumentos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Encabezado
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF00001B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      './assets/images/axionlogo2.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    'Documentos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Lista de documentos
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : documentos.isEmpty
                    ? Center(child: Text('No se encontraron documentos.'))
                    : ListView.builder(
                        itemCount: documentos.length,
                        itemBuilder: (context, index) {
                          final documento = documentos[index];
                          return Card(
                            color: Color(0xFF0083F7),
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                documento.titulo,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Text(documento.descripcion, style: TextStyle(color: Colors.white70)),
                              trailing: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentoWebView(url: documento.url),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
