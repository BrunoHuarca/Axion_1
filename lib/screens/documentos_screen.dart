import 'package:flutter/material.dart';
import 'package:axion_app/models/documento.dart';
import 'package:axion_app/services/api_service.dart';
import 'package:axion_app/screens/documento_webview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:axion_app/widgets/loading_widget.dart';

class DocumentosScreen extends StatefulWidget {
  final int seccionId;
  final String seccionNombre;

  DocumentosScreen({required this.seccionId, required this.seccionNombre});

  @override
  _DocumentosScreenState createState() => _DocumentosScreenState();
}

class _DocumentosScreenState extends State<DocumentosScreen> {
  late bool _isDarkMode;
  bool isGridView = false;
  List<Documento> documentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocumentos();
    _getDarkModePreference().then((value) {
    setState(() {
      _isDarkMode = value;
    });
  });
  }

Future<bool> _getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dark_mode') ?? false;
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
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          color: _isDarkMode ? Colors.black : Colors.white,
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black, size: 26),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              widget.seccionNombre,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
            ),
            backgroundColor: _isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: _isDarkMode ? Colors.black : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DOCUMENTOS (${documentos.length.toString().padLeft(2, '0')})",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.view_list, color: isGridView ? Colors.grey : Colors.blue),
                      onPressed: () => setState(() => isGridView = false),
                    ),
                    IconButton(
                      icon: Icon(Icons.grid_view, color: isGridView ? Colors.blue : Colors.grey),
                      onPressed: () => setState(() => isGridView = true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: LoadingWidget(animationPath: 'assets/icons/mano.json'))
                : documentos.isEmpty
                    ? Center(child: Text('No se encontraron documentos.'))
                    : isGridView
                        ? _buildGridView(documentos)
                        : _buildListView(documentos),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Documento> documentos) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      itemCount: documentos.length,
      itemBuilder: (context, index) {
        return _buildListItem(context, documentos[index]);
      },
    );
  }

  Widget _buildGridView(List<Documento> documentos) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: documentos.length,
      itemBuilder: (context, index) {
        return _buildGridItem(context, documentos[index]);
      },
    );
  }

  Widget _buildListItem(BuildContext context, Documento documento) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DocumentoWebView(url: documento.url)),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: _isDarkMode ? Colors.grey[900] : Color(0xFFE0F2FE),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  color: _isDarkMode ? const Color.fromARGB(255, 54, 54, 54) : Color(0xFFA1BEF5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.insert_drive_file, color: _isDarkMode ? Colors.white : Color(0xFF123AA0), size: 30),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        documento.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        documento.descripcion ?? "Sin descripción",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.arrow_forward_ios, color: _isDarkMode ? Colors.white : Color(0xFF000012), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildGridItem(BuildContext context, Documento documento) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocumentoWebView(url: documento.url)),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: _isDarkMode ? Colors.grey[900] : Color(0xFFE0F2FE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color.fromARGB(255, 54, 54, 54) : Color(0xFFA1BEF5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Center(
              child: Icon(Icons.insert_drive_file, color: _isDarkMode ? Colors.white : Color(0xFF123AA0), size: 90),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documento.titulo,
                    maxLines: 2, // Máximo 2 líneas antes de truncar
                    overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es largo
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    documento.descripcion ?? "Sin descripción",
                    maxLines: 2, // Máximo 2 líneas antes de truncar
                    overflow: TextOverflow.ellipsis, // Muestra "..." si se excede
                    textAlign: TextAlign.left,
                    style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
