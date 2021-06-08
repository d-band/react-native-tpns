package com.dband.tpns;

public interface Extras {
    //参数
    String CODE = "code";
    String CONTENT = "content";
    String DATA = "data";
    String FLAG = "flag";
    String TITLE = "title";
    String BODY = "body";
    String CUSTOM = "custom";
    String PUSH_CHANNEL = "pushChannel";
    String MSG_ID = "msgId";
    String TRACE_ID = "traceId";
    String TEMPLATE_ID = "templateId";
    String COLLAPSE_ID = "collapseId";
    String ACTION = "action";
    String ACTION_TYPE = "actionType";
    String TOKEN = "token";
    // 事件列表
    String EVENT_REGISTER = "TPushEventRegister";
    String EVENT_UNREGISTER = "TPushEventUnregister";
    String EVENT_NOTICE_RECEIVED = "TPushEventNoticeReceived"; //收到推送通知
    String EVENT_NOTICE_CLICKED = "TPushEventNoticeClicked";   //通知点击事件
    String EVENT_MESSAGE_RECEIVED = "TPushMessageReceived"; //收到透传通知
    String EVENT_SET_TAG = "TPushEventSetTag";
    String EVENT_DELETE_TAG = "TPushEventDeleteTag";
    String EVENT_SET_ACCOUNT = "TPushEventSetAccount";
    String EVENT_DELETE_ACCOUNT = "TPushEventDeleteAccount";
    String EVENT_SET_ATTRIBUTE = "TPushEventSetAttribute";
    String EVENT_DELETE_ATTRIBUTE = "TPushEventDeleteAttribute";
    String EVENT_SET_TAGS = "TPushEventSetTags";
    String EVENT_ADD_TAGS = "TPushEventAddTags";
    String EVENT_DEL_TAGS = "TPushEventDelTags";
    String EVENT_CLEAR_TAGS = "TPushEventClearTags";
    String EVENT_QUERY_TAGS = "TPushEventQueryTags";
    String EVENT_UPSERT_ACCOUNTS = "TPushEventUpsertAccounts";
    String EVENT_DEL_ACCOUNTS = "TPushEventDelAccounts";
    String EVENT_CLEAR_ACCOUNTS = "TPushEventClearAccounts";
    String EVENT_ADD_ATTRS = "TPushEventAddAttrs";
    String EVENT_SET_ATTRS = "TPushEventSetAttrs";
    String EVENT_DEL_ATTRS = "TPushEventDelAttrs";
    String EVENT_CLEAR_ATTRS = "TPushEventClearAttrs";
}

