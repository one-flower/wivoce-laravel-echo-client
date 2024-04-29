library wivoce_laravel_echo_client;

import 'package:wivoce_laravel_echo_client/src/channel/channel.dart';
import 'package:wivoce_laravel_echo_client/src/channel/presence_channel.dart';
import 'package:wivoce_laravel_echo_client/src/channel/private_channel.dart';
import 'package:wivoce_laravel_echo_client/src/connector/pusher_connector.dart';
import 'package:wivoce_laravel_echo_client/src/connector/socketio_connector.dart';

export 'package:wivoce_laravel_echo_client/src/channel/presence_channel.dart';
export 'package:wivoce_laravel_echo_client/src/channel/private_channel.dart';

// ignore_for_file: constant_identifier_names
enum EchoBroadcasterType {
  SocketIO,
  Pusher,
}

class Echo {
  /// The broadcasting connector.
  dynamic connector;

  /// The Echo options.
  late Map<String, dynamic> options;

  // The broadcaster type.
  late EchoBroadcasterType broadcaster;

  /// Create a new class instance.
  Echo({
    EchoBroadcasterType broadcaster = EchoBroadcasterType.Pusher,
    required dynamic client,
    Map<String, dynamic>? options,
  }) {
    this.broadcaster = broadcaster;
    this.options = options ?? {};
    this.options['client'] = client;
    connect();
  }

  /// Get a channel instance by name.
  Channel channel(String channel) {
    return connector.channel(channel);
  }

  /// Create a new connection.
  void connect() {
    if (broadcaster == EchoBroadcasterType.Pusher) {
      connector = PusherConnector(options);
    } else if (broadcaster == EchoBroadcasterType.SocketIO) {
      connector = SocketIoConnector(options);
    }
  }

  /// Disconnect from the Echo server.
  void disconnect() {
    connector.disconnect();
  }

  /// Get a presence channel instance by name.
  PresenceChannel join(String channel) {
    return connector.presenceChannel(channel);
  }

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel) {
    connector.leave(channel);
  }

  /// Leave the given channel.
  void leaveChannel(String channel) {
    connector.leaveChannel(channel);
  }

  /// Listen for an event on a channel instance.
  Channel listen(String channel, String event, Function callback) {
    return connector.listen(channel, event, callback);
  }

  /// Get a private channel instance by name.
  PrivateChannel private(String channel) {
    return connector.privateChannel(channel);
  }

  /// Get a private encrypted channel instance by name.
  Channel encryptedPrivate(String channel) {
    return connector.encryptedPrivateChannel(channel);
  }

  /// Get the Socket ID for the connection.
  String? socketId() {
    return connector.socketId();
  }
}
