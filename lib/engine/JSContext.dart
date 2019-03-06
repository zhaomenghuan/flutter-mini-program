import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

const NAMESPACE = "io.jojodev.flutter.liquidcore";

/// This enables more verbose logging, if desired.
bool enableLiquidCoreLogging = false;

void liquidcoreLog(String message) {
  if (enableLiquidCoreLogging) {
    print(message);
  }
}

typedef void ExceptionHandler(String error);

class JSException implements Exception {
  final String message;
  final String exceptionType;
  final String stackTraceString;

  JSException(this.message, this.exceptionType, this.stackTraceString);

  @override
  String toString() =>
      'JSException($message, $exceptionType)\n[\n$stackTraceString]';
}

/// Extremely basic interface for a native Javascript context.
/// Currently only supported on Android devices.
class JSContext {
  /// Specifies that a property has no special attributes.
  static const JSPropertyAttributeNone = 0;

  /// Specifies that a property is read-only.
  static const JSPropertyAttributeReadOnly = 1 << 1;

  /// Specifies that a property should not be enumerated by
  /// JSPropertyEnumerators and JavaScript for...in loops.
  static const JSPropertyAttributeDontEnum = 1 << 2;

  /// Specifies that the delete operation should fail on a property.
  static const JSPropertyAttributeDontDelete = 1 << 3;

  static final MethodChannel _methodChannel =
  const MethodChannel('$NAMESPACE/jscontext')
    ..setMethodCallHandler(_platformCallHandler);

  static final _uuid = new Uuid();
  static final _instances = new Map<String, JSContext>();

  final EventChannel _jsContextExceptionChannel =
  const EventChannel("$NAMESPACE/jscontextException");

  StreamSubscription _jsContextExceptionSubscription;

  ExceptionHandler _exceptionHandler;

  String _instanceId;
  var _jsFunctions = new Map<String, Function>();

  JSContext() {
    _instanceId = _uuid.v4();
    _instances[_instanceId] = this;
  }

  /// Set a property.
  ///
  /// [prop] The name of the property to set.
  ///
  /// [value] The object to set it to. If this is a function, due to limitations in Flutter's
  /// communication mechanism, it'll be converted to a promise on the Javascript side.
  ///
  /// [attributes] And OR'd list of JSProperty constants.
  Future<dynamic> setProperty(String prop, dynamic value, [int attributes]) {
    var arguments = {
      'prop': prop,
      'value': value,
      'attr': attributes,
    };
    if (value is Function) {
      var functionId = _uuid.v4();
      _jsFunctions[functionId] = value;
      value = functionId;
      arguments['type'] = 'function';
      arguments['value'] = functionId;
    }
    return _invokeMethod("setProperty", arguments);
  }

  /// Return a property.
  Future<dynamic> property(String prop) {
    var arguments = {
      'prop': prop,
    };

    return _invokeMethod("property", arguments).then((value) {
      return _transformValue(value);
    });
  }

  /// Whether the current context contains a property [prop].
  Future<bool> hasProperty(String prop) {
    return _invokeMethod("hasProperty", {
      'prop': prop,
    });
  }

  /// Returns true if the property was deleted.
  Future<bool> deleteProperty(String prop) {
    return _invokeMethod("deleteProperty", {
      'prop': prop,
    });
  }

  /// Free up the context resources.
  Future<bool> cleanUp() {
    return _invokeMethod("cleanUp");
  }

  /// Executes the JavaScript code in [script] in this context
  ///
  /// [script]  The code to execute
  /// [sourceURL]  The URI of the source file, only used for reporting in stack trace (optional)
  /// [startingLineNumber]  The beginning line number, only used for reporting in stack trace (optional)
  Future<dynamic> evaluateScript(String script,
      [String sourceURL, int startingLineNumber = 0]) {
    return _invokeMethod("evaluateScript", {
      'script': script,
      'sourceURL': sourceURL,
      'startingLineNumber': startingLineNumber,
    });
  }

  /// Sets the JS exception handler for this context.  Any thrown JSException in this
  /// context will be sent to this handler.
  Future<void> setExceptionHandler(ExceptionHandler exceptionHandler) {
    this._exceptionHandler = exceptionHandler;

    if (_jsContextExceptionSubscription == null) {
      // Listen to the exception event stream.
      _jsContextExceptionSubscription =
          _jsContextExceptionChannel.receiveBroadcastStream().listen((error) {
            if (_exceptionHandler != null) {
              _exceptionHandler(error);
            }
          });
    }

    return _invokeMethod("setExceptionHandler", {});
  }

  /// Clears a previously set exception handler.
  Future<void> clearExceptionHandler() {
    this._exceptionHandler = null;
    if (_jsContextExceptionSubscription != null) {
      _jsContextExceptionSubscription.cancel();
      _jsContextExceptionSubscription = null;
    }

    return _invokeMethod("clearExceptionHandler", {});
  }

  /// Send a message over to the native implementation.
  Future<dynamic> _invokeMethod(String method,
      [Map<String, dynamic> arguments = const {}]) {
    Map<String, dynamic> withInstanceId = Map.of(arguments);
    withInstanceId['contextId'] = _instanceId;
    return _methodChannel.invokeMethod(method, withInstanceId);
  }

  /// Converts a value returned from the native platform into a suitable
  /// dart object.
  dynamic _transformValue(value) {
    if (value is Map) {
      // Return the function reference callback.
      if (value['__dart_liquidcore_type__'] == 'function') {
        return _jsFunctions[value['__dart_liquidcore_ref__']];
      } else if (value['__dart_liquidcore_type__'] == 'exception') {
        return JSException(value['message'], value['type'], value['stack']);
      }
    }

    return value;
  }

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    liquidcoreLog('_platformCallHandler call ${call.method} ${call.arguments}');
    var arguments = (call.arguments as Map);
    String contextId = arguments['contextId'];
    JSContext instance = _instances[contextId];
    if (instance == null) {
      liquidcoreLog("jsContext $contextId was not found!");
      return null;
    }
    dynamic value = arguments['value'];
    switch (call.method) {
      case 'dynamicFunction':
        var functionId = arguments['functionId'];
        List args = value;
        var func = instance._jsFunctions[functionId];
        if (func != null) {
          var decodedArgs =
          args.map((arg) => instance._transformValue(arg)).toList();
          return Function.apply(func, decodedArgs);
        }
        break;
    }
  }
}