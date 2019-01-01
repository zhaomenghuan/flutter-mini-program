import 'package:flutter_mini_program/EventEmitter.dart';

void main() {
  EventEmitter emitter = new EventEmitter();
  emitter.on("onCustomEvent", (data) {
    print(data[0] + ":" + data[1]);
  });
  emitter.emit("onCustomEvent", ["message", "on execute"]);
  emitter.emit("onCustomEvent", ["message", "on execute again"]);

  emitter.once("onceCustomEvent", (data) {
    print(data[0] + ": " + data[1]);
  });
  emitter.emit("onceCustomEvent", ["message", "once execute"]);
  emitter.emit("onceCustomEvent", ["message", "once execute again"]);

  var callback = () {
    print("off execute");
  };
  emitter.on("customEvent", callback);
  emitter.emit("customEvent");
  emitter.off("customEvent", callback);
  emitter.emit("customEvent");
}
