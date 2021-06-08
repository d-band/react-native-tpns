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
        map.putString(Extras.TOKEN, message.getToken());
        TPushModule.sendEvent(Extras.EVENT_REGISTER, map);
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
        TPushModule.sendEvent(Extras.EVENT_UNREGISTER, map);
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
        TPushModule.sendEvent(Extras.EVENT_SET_TAG, map);
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
        TPushModule.sendEvent(Extras.EVENT_DELETE_TAG, map);
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
        TPushModule.sendEvent(Extras.EVENT_SET_ACCOUNT, map);
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
        TPushModule.sendEvent(Extras.EVENT_DELETE_ACCOUNT, map);
    }

    @Override
    public void onSetAttributeResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.sendEvent(Extras.EVENT_SET_ATTRIBUTE, map);
    }

    @Override
    public void onQueryTagsResult(Context context, int errorCode, String msg, String s1) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.sendEvent(Extras.EVENT_QUERY_TAGS, map);
    }

    @Override
    public void onDeleteAttributeResult(Context context, int errorCode, String msg) {
        WritableMap map = Arguments.createMap();
        map.putInt(Extras.CODE, errorCode);
        map.putString(Extras.CONTENT, msg);
        TPushModule.sendEvent(Extras.EVENT_DELETE_ATTRIBUTE, map);
    }

    /**
     * 收到透传通知消息
     *
     * @param context 上下文
     * @param message 信鸽推送文本消息
     */
    @Override
    public void onTextMessage(Context context, XGPushTextMessage message) {
        WritableMap data = Arguments.createMap();
        data.putString(Extras.TITLE, message.getTitle());
        data.putString(Extras.BODY, message.getContent());
        data.putString(Extras.CUSTOM, message.getCustomContent());
        data.putInt(Extras.PUSH_CHANNEL, message.getPushChannel());
        WritableMap result = Arguments.createMap();
        result.putInt(Extras.CODE, 0);
        result.putMap(Extras.DATA, data);
        TPushModule.sendEvent(Extras.EVENT_MESSAGE_RECEIVED, result);
    }

    /**
     * 通知栏消息点击回调
     *
     * @param context         上下文
     * @param message 信鸽推送消息点击结果
     */
    @Override
    public void onNotificationClickedResult(Context context, XGPushClickedResult message) {
        WritableMap result = Arguments.createMap();
        if (context == null || message == null) {
            result.putInt(Extras.CODE, -1);
            TPushModule.sendEvent(Extras.EVENT_NOTICE_CLICKED, result);
            return;
        }
        WritableMap data = Arguments.createMap();
        data.putInt(Extras.MSG_ID, (int) message.getMsgId());
        data.putString(Extras.TITLE, message.getTitle());
        data.putString(Extras.BODY, message.getContent());
        data.putString(Extras.CUSTOM, message.getCustomContent());
        data.putInt(Extras.PUSH_CHANNEL, message.getPushChannel());
        data.putString(Extras.ACTION, message.getActivityName());
        data.putInt(Extras.ACTION_TYPE, message.getNotificationActionType());
        data.putString(Extras.TEMPLATE_ID, message.getTemplateId());
        data.putString(Extras.TRACE_ID, message.getTraceId());
        result.putInt(Extras.CODE, 0);
        result.putMap(Extras.DATA, data);
        TPushModule.sendEvent(Extras.EVENT_NOTICE_CLICKED, result);
    }

    /**
     * 通知栏显示
     *
     * @param context 上下文
     * @param message 显示结果
     */
    @Override
    public void onNotificationShowedResult(Context context, XGPushShowedResult message) {
        WritableMap result = Arguments.createMap();
        if (context == null || message == null) {
            result.putInt(Extras.CODE, -1);
            TPushModule.sendEvent(Extras.EVENT_NOTICE_RECEIVED, result);
            return;
        }
        WritableMap data = Arguments.createMap();
        data.putInt(Extras.MSG_ID, (int) message.getMsgId());
        data.putString(Extras.TITLE, message.getTitle());
        data.putString(Extras.BODY, message.getContent());
        data.putString(Extras.CUSTOM, message.getCustomContent());
        data.putInt(Extras.PUSH_CHANNEL, message.getPushChannel());
        data.putString(Extras.ACTION, message.getActivity());
        data.putInt(Extras.ACTION_TYPE, message.getNotificationActionType());
        data.putString(Extras.TEMPLATE_ID, message.getTemplateId());
        data.putString(Extras.TRACE_ID, message.getTraceId());
        data.putInt(Extras.COLLAPSE_ID, message.getNotifactionId());
        result.putInt(Extras.CODE, 0);
        result.putMap(Extras.DATA, data);
        TPushModule.sendEvent(Extras.EVENT_NOTICE_RECEIVED, result);
    }
}
