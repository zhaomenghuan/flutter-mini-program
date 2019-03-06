package cn.com.agree.flutter.miniprogram.handler;

import android.support.annotation.Nullable;

import org.liquidplayer.javascript.JSContext;
import org.liquidplayer.javascript.JSException;
import org.liquidplayer.javascript.JSFunction;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import cn.com.agree.flutter.miniprogram.BuildConfig;
import cn.com.agree.flutter.miniprogram.MiniProgramPlugin;
import cn.com.agree.flutter.miniprogram.components.WrappedJSContext;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * WIP: Need to implement properly.
 * It currently allows you to evaluate javascript and get properties back.
 * As well as provide basic functionality for returning references to callback objects.
 */
public class JsContextHandler implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private final Object lockFile = new Object();
    private final Map<String, WrappedJSContext> instances = Collections.synchronizedMap(new HashMap<String, WrappedJSContext>());

    private MethodChannel jsContextChannel;
    private EventChannel.EventSink eventSink;

    public static void registerWith(Registrar registrar) {
        new JsContextHandler(registrar);
    }

    private JsContextHandler(Registrar registrar) {
        jsContextChannel = new MethodChannel(registrar.messenger(), MiniProgramPlugin.NAMESPACE + "/jscontext");
        jsContextChannel.setMethodCallHandler(this);

        EventChannel contextException = new EventChannel(registrar.messenger(), MiniProgramPlugin.NAMESPACE + "/jscontextException");
        contextException.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        try {
            handleMethodCall(methodCall, result);
        } catch (Exception e) {
            if (BuildConfig.DEBUG) {
                // Only print error stack trace in debug mode.
                e.printStackTrace();
            }
            result.error("exception", e.toString(), MiniProgramPlugin.convertToDartObject(e));
        }
    }

    private void handleMethodCall(MethodCall call, final MethodChannel.Result result) {
        final String contextId = call.argument("contextId");
        if (contextId == null) {
            result.error("error", "Context ID not specified", null);
            return;
        }

        final WrappedJSContext wrappedJsContext = getOrCreateInstance(contextId);
        final JSContext jsContext = wrappedJsContext.getJSContext();

        if ("evaluateScript".equals(call.method)) {
            String script = call.argument("script");
            String sourceURL = call.argument("sourceURL");
            Integer startingLineNumber = call.argument("startingLineNumber");
            if (startingLineNumber == null) {
                startingLineNumber = 0;
            }
            if (script == null) {
                result.error("error", "Please specify a script!", null);
                return;
            }
            result.success(MiniProgramPlugin.convertToDartObject(jsContext.evaluateScript(script, sourceURL, startingLineNumber)));
        } else if ("setExceptionHandler".equals(call.method)) {
            jsContext.setExceptionHandler(new JSContext.IJSExceptionHandler() {
                @Override
                public void handle(JSException exception) {
                    if (eventSink != null) {
                        eventSink.success(buildArguments(contextId, exception));
                    }
                }
            });
            result.success(null);
        } else if ("clearExceptionHandler".equals(call.method)) {
            jsContext.clearExceptionHandler();
            result.success(null);
        } else if ("property".equals(call.method)) {
            String prop = call.argument("prop");
            result.success(MiniProgramPlugin.convertToDartObject(jsContext.property(prop)));
        } else if ("setProperty".equals(call.method)) {
            String prop = call.argument("prop");
            Object value = call.argument("value");
            Integer attr = call.argument("attr");
            String type = call.argument("type");

            if ("function".equals(type)) {
                // Returns a promise.
                final String functionId = (String) value;
                final JSFunction dartCb = new JSFunction(jsContext, "dartCb") {
                    @SuppressWarnings("unused")
                    public void dartCb(final JSFunction resolve, final JSFunction error, Object... args) {
                        Map<String, Object> arguments = buildArguments(contextId, MiniProgramPlugin.convertToDartObjects(args));
                        arguments.put("functionId", functionId);
                        jsContextChannel.invokeMethod("dynamicFunction", arguments, new MethodChannel.Result() {
                            @Override
                            public void success(@Nullable Object returnValue) {
                                resolve.call(resolve, returnValue);
                            }

                            @Override
                            public void error(String type, @Nullable String errorMessage, @Nullable Object o) {
                                error.call(error, type, errorMessage);
                            }

                            @Override
                            public void notImplemented() {
                                error.call(error, "dynamicFunction not implemented!");
                            }
                        });
                    }
                };

                final String code = "(function (dartCb) {\n" +
                        "  return function () {\n" +
                        "    let args = arguments;\n" +
                        "    return new Promise((resolve, error) => {\n" +
                        "      return dartCb.call(dartCb, resolve, error, ...args);\n" +
                        "    })\n" +
                        "  };\n" +
                        "})";

                JSFunction anon = jsContext.evaluateScript(code).toFunction();
                value = anon.call(anon, dartCb).toFunction(); // Return the promise.
                // Store a reference to the dart function's uuid.
                ((JSFunction) value).property("__dart_liquidcore_function_id__", functionId);
            }

            attr = attr == null ? 0 : attr;
            jsContext.property(prop, value, attr);
            result.success(null);
        } else if ("hasProperty".equals(call.method)) {
            String prop = call.argument("prop");
            result.success(jsContext.hasProperty(prop));
        } else if ("deleteProperty".equals(call.method)) {
            String prop = call.argument("prop");
            result.success(jsContext.deleteProperty(prop));
        } else if ("cleanUp".equals(call.method)) {
            // Remove all references to the jsContext.
            synchronized (lockFile) {
                instances.remove(contextId);
                wrappedJsContext.freeUp();
            }
        }
    }

    private WrappedJSContext getExistingInstance(String key) {
        synchronized (lockFile) {
            if (!instances.containsKey(key)) {
                return null;
            }
            return instances.get(key);
        }
    }

    private WrappedJSContext getOrCreateInstance(String key) {
        synchronized (lockFile) {
            WrappedJSContext instance = getExistingInstance(key);
            if (instance == null) {
                instance = new WrappedJSContext();
                instances.put(key, instance);
            }
            return instance;
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
    }

    private static Map<String, Object> buildArguments(String contextId, Object value) {
        Map<String, Object> result = new HashMap<>();
        result.put("contextId", contextId);
        result.put("value", value);
        return result;
    }
}
