package com.dband.tpns;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushConfig;
import com.tencent.android.tpush.XGPushManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.util.Log;

public class TPushModule extends ReactContextBaseJavaModule {
    private final ReactApplicationContext reactContext;
    public static final String TAG = "TPushModule";
    public static TPushModule instance;
    public static Map<String, List<WritableMap>> eventCache = new HashMap<>();
    public static Map<String, Boolean> hasListen = new HashMap<>();

    public TPushModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        instance = this;
    }

    public static void sendEvent(String event, @Nullable WritableMap params) {
        if (instance != null && hasListen.containsKey(event)) {
            instance.doSend(event, params);
        } else {
            if (!eventCache.containsKey(event)) {
                eventCache.put(event, new ArrayList<>());
            }
            eventCache.get(event).add(params);
        }
    }

    public void doSend(String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit(eventName, params);
    }

    @ReactMethod
    public void startListen(String event) {
        hasListen.put(event, true);
        List<WritableMap> list = eventCache.remove(event);
        if (list != null && !list.isEmpty()) {
            for (WritableMap map: list) {
                doSend(event, map);
            }
        }
    }

    @NonNull
    @Override
    public String getName() {
        return "TPushModule";
    }

    @ReactMethod
    public void enableDebug(boolean enable) {
        Log.i(TAG, "enableDebug:" + enable);
        XGPushConfig.enableDebug(reactContext, enable);
    }

    @ReactMethod
    public void setHeartbeat(int heartbeat) {
        Log.i(TAG, "setHeartbeat:" + heartbeat);
        XGPushConfig.setHeartbeatIntervalMs(reactContext, heartbeat);
    }

    @ReactMethod
    public void register() {
        Log.i(TAG, "register");
        XGPushManager.registerPush(reactContext);
    }

    @ReactMethod
    public void unregister() {
        Log.i(TAG, "unregister:");
        XGPushManager.unregisterPush(reactContext);
    }

    private Set<String> toSet(ReadableArray data) {
        Set<String> set = new HashSet<>();
        for (int i = 0; i < data.size(); i++) {
            String tag = data.getString(i);
            set.add(tag);
        }
        return set;
    }

    private Map<String, String> toMap(ReadableMap data) {
        ReadableMapKeySetIterator iterator = data.keySetIterator();
        Map<String, String> map = new HashMap<>();
        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            map.put(key, data.getString(key));
        }
        return map;
    }

    private XGIOperateCallback createCallback(String event) {
        return new XGIOperateCallback() {
            @Override
            public void onSuccess(Object o, int flag) {
                WritableMap map = Arguments.createMap();
                map.putInt(Extras.CODE, 0);
                map.putInt(Extras.FLAG, flag);
                map.putString(Extras.CONTENT, "Success");
                sendEvent(event, map);
            }

            @Override
            public void onFail(Object o, int errCode, String msg) {
                WritableMap map = Arguments.createMap();
                map.putInt(Extras.CODE, errCode);
                map.putString(Extras.CONTENT, msg);
                sendEvent(event, map);
            }
        };
    }

    /**
     * 设置多个标签，会覆盖之前的标签
     */
    @ReactMethod
    public void setTags(ReadableArray tags) {
        String op = "clearAndAppendTags:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_SET_TAGS);
        XGPushManager.clearAndAppendTags(reactContext, op, toSet(tags), callback);
    }

    /**
     * 添加多个标签，不会覆盖之前的标签
     */
    @ReactMethod
    public void addTags(ReadableArray tags) {
        String op = "appendTags:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_ADD_TAGS);
        XGPushManager.appendTags(reactContext, op, toSet(tags), callback);
    }

    /**
     * 删除多个标签
     */
    @ReactMethod
    public void delTags(ReadableArray tags) {
        String op = "delTags:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_DEL_TAGS);
        XGPushManager.delTags(reactContext, op, toSet(tags), callback);
    }

    /**
     * 清除所有标签
     */
    @ReactMethod
    public void clearTags() {
        String op = "clearTags:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_CLEAR_TAGS);
        XGPushManager.clearTags(reactContext, op, callback);
    }

    /**
     * 添加属性
     */
    @ReactMethod
    public void addAttrs(ReadableMap data) {
        String op = "addAttrs:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_ADD_ATTRS);
        XGPushManager.upsertAttributes(reactContext, op, toMap(data), callback);
    }

    /**
     * 清除后添加属性
     */
    @ReactMethod
    public void setAttrs(ReadableMap data) {
        String op = "setAttrs:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_SET_ATTRS);
        XGPushManager.clearAndAppendAttributes(reactContext, op, toMap(data), callback);
    }

    /**
     * 删除属性
     */
    @ReactMethod
    public void delAttrs(ReadableArray keys) {
        String op = "delAttrs:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_DEL_ATTRS);
        XGPushManager.delAttributes(reactContext, op, toSet(keys), callback);
    }

    /**
     * 清空属性
     */
    @ReactMethod
    public void clearAttrs() {
        String op = "clearAttrs:" + System.currentTimeMillis();
        XGIOperateCallback callback = createCallback(Extras.EVENT_CLEAR_ATTRS);
        XGPushManager.clearAttributes(reactContext, op, callback);
    }

    /**
     * 获取 Token
     */
    @ReactMethod
    public void getToken(Promise promise) {
        String token = XGPushConfig.getToken(reactContext);
        Log.i(TAG, "getToken() token:" + token);
        promise.resolve(token);
    }

    /**
     * 添加或更新账号
     */
    @ReactMethod
    public void upsertAccounts(ReadableArray accounts) {
        List<XGPushManager.AccountInfo> list = new ArrayList<>();
        for (int i = 0; i < accounts.size(); i++) {
            ReadableMap account = accounts.getMap(i);
            String name = account.getString("name");
            int type = account.getInt("type");
            list.add(new XGPushManager.AccountInfo(type, name));
        }
        XGIOperateCallback callback = createCallback(Extras.EVENT_UPSERT_ACCOUNTS);
        XGPushManager.upsertAccounts(reactContext, list, callback);
    }

    /**
     * 删除账号
     */
    @ReactMethod
    public void delAccounts(ReadableArray types) {
        Set<Integer> set = new HashSet<>();
        for (int i = 0; i < types.size(); i++) {
            set.add(types.getInt(i));
        }
        XGIOperateCallback callback = createCallback(Extras.EVENT_DEL_ACCOUNTS);
        XGPushManager.delAccounts(reactContext, set, callback);
    }

    /**
     * 清空账号
     */
    @ReactMethod
    public void clearAccounts() {
        XGIOperateCallback callback = createCallback(Extras.EVENT_CLEAR_ACCOUNTS);
        XGPushManager.clearAccounts(reactContext, callback);
    }

    @ReactMethod
    public void enableOtherPush(boolean enable) {
        Log.i(TAG, "enableOtherPush()");
        XGPushConfig.enableOtherPush(reactContext, enable);
    }

    @ReactMethod
    public void setMiPush(String appId, String appKey) {
        Log.i(TAG, "setMiPush()");
        XGPushConfig.setMiPushAppId(reactContext, appId);
        XGPushConfig.setMiPushAppKey(reactContext, appKey);
    }

    @ReactMethod
    public void setMzPush(String appId, String appKey) {
        Log.i(TAG, "setMzPush()");
        XGPushConfig.setMzPushAppId(reactContext, appId);
        XGPushConfig.setMzPushAppKey(reactContext, appKey);
    }

    @ReactMethod
    public void enableOppoPush(boolean enable) {
        Log.i(TAG, "enableOppoPush()");
        XGPushConfig.enableOppoNotification(reactContext, enable);
    }

    @ReactMethod
    public void setOppoPush(String appId, String appKey) {
        Log.i(TAG, "setOppoPush()");
        XGPushConfig.setOppoPushAppId(reactContext, appId);
        XGPushConfig.setOppoPushAppKey(reactContext, appKey);
    }
}
