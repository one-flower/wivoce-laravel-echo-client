import 'package:wivoce_laravel_echo_client/src/channel/private_channel.dart';
import 'package:wivoce_laravel_echo_client/src/channel/socketio_channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateChannel extends SocketIoChannel implements PrivateChannel {
  SocketIoPrivateChannel(
    dynamic socket,
    String name,
    dynamic options,
  ) : super(socket, name, options);

  /// Trigger client event on the channel.
  @override
  SocketIoPrivateChannel whisper(String eventName, dynamic data) {
    socket.emit('client event', {
      'channel': name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
