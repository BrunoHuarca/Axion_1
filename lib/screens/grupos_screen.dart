import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_screen.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  List grupos = [];

  @override
  void initState() {
    super.initState();
    fetchGrupos();
  }

  Future<void> fetchGrupos() async {
    final response = await http.get(Uri.parse('https://api.axioneduca.com/apii/grupos'));

    if (response.statusCode == 200) {
      setState(() {
        grupos = json.decode(response.body);
      });
    } else {
      print('Error al obtener grupos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grupos')),
      body: grupos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                return ListTile(
                  title: Text(grupo['Nombre']),
                  subtitle: Text(grupo['Descripcion']),
                  trailing: Icon(Icons.chat),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(grupoId: grupo['Grupo_ID'], grupoNombre: grupo['Nombre']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
