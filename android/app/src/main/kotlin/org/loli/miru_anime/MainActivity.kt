package org.loli.miru_anime

import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    /*private val CHANNEL = "org.loli.miru_anime/anime_downloader"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "initDownload" -> {
                    val fileName: String = call.argument("fileName")!!
                    val url: String = call.argument("url")!!
                    val description: String = call.argument("description")!!
                    val outputFile: String = call.argument("outputFile")!!
                    val ext: String = call.argument("ext")!!
                    val id = initDownload(url, outputFile, description, fileName, ext)
                    result.success(id)
                }
                "deleteDownload" -> {
                    val id: Long = call.argument("id")!!
                    val res = deleteDownloadFile(id)
                    result.success(res)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun initDownload(url: String, outputFile: String, description: String, fileName: String, ext: String): Long {
        val request = DownloadManager.Request(Uri.parse(url))
        request.setDescription("Miru Anime")
        request.setTitle("$description - $fileName")
        request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, "$outputFile/$fileName$ext")

        val manager: DownloadManager = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        return manager.enqueue(request)
    }

    private fun deleteDownloadFile(id: Long): Boolean {
        val manager = getSystemService(DOWNLOAD_SERVICE) as DownloadManager
        manager.remove(id)
        return true
    }*/
}
