package cn.com.agree.flutter.miniprogram.components;

import android.content.Context;

import org.json.JSONObject;
import org.liquidplayer.service.MicroService;
import org.liquidplayer.service.MicroService.ServiceStartListener;

import java.net.URI;
import java.util.HashMap;
import java.util.HashSet;

import cn.com.agree.flutter.miniprogram.handler.MicroServiceHandler;

public class WrappedMicroService implements MicroService.EventListener {
    private MicroService microService;
    private final MicroServiceHandler.IMicroServiceListener serviceStartListener;
    private HashMap<String, Integer> listenerCount = new HashMap<>();

    // List of events to add immediately before the service is executed.
    private HashSet<String> events;
    private boolean started = false;

    public WrappedMicroService(Context context, String uri, MicroServiceHandler.IMicroServiceListener _serviceStartListener) {
        serviceStartListener = _serviceStartListener;
        microService = new MicroService(context, URI.create(uri), new ServiceStartListener() {
            @Override
            public void onStart(MicroService service) {
                started = true;
                if (events != null) {
                    // Add the event listeners synchronously, so there's no race conditions.
                    for (String event : events) {
                        microService.addEventListener(event, WrappedMicroService.this);
                    }
                    events = null;
                }
                serviceStartListener.onStart(service);
            }
        });
    }

    public MicroService getMicroService() {
        return microService;
    }

    public void addEventListener(String event) {
        if (!listenerCount.containsKey(event)) {
            listenerCount.put(event, 1);
            if (started) {
                microService.addEventListener(event, this);
            } else {
                // Bubble the events until the service has been started.
                if (events == null) {
                    events = new HashSet<>();
                }
                events.add(event);
            }
        } else {
            listenerCount.put(event, listenerCount.get(event) + 1);
        }
    }

    public boolean removeEventListener(String event) {
        Integer count = listenerCount.get(event);
        if ((count == null) || (count <= 0)) {
            return false;
        }
        listenerCount.put(event, count - 1);
        if (count == 1) {
            microService.removeEventListener(event, this);
        }
        if (events != null) {
            events.remove(event);
        }
        return true;
    }

    public void onEvent(MicroService service, String event, JSONObject payload) {
        serviceStartListener.onEvent(event, payload);
    }
}
