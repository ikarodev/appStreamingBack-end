package com.maostagarelas.handsplay

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.util.Log
import android.util.Rational
import android.widget.VideoView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
// import com.google.android.gms.cast.framework.CastContext

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.maostagarelas.handsplay/pip"
    private var videoUrl: String? = null
    private var isPlaying = false
    private var playbackPosition: Int = 0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
       // CastContext.getSharedInstance(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateVideoState" -> {
                    val args = call.arguments as? Map<*, *>
                    isPlaying = args?.get("isPlaying") as? Boolean ?: false
                    videoUrl = args?.get("videoUrl") as? String
                    playbackPosition = args?.get("position") as? Int ?: 0

                    result.success(null)
                }
                "enterPipMode" -> {
                    val args = call.arguments as? Map<*, *>
                    videoUrl = args?.get("videoUrl") as? String
                    playbackPosition = (args?.get("position") as? Int) ?: 0

                    enterPipMode()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }


    private fun enterPipMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(16, 9))
                .build()
            enterPictureInPictureMode(params)
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isPlaying) {
            enterPipMode()
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        if (isInPictureInPictureMode) {
            // Hide UI elements
            // You can send a message to Flutter to update the UI
        } else {
            // Show UI elements
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        // Clean up resources if needed
    }
}
