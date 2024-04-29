import 'dart:async';

import 'package:wivoce_laravel_echo_client/src/channel/channel.dart';
import 'package:wivoce_laravel_echo_client/src/util/event_formatter.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  dynamic pusher;

  /// The name of the channel.
  late String name;

  /// Channel options.
  late Map<String, dynamic> options;

  /// The event formatter.
  late EventFormatter eventFormatter;

  /// The subcription of the channel.
  dynamic subcription;

  /// Create a new class instance.
  PusherChannel(dynamic pusher, String name, Map<String, dynamic> options) {
    name = name;
    pusher = pusher;
    options = options;
    // ignore: unnecessary_new
    eventFormatter = new EventFormatter(this.options['namespace']);

    subscribe();
  }

  /// Subscribe to a Pusher channel.
  void subscribe() {
    subcription = pusher.subscribe(name);
  }

  /// Unsubscribe from a channel.
  @override
  void unsubscribe() {
    pusher.unsubscribe(name);
  }

  /// Listen for an event on the channel instance.
  @override
  PusherChannel listen(String event, Function callback) {
    on(eventFormatter.format(event), callback);

    return this;
  }

  /// Listen for all events on the channel instance.
  PusherChannel listenToAll(Function callback) {
    subcription.bind_global((String event, dynamic data) {
      if (event.startsWith('pusher:')) {
        return;
      }

      String namespace = options['namespace'].replaceAll(RegExp(r'\.'), '\\');

      String formattedEvent = event.startsWith(namespace)
          ? event.substring(namespace.length + 1)
          : '.$event';

      callback(formattedEvent, data);
    });

    return this;
  }

  /// Stop listening for an event on the channel instance.
  @override
  PusherChannel stopListening(String event, [Function? callback]) {
    if (callback != null) {
      subcription.unbind(eventFormatter.format(event), callback);
    } else {
      subcription.unbind(eventFormatter.format(event));
    }

    return this;
  }

  /// Stop listening for all events on the channel instance.
  PusherChannel stopListeningAll([Function? callback]) {
    if (callback != null) {
      subcription.unbind_global(callback);
    } else {
      subcription.unbind_global();
    }

    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  @override
  PusherChannel subscribed(Function callback) {
    on('pusher:subscription_succeeded', () => callback());

    return this;
  }

  ///  Register a callback to be called anytime a subscription error occurs.
  @override
  PusherChannel error(Function callback) {
    on('pusher:subscription_error', (status) => callback(status));

    return this;
  }

  /// Bind a channel to an event.
  PusherChannel on(String event, Function callback) {
    if (subcription is Future) {
      subcription.then((channel) => channel.bind(event, callback));
    } else {
      subcription.bind(event, callback);
    }

    return this;
  }
}
