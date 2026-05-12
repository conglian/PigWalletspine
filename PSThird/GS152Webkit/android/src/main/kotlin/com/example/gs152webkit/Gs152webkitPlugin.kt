package com.example.gs152webkit

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log

/** Gs152webkitPlugin */
class Gs152webkitPlugin :
    FlutterPlugin,
    MethodCallHandler{
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gs152webkit")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "openBrowser" -> {
                val url = call.argument<String>("url")
                if (url != null) {
                    openBrowser(url)
                    result.success(true)
                } else {
                    result.error("INVALID_URL", "URL is null", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun openBrowser(url: String) {
        Log.d("WebViewPage", "Gs130pacessPlugin openBrowser $url")
        try {
            var intent: Intent? = if (url.startsWith("intent")) {
                Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
            } else {
                Intent(Intent.ACTION_VIEW, Uri.parse(url))
            }

            intent?.apply {
//                if (isHuawei()) {
//                    setPackage(getDefaultBrowser())
//                }
                addCategory(Intent.CATEGORY_BROWSABLE)
                component = null
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            context.startActivity(intent)
        } catch (e: Exception) {
            Log.e("Gs152pacessPlugin", "openBrowser error: $e")
        }
    }

    private fun isHuawei(): Boolean {
        return Build.MANUFACTURER.equals("huawei", ignoreCase = true)
    }

    private fun getDefaultBrowser(): String? {
        // TODO: 可在这里实现获取系统默认浏览器的逻辑
        return null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
