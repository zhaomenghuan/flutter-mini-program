package cn.com.agree.flutter.miniprogram;

import org.json.JSONException;
import org.json.JSONTokener;
import org.liquidplayer.javascript.JSException;
import org.liquidplayer.javascript.JSValue;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.agree.flutter.miniprogram.handler.JsContextHandler;
import cn.com.agree.flutter.miniprogram.handler.MicroServiceHandler;
import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * LiquidcorePlugin
 */
public class MiniProgramPlugin {
    public final static String NAMESPACE = "io.jojodev.flutter.liquidcore";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        JsContextHandler.registerWith(registrar);
        MicroServiceHandler.registerWith(registrar);
    }

    /**
     * Convert arguments to dart objects.
     *
     * @param args Object[]
     * @return Serializable arguments.
     * @see io.flutter.plugin.common.StandardMessageCodec#writeValue
     */
    @SuppressWarnings("JavadocReference")
    public static List<Object> convertToDartObjects(Object... args) {
        List<Object> allowedArgs = new ArrayList<>(args.length);
        for (Object value : args) {
            allowedArgs.add(convertToDartObject(value));
        }

        return allowedArgs;
    }

    /**
     * Convert objects into a format that can be easily digested by Dart.
     *
     * @param value the object to transform.
     * @return the transformed object.
     */
    public static Object convertToDartObject(Object value) {
        if (value == null || value == Boolean.TRUE || value == Boolean.FALSE ||
                value instanceof Number || value instanceof String || value instanceof byte[] || value instanceof int[]
                || value instanceof long[] || value instanceof double[] || value instanceof List || value instanceof Map) {
            return value;
        } else {
            if (value instanceof JSValue) {
                JSValue jsValue = (JSValue) value;
                if (jsValue.isUndefined() || jsValue.isNull()) {
                    value = null;
                } else if (jsValue.isNumber()) {
                    value = jsValue.toNumber();
                } else if (jsValue.isBoolean()) {
                    value = jsValue.toBoolean();
                } else if (jsValue.isString()) {
                    value = jsValue.toString();
                } else {
                    if (jsValue.isObject() && jsValue.toObject().isFunction()) {
                        // This really only works if it's returning a function that was originally
                        // passed in from Dart.
                        Map<String, Object> map = new HashMap<>();
                        map.put("__dart_liquidcore_type__", "function");
                        map.put("__dart_liquidcore_ref__", jsValue.toObject().property("__dart_liquidcore_function_id__").toString());
                        value = map;
                    } else {
                        // Convert to JSON object for serialization/deserialization.
                        JSONTokener tokener = new JSONTokener(jsValue.toJSON());
                        try {
                            value = JSONUtil.unwrap(tokener.nextValue());
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

                return value;
            } else if (value instanceof Exception) {
                Map<String, Object> map = new HashMap<>();
                map.put("__dart_liquidcore_type__", "exception");
                map.put("type", value.getClass().getSimpleName());
                map.put("message", value.toString());
                if (value instanceof JSException) {
                    map.put("stack", ((JSException) value).stack());
                } else {
                    StringBuilder stack = new StringBuilder();
                    for (StackTraceElement st : ((Exception) value).getStackTrace()) {
                        stack.append(st.toString()).append("\n");
                    }
                    map.put("stack", stack.toString());
                }
                return map;
            } else {
                return value.toString();
            }
        }
    }
}
