package com.dband.tpns;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.tencent.android.tpush.XGPushBaseReceiver;
import com.tencent.android.tpush.XGPushClickedResult;
import com.tencent.android.tpush.XGPushRegisterResult;
import com.tencent.android.tpush.XGPushShowedResult;
import com.tencent.android.tpush.XGPushTextMessage;

import android.content.Context;


public class MessageReceiver extends XGPushBaseReceiver {
    /**
     * 注册结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码 XGPushBaseReceiver.SUCCESS成功
     * @param message   注册响应结果 xgPushRegisterResult.getToken获取设备token
     */
    @Override
    public void onRegisterResult(Context context, int errorCode, XGPushRegisterResult message) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        String token = message.getToken();
        map.putString(Extras.XG_TOKEN, token);
        if (errorCode == XGPushBaseReceiver.SUCCESS) {
            TPushModule.instance.sendEvent(Extras.ON_REGISTERED_DONE, map);
        } else {
            TPushModule.instance.sendEvent(Extras.ON_REGISTERED_DEVICE_TOKEN, map);
        }
    }

    /**
     * 注销结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码 XGPushBaseReceiver.SUCCESS成功
     */
    @Override
    public void onUnregisterResult(Context context, int errorCode) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        TPushModule.instance.sendEvent(Extras.UN_REGISTERED, map);
    }

    /**
     * 设置Tag结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码
     * @param msg       消息
     */
    @Override
    public void onSetTagResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_SET_TAG, map);
    }

    /**
     * 删除Tag结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码
     * @param msg       消息
     */
    @Override
    public void onDeleteTagResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_DELETE_TAG, map);
    }

    /**
     * 设置账号结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码
     * @param msg       消息
     */
    @Override
    public void onSetAccountResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_SET_ACCOUNT, map);
    }

    /**
     * 删除账号结果回调
     *
     * @param context   上下文
     * @param errorCode 结果码
     * @param msg       消息
     */
    @Override
    public void onDeleteAccountResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_DELETE_ACCOUNT, map);
    }

    @Override
    public void onSetAttributeResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_SET_ATTRIBUTE, map);
    }

    @Override
    public void onDeleteAttributeResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.instance.sendEvent(Extras.XG_PUSH_DID_DELETE_ATTRIBUTE, map);
    }

    /**
     * 收到透传通知消息
     *
     * @param context 上下文
     * @param message 信鸽推送文本消息
     */
    @Override
    public void onTextMessage(Context context, XGPushTextMessage message) {
        String content = message.getContent();
        String customContent = message.getCustomContent();
        String title = message.getTitle();
        int pushChannel = message.getPushChannel();
        WritableMap map = Arguments.createMap();
        map.putString(Extras.TITLE, title);
        map.putString(Extras.CONTENT, content);
        map.putString(Extras.CUSTOM_MESSAGE, customContent);
        map.putString(Extras.PUSH_CHANNEL, String.valueOf(pushChannel));
        TPushModule.instance.sendEvent(Extras.ON_RECEIVE_MESSAGE, map);
    }

    /**
     * 通知栏消息点击回调
     *
     * @param context         上下文
     * @param result 信鸽推送消息点击结果
     */
    @Override
    public void onNotificationClickedResult(Context context, XGPushClickedResult result) {
        WritableMap map = Arguments.createMap();
        if (context == null || result == null) {
            map.putInt(Extras.CODE, -1);
            TPushModule.instance.sendEvent(Extras.XG_PUSH_CLICK_ACTION, map);
            return;
        }
        String content = result.getContent();
        String customContent = result.getCustomContent();
        String title = result.getTitle();
        int notificationActionType = result.getNotificationActionType();
        long msgId = result.getMsgId();
        String activityName = result.getActivityName();
        long actionType = result.getActionType();

        map.putInt(Extras.CODE, 0);
        map.putString(Extras.TITLE, title);
        map.putString(Extras.CONTENT, content);
        map.putString(Extras.CUSTOM_MESSAGE, customContent);
        map.putString(Extras.MSG_ID, String.valueOf(msgId));
        map.putString(Extras.NOTIFICATION_ACTION_TYPE, String.valueOf(notificationActionType));
        map.putString(Extras.ACTIVITY_NAME, activityName);
        map.putString(Extras.ACTION_TYPE, String.valueOf(actionType));
        //交由Flutter自主处理
        TPushModule.instance.sendEvent(Extras.XG_PUSH_CLICK_ACTION, map);
    }

    /**
     * 通知栏显示
     *
     * @param context 上下文
     * @param message 显示结果
     */
    @Override
    public void onNotificationShowedResult(Context context, XGPushShowedResult message) {
        WritableMap para = Arguments.createMap();
        if (context == null || message == null) {
            para.putInt(Extras.CODE, -1);
            TPushModule.instance.sendEvent(Extras.ON_RECEIVE_NOTIFICATION_RESPONSE, para);
            return;
        }
        String content = message.getContent();
        String customContent = message.getCustomContent();
        int notificationId = message.getNotifactionId();
        String title = message.getTitle();
        long msgId = message.getMsgId();
        String activityPath = message.getActivity();
        int pushChannel = message.getPushChannel();
        int notificationActionType = message.getNotificationActionType();

        para.putInt(Extras.CODE, 0);
        para.putString(Extras.CONTENT, content);
        para.putString(Extras.CUSTOM_MESSAGE, customContent);
        para.putString(Extras.TITLE, title);
        para.putString(Extras.PUSH_CHANNEL, String.valueOf(pushChannel));
        para.putString(Extras.NOTIFICATION_ID, String.valueOf(notificationId));
        para.putString(Extras.MSG_ID, String.valueOf(msgId));
        para.putString(Extras.ACTIVITY, activityPath);
        para.putString(Extras.NOTIFICATION_ACTION_TYPE, String.valueOf(notificationActionType));
        TPushModule.instance.sendEvent(Extras.ON_RECEIVE_NOTIFICATION_RESPONSE, para);
    }
}
