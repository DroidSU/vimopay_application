package com.morningstar.vimopay_application

import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.egram.aepslib.DashboardActivity
import org.json.JSONObject
import java.io.BufferedReader
import java.io.DataOutputStream
import java.io.InputStream
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.brixham.vimopay"
    private lateinit var engine: FlutterEngine

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        engine = flutterEngine
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "AEPS") {
                val aepsIntent = Intent(this, DashboardActivity::class.java)
                aepsIntent.putExtra("saltKey", "8C3327E8D9D5CE419247DC3826806427");
//                aepsIntent.putExtra("secretKey", "MH2503191003444694137MK");
                aepsIntent.putExtra("secretKey", "AAA8D3D121422181CC8C05B2555DAAE04B4FFE88");
                aepsIntent.putExtra("BcId", "BC319061250");
                aepsIntent.putExtra("UserId", "814566");
                aepsIntent.putExtra("bcEmailId", "biswajit.rrootfly@gmail.com");
                aepsIntent.putExtra("Phone1", "8145661425");
                aepsIntent.putExtra("cpid", "CP69871208");
                startActivityForResult(aepsIntent, 11)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 11){
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "AEPS") {
                    data!!.getStringExtra("StatusCode")
                    data.getStringExtra("Message")
                    result.success(data)
                }
            }

            Log.e("Check one", "" + data!!.getStringExtra("Message"))
        }
    }
}
