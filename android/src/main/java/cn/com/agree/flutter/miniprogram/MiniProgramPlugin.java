package cn.com.agree.flutter.miniprogram;

import android.content.Context;
import android.os.Build;
import android.webkit.WebView;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterMiniProgramPlugin
 */
public class MiniProgramPlugin implements MethodCallHandler {
    private WebView webView;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "mini_program/JSRuntime");
        channel.setMethodCallHandler(new MiniProgramPlugin(registrar.context()));
    }

    private MiniProgramPlugin(final Context context) {
        if (webView == null) {
            webView = new WebView(context);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                WebView.setWebContentsDebuggingEnabled(true);
            }
            webView.getSettings().setJavaScriptEnabled(true);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "evaluateJavascript":
                String script = call.argument("script");
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    webView.evaluateJavascript(script, value -> result.success(value));
                }
                break;
            case "invokeMethod":
                result.success("Android " + Build.VERSION.RELEASE);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
