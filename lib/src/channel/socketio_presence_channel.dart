import 'package:wivoce_laravel_echo_client/src/channel/presence_channel.dart';
import 'package:wivoce_laravel_echo_client/src/channel/socketio_private_channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPresenceChannel extends SocketIoPrivateChannel
    implements PresenceChannel {
  SocketIoPresenceChannel(
    dynamic socket,
    String name,
    dynamic options,
  ) : super(socket, name, options);

  /// Register a callback to be called anytime the member list changes.
  @override
  SocketIoPresenceChannel here(Function callback) {
    on('presence:subscribed', (List<dynamic> members) {
      callback(members.map((member) => member['user_info']));
    });

    return this;
  }

  /// Listen for someone joining the channel.
  @override
  SocketIoPresenceChannel joining(Function callback) {
    on('presence:joining', (member) => callback(member['user_info']));

    return this;
  }

  /// Listen for someone leaving the channel.
  @override
  SocketIoPresenceChannel leaving(Function callback) {
    on('presence:leaving', (member) => callback(member['user_info']));

    return this;
  }

  /// 发送信息
  SocketIoPresenceChannel whisper(String eventName, dynamic data) {
    socket.emit('client event', {
      'channel': name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
