package com.morningstar.vimopay_application

import android.bluetooth.BluetoothAdapter
import android.content.ComponentName
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.Uri
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.egram.aepslib.DashboardActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.brixham.vimopay"
    private lateinit var engine: FlutterEngine
    private lateinit var locationManager: LocationManager


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
            }else if (call.method == "Mini ATM"){
                if(checkIfBluetoothEnabled())
                    getLocationPermission()
                else{
                    Toast.makeText(this, "Please turn on your Bluetooth", Toast.LENGTH_SHORT).show()

                    MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                        if (call.method == "Mini ATM") {
                            result.error("101", "Please turn on your Bluetooth", "")
                        }
                    }
                }
            }
        }
    }

    private fun checkIfBluetoothEnabled() : Boolean {
        val mBluetoothAdapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        return if (mBluetoothAdapter.isEnabled) {
            // Bluetooth is not enabled :)
            Log.d("Bluetooth", "Bluetooth is enabled")
            true
        } else {
            // Bluetooth is enabled
            Log.d("Bluetooth", "Bluetooth is not enabled")
            false
        }
    }

    private fun getLocationPermission(){
        if (ContextCompat.checkSelfPermission(this@MainActivity,
                        android.Manifest.permission.ACCESS_FINE_LOCATION) !=
                PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity,
                            android.Manifest.permission.ACCESS_FINE_LOCATION)) {
                ActivityCompat.requestPermissions(this@MainActivity,
                        arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION), 1)
            }
            else{
                ActivityCompat.requestPermissions(this@MainActivity,
                        arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION), 1)
            }
        }
        else{
            val packageManager: PackageManager = context.packageManager
            if (isPackageInstalled("org.egram.microatm", packageManager)) {
                val intent: Intent = Intent()
                intent.setComponent(ComponentName("org.egram.microatm", "org.egram.microatm.BluetoothMacSearchActivity"))
                intent.putExtra("saltkey", "8C3327E8D9D5CE419247DC3826806427")
                intent.putExtra("secretkey", "AAA8D3D121422181CC8C05B2555DAAE04B4FFE88")
                intent.putExtra("bcid", "BC319061250")
                intent.putExtra("userid", "814566")
                intent.putExtra("bcemailid", "biswajit.rrootfly@gmail.com")
                intent.putExtra("phone1", "8145661425")
                intent.putExtra("clientrefid", "CP69871208")
                intent.putExtra("vendorid", "")
                intent.putExtra("udf1", "")
                intent.putExtra("udf2", "")
                intent.putExtra("udf3", "")
                intent.putExtra("udf4", "")
                startActivityForResult(intent, 10)
            } else {
                val alertDialog: android.app.AlertDialog.Builder = android.app.AlertDialog.Builder(context)
                alertDialog.setTitle("Get Service")
                alertDialog.setMessage("MicroATM Service not installed. Click OK to download.")
                alertDialog.setPositiveButton("OK", DialogInterface.OnClickListener { dialog, which ->

                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=org.egram.microatm")))
                })
                alertDialog.setNegativeButton("Cancel", DialogInterface.OnClickListener { dialog, which ->
                    dialog.dismiss()
                })
                alertDialog.show()
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        when (requestCode){
            1 -> {
                if (grantResults.isNotEmpty() && grantResults[0] ==
                        PackageManager.PERMISSION_GRANTED) {
                    // do nothing
                    val packageManager: PackageManager = context.packageManager
                    if (isPackageInstalled("org.egram.microatm", packageManager)) {
                        val intent: Intent = Intent()
                        intent.setComponent(ComponentName("org.egram.microatm", "org.egram.microatm.BluetoothMacSearchActivity"))
                        intent.putExtra("saltkey", "8C3327E8D9D5CE419247DC3826806427")
                        intent.putExtra("secretkey", "AAA8D3D121422181CC8C05B2555DAAE04B4FFE88")
                        intent.putExtra("bcid", "BC319061250")
                        intent.putExtra("userid", "814566")
                        intent.putExtra("bcemailid", "biswajit.rrootfly@gmail.com")
                        intent.putExtra("phone1", "8145661425")
                        intent.putExtra("clientrefid", "CP69871208")
                        intent.putExtra("vendorid", "")
                        intent.putExtra("udf1", "")
                        intent.putExtra("udf2", "")
                        intent.putExtra("udf3", "")
                        intent.putExtra("udf4", "")
                        startActivityForResult(intent, 10)
                    } else {
                        val alertDialog: android.app.AlertDialog.Builder = android.app.AlertDialog.Builder(context)
                        alertDialog.setTitle("Get Service")
                        alertDialog.setMessage("MicroATM Service not installed. Click OK to download.")
                        alertDialog.setPositiveButton("OK", DialogInterface.OnClickListener { dialog, which ->

                            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=org.egram.microatm")))


                        })
                        alertDialog.setNegativeButton("Cancel", DialogInterface.OnClickListener { dialog, which ->
                            dialog.dismiss()
                        })
                        alertDialog.show()
                    }
                } else {
                    Toast.makeText(this, "Location Permission Denied", Toast.LENGTH_SHORT).show()
                    MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                        if (call.method == "Mini ATM") {
                            result.error("102", "Please turn on your Location", "")
                        }
                    }
                }
                return
            }
        }
    }
    fun isPackageInstalled(packagename: String?, packageManager: PackageManager): Boolean {
        return try {
            packageManager.getPackageInfo(packagename!!, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
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
        else if(requestCode == 10){
            if(resultCode == RESULT_OK){
                Log.d("TAG", "Result Code : $resultCode Response: ${data.toString()}")

                val respCode = data!!.getStringExtra("respcode")

                if(respCode == "999"){
                    val requesttxn = data.getStringExtra("requesttxn ")
                    val refstan = data.getStringExtra("refstan")
                    val txnamount = data.getStringExtra("txnamount")
                    val mid = data.getStringExtra("mid")
                    val tid = data.getStringExtra("tid")
                    val clientrefid = data.getStringExtra("clientrefid")
                    val vendorid = data.getStringExtra("vendorid")
                    val udf1 = data.getStringExtra("udf1")
                    val udf2 = data.getStringExtra("udf2")
                    val udf3 = data.getStringExtra("udf3")
                    val udf4 = data.getStringExtra("udf4")
                    val date = data.getStringExtra("date")
                }
                else{
                    val requesttxn = data.getStringExtra("requesttxn ")
                    val bankremarks = data.getStringExtra("msg")
                    val refstan = data.getStringExtra("refstan")
                    val cardno = data.getStringExtra("cardno")
                    val date = data.getStringExtra("date")
                    val amount = data.getStringExtra("amount")
                    val invoicenumber = data.getStringExtra("invoicenumber")
                    val mid = data.getStringExtra("mid")
                    val tid = data.getStringExtra("tid")
                    val clientrefid = data.getStringExtra("clientrefid")
                    val vendorid = data.getStringExtra("vendorid")
                    val udf1 = data.getStringExtra("udf1")
                    val udf2 = data.getStringExtra("udf2")
                    val udf3 = data.getStringExtra("udf3")
                    val udf4 = data.getStringExtra("udf4")
                    val txnamount = data.getStringExtra("txnamount")
                    val rrn = data.getStringExtra("rrn")
                }
            }
            else{
                data!!.getStringExtra("statuscode");
                data.getStringExtra("message");
                if (data.getStringExtra("statuscode").equals("111")){
                    try {
                        startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=org.egram.microatm")))
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }else{
//                util().snackBar(ParentLayout, "" + data.getStringExtra("message"), SnackBarBackGroundColor)
                }
            }
        }else{

        }
    }

}
