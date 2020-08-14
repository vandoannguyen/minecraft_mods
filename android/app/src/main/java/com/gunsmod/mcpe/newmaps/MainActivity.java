package com.gunsmod.mcpe.newmaps;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.gunsmod.mcpe.newmaps.utils.FileUtils;
import com.gunsmod.mcpe.newmaps.utils.SharedPrefsUtils;
import com.gunsmod.mcpe.newmaps.utils.UnzipUtility;
import com.example.ratedialog.RatingDialog;
import com.google.gson.Gson;

import java.io.File;
import java.io.IOException;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static com.gunsmod.mcpe.newmaps.AppConst.folderPath;

public class MainActivity extends FlutterActivity implements RatingDialog.RatingDialogInterFace {
    private static final String CHANNEL = "com.example.init_app";
    EventChannel.EventSink eventChannel = null;
    private String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        if (checkStoragePermission()) {
            createFolderIfNotExits();
        } else {
            requestStoragePermission();
        }
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
                    case "rateManual": {
                        rateManual();
                        break;
                    }
                    case "rateAuto": {
                        rateAuto();
                        break;
                    }
                    case "sendMess": {
                        Intent sendIntent = new Intent();
                        sendIntent.setAction(Intent.ACTION_SEND);
                        sendIntent.putExtra(Intent.EXTRA_TEXT, "This is my text to send.");
                        sendIntent.setType("text/plain");
                        startActivity(sendIntent);
                    }
                    case "checkFileExit": {
                        result.success(checkFileExit(methodCall.argument("path")));
                        break;
                    }
                    case "checkMinecraft": {
                        result.success(checkMinecraft("com.mojang.minecraftpe"));
                        break;
                    }
                    case "getPackage": {
                        result.success(BuildConfig.APPLICATION_ID);
                        break;
                    }
                    case "installMod": {
                        installMod(methodCall, result);
                        break;
                    }
                    case "download": {
                        downloadFile(methodCall.argument("url"), methodCall.argument("fileName"));
                    }

                }
            }
        });
        new EventChannel(getFlutterView(), "download").setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventChannel = events;
            }

            @Override
            public void onCancel(Object arguments) {
                eventChannel = null;
            }
        });
    }

    private void installMod(MethodCall call, MethodChannel.Result result) {
        String fileName = call.argument("name");
        String folder = call.argument("folder");
        Log.e(TAG, "installMod: " + fileName + "  " + folder);
        if(checkStoragePermission()){
            if (folder.equals("addon")) {
                unZipFileAddon(AppConst.folderPath + "/" + fileName, AppConst.folderPath + "/" + fileName.substring(0, fileName.length() - 9));
            } else {
                if (eventChannel != null) {
                    eventChannel.success(new Gson().toJson(new EventNative("progress", "")));
                }
                String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/games/com.mojang/" + folder;
                Log.e(TAG, "installMod: " + fileName );
                copyAndUnzip(folderPath + "/" + fileName, path+"/"+fileName.substring(0, fileName.indexOf('.')));
                if (eventChannel != null) {
                    eventChannel.success(new Gson().toJson(new EventNative("success", "")));
                }
                Toast.makeText(this, "Install success please reopen Minecraft", Toast.LENGTH_SHORT).show();
            }
        }
        else {
            Toast.makeText(this, "Please accept storage permission", Toast.LENGTH_SHORT).show();
        }
    }

    private void unZipFileAddon(String s, String des) {
        if (checkStoragePermission()) {
            File file = new File(des);
            if (file.exists()) {
                file.mkdirs();
            }
            try {
                UnzipUtility.unzip(s, des);
                File[] listFile = new File(des).listFiles();
                copyFile(listFile);
            } catch (IOException e) {
                Log.e(TAG, "unZipFile: " + e);
                e.printStackTrace();
            }

        } else {
            Toast.makeText(this, "Please allow permission", Toast.LENGTH_SHORT).show();
        }
    }

    private void copyFile(File[] listFile) {
        try {
            for (File f : listFile) {
                Log.e(TAG, "unZipFile: " + f.getName().toLowerCase());
                if (f.getName().toLowerCase().contains("behavior")) {
                    FileUtils.copy(f, new File(Environment.getExternalStorageDirectory()
                            .getAbsoluteFile()
                            + "/games/com.mojang/behavior_packs/"
                            + f.getName()
                    ));
                } else {
                    FileUtils.copy(f, new File(Environment.getExternalStorageDirectory()
                            .getAbsoluteFile()
                            + "/games/com.mojang/resource_packs/"
                            + f.getName()
                    ));
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "copyFile: " + e);
        }
    }

    private void downloadFile(String url, String fileName) {
        DownloadFile downloadFile = new DownloadFile(this);
        downloadFile.execute(new String[]{url, folderPath + "/" + fileName});
        downloadFile.setCallBack(new DownloadFile.DownloadCallBack() {
            @Override
            public void onProfressUpdate(String data) {
                if (eventChannel != null) {
                    eventChannel.success(new Gson().toJson(new EventNative("progress", data + "%")));
                }
            }

            @Override
            public void onPostExcute(Object value) {
                if (eventChannel != null) {
                    eventChannel.success(new Gson().toJson(new EventNative("success", "")));
                }
            }
        });
    }

    private boolean checkStoragePermission() {
        return ContextCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                &&
                ContextCompat.checkSelfPermission(this,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestStoragePermission() {
        ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        {
            if (requestCode == 0) {
                if (checkStoragePermission()) {
                    createFolderIfNotExits();
                } else {
                    Toast.makeText(this, "Please accept this permission", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }

    private void createFolderIfNotExits() {
        String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/" + BuildConfig.APPLICATION_ID;
        Log.e("TAG", "createFolderIfNotExits: " + path);
        File file1 = new File(path);
        if (!file1.exists()) {
            file1.mkdirs();
        }
        folderPath = file1.getAbsolutePath();
    }

    private Boolean checkMinecraft(String packageName) {
        PackageManager packageManager = getPackageManager();
        try {
            packageManager.getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private Boolean checkFileExit(String path) {
        if (checkStoragePermission()) {
            String folderPath = Environment.getExternalStorageDirectory().getAbsolutePath();
            File file = new File(folderPath + "/" + BuildConfig.APPLICATION_ID + "/" + path);
            return file.exists();
        } else {
            requestStoragePermission();
            return false;
        }
    }

    private void copyAndUnzip(String filePathIn, String folderOut) {
        File folder = new File(folderOut);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        try {
            UnzipUtility.unzip(filePathIn, folderOut);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void rateApp(Context context) {
        Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
                Uri.parse("http://play.google.com/store/apps/details?id=" + context.getPackageName())));
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    //Rate
    private void rateAuto() {
        int rate = SharedPrefsUtils.getInstance(this).getInt("rate");
        if (rate < 1) {
            RatingDialog ratingDialog = new RatingDialog(this);
            ratingDialog.setRatingDialogListener(this);
            ratingDialog.showDialog();
        }
    }

    private void rateManual() {
        RatingDialog ratingDialog = new RatingDialog(this);
        ratingDialog.setRatingDialogListener(this);
        ratingDialog.showDialog();
    }

    @Override
    public void onDismiss() {

    }

    @Override
    public void onSubmit(float rating) {
        if (rating > 3) {
            rateApp(this);
            SharedPrefsUtils.getInstance(this).putInt("rate", 5);
        }
    }

    @Override
    public void onRatingChanged(float rating) {
    }
}
