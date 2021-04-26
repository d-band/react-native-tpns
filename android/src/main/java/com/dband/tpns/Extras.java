package com.dband.tpns;


public interface Extras {
    String TAGS = "tags";
    //参数
    String CONTENT = "content";
    String CODE = "code";
    String FLAG = "flag";
    String TITLE = "title";
    String CUSTOM_MESSAGE = "customMessage";
    String PUSH_CHANNEL = "pushChannel";
    String NOTIFICATION_ID = "notificationId";
    String NOTIFICATION_ACTION_TYPE = "notificationActionType";
    String MSG_ID = "msgId";
    String ACTIVITY = "activity";
    String ACTIVITY_NAME = "activityName";
    String ACTION_TYPE = "actionType";
    String XG_TOKEN = "xgToken";



    //调用Flutter的函数名称
    String ON_REGISTERED_DEVICE_TOKEN = "onRegisteredDeviceToken"; //获取设备token回调（在注册成功里面获取的）
    String ON_REGISTERED_DONE = "onRegisteredDone";    //注册成功回调
    String UN_REGISTERED = "unRegistered";     //反注册回调
    String ON_RECEIVE_NOTIFICATION_RESPONSE = "onReceiveNotificationResponse";   //收到通知
    String ON_RECEIVE_MESSAGE = "onReceiveMessage";       //收到透传通知
    String XG_PUSH_DID_SET_TAG = "xgPushDidSetTag";
    String XG_PUSH_DID_DELETE_TAG = "xgPushDidDeleteTag";
    String XG_PUSH_DID_SET_ACCOUNT = "xgPushDidSetAccount";
    String XG_PUSH_DID_DELETE_ACCOUNT = "xgPushDidDeleteAccount";
    String XG_PUSH_DID_SET_ATTRIBUTE = "xgPushDidSetAttribute";
    String XG_PUSH_DID_DELETE_ATTRIBUTE = "xgPushDidDeleteAttribute";
    String XG_PUSH_DID_SET_TAGS = "xgPushDidSetTags";
    String XG_PUSH_DID_ADD_TAGS = "xgPushDidAddTags";
    String XG_PUSH_DID_DEL_TAGS = "xgPushDidDelTags";
    String XG_PUSH_DID_CLEAR_TAGS = "xgPushDidClearTags";
    String XG_PUSH_DID_UPSERT_ACCOUNTS = "xgPushDidUpsertAccounts";
    String XG_PUSH_DID_DEL_ACCOUNTS = "xgPushDidDelAccounts";
    String XG_PUSH_DID_CLEAR_ACCOUNTS = "xgPushDidClearAccounts";
    String XG_PUSH_DID_ADD_ATTRS = "xgPushDidAddAttrs";
    String XG_PUSH_DID_SET_ATTRS = "xgPushDidSetAttrs";
    String XG_PUSH_DID_DEL_ATTRS = "xgPushDidDelAttrs";
    String XG_PUSH_DID_CLEAR_ATTRS = "xgPushDidClearAttrs";
    String XG_PUSH_CLICK_ACTION = "xgPushClickAction";   //通知点击事件
}

