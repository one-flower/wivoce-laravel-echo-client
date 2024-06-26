import 'package:wivoce_laravel_echo_client/src/channel/private_channel.dart';
import 'package:wivoce_laravel_echo_client/src/channel/pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateChannel extends PusherChannel implements PrivateChannel {
  PusherPrivateChannel(
    dynamic pusher,
    String name,
    dynamic options,
  ) : super(pusher, name, options);

  /// Trigger client event on the channel.
  @override
  PusherPrivateChannel whisper(String eventName, dynamic data) {
    pusher.channels[name].trigger('client-$eventName', data);

    return this;
  }
}
