package com.example.piggywalletspinearn

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger
import com.facebook.appevents.AppEventsConstants
import io.flutter.plugin.common.MethodChannel
import android.content.Context

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.piggywalletspinearn/facebook"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initFacebook" -> {
                    val appId = call.argument<String>("app_id")
                    val clientToken = call.argument<String>("client_token")
                    val appName = call.argument<String>("app_name")

                    if (appId != null && clientToken != null && appName != null) {
                        FacebookSdk.setApplicationId(appId)
                        FacebookSdk.setClientToken(clientToken)
                        FacebookSdk.setApplicationName(appName)
                        FacebookSdk.sdkInitialize(applicationContext)
                        AppEventsLogger.activateApp(application)
                        result.success(true)
                    } else {
                        result.error("INIT_ERROR", "Missing params", null)
                    }
                }

                "logPurchase" -> {
                    val amount = call.argument<Double>("amount")
                    val currency = call.argument<String>("currency")
                    val logger = AppEventsLogger.newLogger(this)

                    if (amount != null && currency != null) {
                        logger.logPurchase(
                            java.math.BigDecimal(amount),
                            java.util.Currency.getInstance(currency)
                        )
                        // Ad Impression event
                        val params = Bundle().apply {
                            putString(
                                AppEventsConstants.EVENT_PARAM_CURRENCY,
                                currency // 建议不要写死 USD
                            )
                        }

                        logger.logEvent(
                            AppEventsConstants.EVENT_NAME_AD_IMPRESSION,
                            amount, // Ad_Impression_Value
                            params
                        )
                        result.success(true)
                    } else {
                        result.error("PURCHASE_ERROR", "Missing amount or currency", null)
                    }
                }

                else -> result.notImplemented()

            }
        }
    }

}
