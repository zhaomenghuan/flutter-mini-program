class EventEmitter {
  Map<String, List<Function>> events;

  EventEmitter() {
    events = new Map<String, List<Function>>();
  }

  // Return the number of events that have been subscribed to.
  int get eventCount {
    return events.keys.length;
  }

  /// Return the total number of subscriptions.
  int get subscriptionCount {
    var count = 0;
    events.keys.forEach((String key) {
      count = count + events[key].length;
    });
    return count;
  }

  /// Subscribe a target to an event.
  void on(String type, Function listener) {
    List subscribers = new List();
    if (events.containsKey(type)) {
      subscribers = events[type];
    } else {
      subscribers = new List<Function>();
      events[type] = subscribers;
    }
    subscribers.add(listener);
  }

  void once(String type, Function listener) {
    bool fired = false;

    Function onceWrapper([List arguments]) {
      if (!fired) {
        fired = true;
        (arguments == null) ? listener() : listener(arguments);
      }
    }

    this.on(type, onceWrapper);
  }

  /// Unsubscribe a target to an event.
  bool off(String type, Function listener) {
    if (!events.containsKey(type)) {
      return false;
    }
    List subscribers = events[type];
    for (var i = 0; i < subscribers.length; i++) {
      Function target = subscribers[i];
      if (identical(target, listener)) {
        subscribers.remove(target);
        return true;
      }
    }

    return false;
  }

  /// Post the event [String] and data provider [Function] to the subscriptions.
  void emit(String type, [List arguments]) {
    if (events.containsKey(type)) {
      var subscribers = events[type];
      if (subscribers.length > 0) {
        subscribers.forEach((Function target) {
          (arguments == null) ? target() : target(arguments);
        });
      }
    }
  }
}
