package com.gunsmod.mcpe.newmaps;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Handler;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;

public class DownloadFile extends AsyncTask<String, String, String> {
    private static final String TAG = "DownloadFile";
    DownloadCallBack callBack;
    Activity activity;

    public DownloadFile(Activity activity) {
        this.activity = activity;
    }

    public void setCallBack(DownloadCallBack callBack) {
        this.callBack = callBack;
    }

    @Override
    protected void onProgressUpdate(String... values) {
        super.onProgressUpdate(values);
        if (callBack != null) {
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callBack.onProfressUpdate(values[0]);
                }
            });
        }
    }

    @Override
    protected void onPostExecute(String s) {
        super.onPostExecute(s);
        if(callBack!= null){
            callBack.onPostExcute(s);
        }
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected String doInBackground(String... voids) {
        BufferedInputStream in = null;
        FileOutputStream fout = null;
        try {
            URL url = new URL(voids[0]);
            URLConnection openConnection = url.openConnection();
            openConnection.connect();
            int contentLength = openConnection.getContentLength();
            in = new BufferedInputStream(url.openStream());
            fout = new FileOutputStream(voids[1]);

            final byte data[] = new byte[2048];
            int count;
            int fileSize = 0;
            while ((count = in.read(data, 0, 2048)) != -1) {
                fout.write(data, 0, count);
                fileSize+=count;
                onProgressUpdate(((fileSize*100)/contentLength)+"");
            }
            return null;
        } catch (Exception e) {
            Log.e(TAG, "doInBackground: " + e);
        } finally {
            try {
                if (in != null) {

                    in.close();
                }
                if (fout != null) {
                    fout.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        return null;
    }
    interface DownloadCallBack{
        void onProfressUpdate(String data);
        void onPostExcute(Object value);
    }
}
