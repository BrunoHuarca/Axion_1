import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final int grupoId;
  final String grupoNombre;

  ChatScreen({required this.grupoId, required this.grupoNombre});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List mensajes = [];
  IO.Socket? socket;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMensajes();
    conectarSocket();
  }

  /// 🔹 Obtener mensajes anteriores del grupo
  Future<void> fetchMensajes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.axioneduca.com/apii/chat/history?grupo_id=${widget.grupoId}'));

      if (response.statusCode == 200) {
        setState(() {
          mensajes = json.decode(response.body);
        });
      } else {
        print('❌ Error al obtener mensajes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en fetchMensajes: $e');
    }
  }

  /// 🔹 Conectar WebSocket
void conectarSocket() {
  if (socket != null && socket!.connected) {
    return; // Evita múltiples conexiones innecesarias
  }

  socket = IO.io('wss://api.axioneduca.com', <String, dynamic>{ // ❌ Removí el doble "https://"
    'transports': ['websocket'],
    'autoConnect': false,
    'reconnect': true,
    'reconnectionAttempts': 5, // Intentos de reconexión
    'reconnectionDelay': 2000, // Tiempo de espera entre intentos
  });

  socket!.connect();

  socket!.onConnect((_) {
    print('✅ Conectado a WebSocket');
    socket!.emit('joinGroup', {'Grupo_ID': widget.grupoId});
  });

  socket!.onDisconnect((_) => print('❌ Desconectado de WebSocket, intentando reconectar...'));
  socket!.onError((data) => print('⚠️ Error en WebSocket: $data'));

  // ✅ Siempre escucha mensajes nuevos
  socket!.on('receiveMessage', (data) async {
    print('📩 Nuevo mensaje recibido: $data');

    if (!mounted) {
      print('⚠️ Componente desmontado, ignorando mensaje');
      return;
    }

    if (data != null && data is Map<String, dynamic>) {
      setState(() {
        mensajes.insert(0, {
          'Mensaje_ID': data['Mensaje_ID'] ?? 0,
          'Usuario_ID': data['Usuario_ID'] ?? 0,
          'usuario_nombre': data['usuario_nombre'] ?? 'Desconocido',
          'Contenido': data['Contenido'] ?? '',
          'Grupo_ID': data['Grupo_ID'] ?? 0,
          'Fecha_Enviado': data['Fecha_Enviado'] ?? DateTime.now().toString(),
        });
      });

      // 🔄 También refresca desde la API para asegurar sincronización total
      await fetchMensajes();
    }
  });
}


  /// 🔹 Enviar mensaje al grupo
  void enviarMensaje() {
    if (_controller.text.isEmpty) return;

    socket!.emit('sendMessage', {
      'Usuario_ID': 5, // ⚠️ REEMPLAZA CON EL ID DEL USUARIO LOGUEADO
      'Contenido': _controller.text,
      'Grupo_ID': widget.grupoId,
    });

    _controller.clear();
  }


  @override
  void dispose() {
    if (socket != null) {
      socket!.emit('leaveGroup', {'Grupo_ID': widget.grupoId});
      socket!.off('receiveMessage'); // Desconectar listener
      socket!.disconnect();
    }
    _controller.dispose(); // Liberar memoria del controlador de texto
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.grupoNombre)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // 🔹 Muestra el mensaje más reciente arriba
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = mensajes[index];
                return ListTile(
                  title: Text(mensaje['usuario_nombre']),
                  subtitle: Text(mensaje['Contenido']),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
