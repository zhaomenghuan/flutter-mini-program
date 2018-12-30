class EventEmitter {
  final _subscriptions = new Map<String, List<Function>>();

  // Return the number of events that have been subscribed to.
  int get eventCount {
    return _subscriptions.keys.length;
  }

  /// Return the total number of subscriptions.
  int get subscriptionCount {
    var count = 0;
    _subscriptions.keys.forEach((String key) {
      count = count + _subscriptions[key].length;
    });
    return count;
  }

  /// Subscribe a target to an event.
  void on(String event, Function target) {
    var subscribers;
    if (_subscriptions.containsKey(event)) {
      subscribers = _subscriptions[event];
    } else {
      subscribers = new List<Function>();
      _subscriptions[event] = subscribers;
    }
    subscribers.add(target);
  }

  /// Post the event [String] and data provider [Function] to the subscriptions.
  void emit(String event, [Function dataProvider = null]) {
    if (_subscriptions.containsKey(event)) {
      var subscribers = _subscriptions[event];

      subscribers.forEach((Function target) {
        dataProvider == null ? target() : target(dataProvider);
      });
    }
  }

  /// Display a simple report of subscriptions to STDOUT.
  void report() {
    print(
        "Active $subscriptionCount subscription(s) for $eventCount event(s).");
    _subscriptions.keys.forEach((String key) {
      var subscribers = _subscriptions[key];
      subscribers.forEach((Function target) {
        print("\t ['$key'] - $target");
      });
    });
    print('\n');
  }
}
