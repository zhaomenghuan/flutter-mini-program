package cn.com.agree.flutter.miniprogram.components;

import org.liquidplayer.javascript.JSContext;

public class WrappedJSContext {
    private JSContext jsContext;

    public WrappedJSContext() {
        jsContext = new JSContext();
    }

    public JSContext getJSContext() {
        return jsContext;
    }

    public void freeUp() {
        jsContext = null;
    }
}
