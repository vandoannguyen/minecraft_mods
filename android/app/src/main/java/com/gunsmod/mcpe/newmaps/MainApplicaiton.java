package com.gunsmod.mcpe.newmaps;

import com.flurry.android.FlurryAgent;

import io.flutter.app.FlutterApplication;

public class MainApplicaiton extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        new FlurryAgent.Builder()
                .withLogEnabled(true)
                .build(this, "YJCCQX2ZWQBVHWY8SM2C");
    }
}
