package cn.com.agree.flutter.miniprogram.handler;

import android.content.Context;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.liquidplayer.service.MicroService;

import java.net.URI;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.agree.flutter.miniprogram.MiniProgramPlugin;
import cn.com.agree.flutter.miniprogram.components.WrappedMicroService;
import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class MicroServiceHandler implements MethodChannel.MethodCallHandler {
    private static MethodChannel microServiceMethodChannel;

    private final Map<String, WrappedMicroService> microServices = Collections.synchronizedMap(new HashMap<String, WrappedMicroService>());
    private final Object microServicesMapLocker = new Object();

    private final PluginRegistry.Registrar registrar;

    private MicroServiceHandler(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        microServiceMethodChannel = new MethodChannel(registrar.messenger(), MiniProgramPlugin.NAMESPACE + "/microservice");

        MicroServiceHandler instance = new MicroServiceHandler(registrar);
        microServiceMethodChannel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        try {
            handleMethodCall(call, result);
        } catch (Exception e) {
            result.error("exception", e.toString(), MiniProgramPlugin.convertToDartObject(e));
        }
    }

    private void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if ("devServer".equals(call.method)) {
            String filename = call.hasArgument("filename") ? (String) call.argument("filename") : null;
            Integer port = call.hasArgument("port") ? (Integer) call.argument("port") : null;
            result.success(MicroService.DevServer(filename, port).toString());
            return;
        } else if ("uninstall".equals(call.method)) {
            MicroService.uninstall(registrar.context(), URI.create((String) call.arguments));
            result.success(null);
            return;
        }

        final String serviceId = call.argument("serviceId");
        String uri = call.argument("uri");

        WrappedMicroService wrappedMicroService = getOrCreateService(serviceId, uri);

        MicroService service = wrappedMicroService.getMicroService();

        if ("start".equals(call.method)) {
            List<String> argv = call.argument("argv");
            if (argv != null) {
                String[] arguments = new String[argv.size()];
                arguments = argv.toArray(arguments);
                service.start(arguments);
            } else {
                service.start();
            }
            result.success(service.getId());
        } else if ("emit".equals(call.method)) {
            String event = call.argument("event");
            Object value = call.argument("value");
            if (value == null) {
                service.emit(event);
            } else if (value instanceof Boolean) {
                service.emit(event, (Boolean) value);
            } else if (value instanceof Long) {
                service.emit(event, (Long) value);
            } else if (value instanceof Float) {
                service.emit(event, (Float) value);
            } else if (value instanceof Double) {
                service.emit(event, (Double) value);
            } else if (value instanceof Integer) {
                service.emit(event, (Integer) value);
            } else if (value instanceof String) {
                service.emit(event, (String) value);
            } else if (value instanceof Map) {
                service.emit(event, new JSONObject((Map) value));
            } else if (value instanceof List) {
                service.emit(event, new JSONArray((List) value));
            } else {
                result.notImplemented();
                return;
            }
            result.success(null);
        } else if ("addEventListener".equals(call.method)) {
            String event = call.argument("event");
            wrappedMicroService.addEventListener(event);
            result.success(null);
        } else if ("removeEventListener".equals(call.method)) {
            String event = call.argument("event");
            result.success(wrappedMicroService.removeEventListener(event));
        } else if ("getId".equals(call.method)) {
            result.success(service.getId());
        } else if ("exitProcess".equals(call.method)) {
            Object exitCode = call.argument("exitCode");
            int code = exitCode == null ? 0 : (int) exitCode;
            service.getProcess().exit(code);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private WrappedMicroService getOrCreateService(String serviceId, String uri) {
        synchronized (microServicesMapLocker) {
            WrappedMicroService service;
            if (!microServices.containsKey(serviceId)) {
                Context context = registrar.context();
                if (uri.startsWith("@flutter_assets/")) {
                    uri = "file:///android_asset/" + registrar.lookupKeyForAsset(uri.substring(16));
                }
                service = new WrappedMicroService(context, uri, new MicroServiceListener(serviceId));
                microServices.put(serviceId, service);
            } else {
                service = microServices.get(serviceId);
            }
            return service;
        }
    }

    private static Map<String, Object> buildArguments(String serviceId, Object value) {
        Map<String, Object> result = new HashMap<>();
        result.put("serviceId", serviceId);
        result.put("value", value);
        return result;
    }

    private class MicroServiceListener implements IMicroServiceListener {

        private String serviceId;

        MicroServiceListener(String serviceId) {
            this.serviceId = serviceId;
        }

        @Override
        public void onStart(MicroService service) {
            if (microServiceMethodChannel != null) {
                microServiceMethodChannel.invokeMethod("listener.onStart", buildArguments(serviceId, null));
            }
        }

        @Override
        public void onError(MicroService service, Exception e) {
            if (microServiceMethodChannel != null) {
                microServiceMethodChannel.invokeMethod("listener.onError", buildArguments(serviceId, e));
            }
        }

        @Override
        public void onExit(MicroService service, Integer exitCode) {
            if (microServiceMethodChannel != null) {
                microServiceMethodChannel.invokeMethod("listener.onExit", buildArguments(serviceId, exitCode));
            }
            synchronized (microServicesMapLocker) {
                // Remove the service instance.
                microServices.remove(serviceId);
            }
        }

        @Override
        public void onEvent(String event, JSONObject payload) {
            if (microServiceMethodChannel != null) {
                Object payloadObject = null;
                if (payload != null) {
                    if (payload.length() == 1 && payload.has("_")) {
                        // This is a simple primitive type, extract it.
                        try {
                            payloadObject = JSONUtil.unwrap(payload.get("_"));
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                    } else {
                        payloadObject = JSONUtil.unwrap(payload);
                    }
                }

                Map<String, Object> map = new HashMap<>();
                map.put("event", event);
                map.put("payload", payloadObject);
                microServiceMethodChannel.invokeMethod("listener.onEvent", buildArguments(serviceId, map));
            }
        }
    }

    public interface IMicroServiceListener extends MicroService.ServiceStartListener, MicroService.ServiceErrorListener, MicroService.ServiceExitListener {
        void onEvent(String event, JSONObject payload);
    }
}
