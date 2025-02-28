import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  void connect() {
    _socket = IO.io('https://api.axioneduca.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // No conectar automáticamente
      'path': '/socket.io/',
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('🔌 Conectado al servidor de WebSocket');
    });

    _socket!.onDisconnect((_) {
      print('❌ Desconectado del servidor de WebSocket');
    });

    _socket!.onError((data) {
      print('⚠️ Error en WebSocket: $data');
    });
  }

  void joinGroup(int grupoId) {
    _socket!.emit('joinGroup', {'Grupo_ID': grupoId});
    print('📌 Unido al grupo $grupoId');
  }

  void leaveGroup(int grupoId) {
    _socket!.emit('leaveGroup', {'Grupo_ID': grupoId});
    print('🚪 Salido del grupo $grupoId');
  }

  void sendMessage(int usuarioId, String contenido, int grupoId) {
    _socket!.emit('sendMessage', {
      'Usuario_ID': usuarioId,
      'Contenido': contenido,
      'Grupo_ID': grupoId,
    });
  }

  void listenForMessages(Function(dynamic) callback) {
    _socket!.on('receiveMessage', (data) {
      callback(data);
    });
  }

  void disconnect() {
    _socket!.disconnect();
  }
}
