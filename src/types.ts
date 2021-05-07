export enum AccountType {
  UNKNOWN = 0,
  CUSTOM = 1,
  IDFA = 1001,
  PHONE_NUMBER = 1002,
  WX_OPEN_ID = 1003,
  QQ_OPEN_ID = 1004,
  EMAIL = 1005,
  SINA_WEIBO = 1006,
  ALIPAY = 1007,
  TAOBAO = 1008,
  DOUBAN = 1009,
  FACEBOOK = 1010,
  TWRITTER = 1011,
  GOOGLE = 1012,
  BAIDU = 1013,
  JINGDONG = 1014,
  LINKIN = 1015,
  IMEI = 1000,
}

export enum TPushEvent {
  REGISTER = 'TPushEventRegister',
  UNREGISTER = 'TPushEventUnregister',
  NOTICE_RECEIVED = 'TPushEventNoticeReceived', //收到推送通知
  NOTICE_CLICKED = 'TPushEventNoticeClicked', //通知点击事件
  MESSAGE_RECEIVED = 'TPushMessageReceived', //收到透传通知
  SET_TAGS = 'TPushEventSetTags',
  ADD_TAGS = 'TPushEventAddTags',
  DEL_TAGS = 'TPushEventDelTags',
  CLEAR_TAGS = 'TPushEventClearTags',
  UPSERT_ACCOUNTS = 'TPushEventUpsertAccounts',
  DEL_ACCOUNTS = 'TPushEventDelAccounts',
  CLEAR_ACCOUNTS = 'TPushEventClearAccounts',
  ADD_ATTRS = 'TPushEventAddAttrs',
  SET_ATTRS = 'TPushEventSetAttrs',
  DEL_ATTRS = 'TPushEventDelAttrs',
  CLEAR_ATTRS = 'TPushEventClearAttrs',
  SET_BADGE = 'TPushEventSetBadge',
}

export interface AccountInfo {
  name: string;
  type: AccountType;
}

export interface Result {
  code: number;
  content?: string;
}

export interface TokenResult extends Result {
  token?: string;
}

export interface Message {
  msgId?: number;
  title: string;
  body: string;
  pushChannel?: number;
  collapseId?: number;
  templateId?: string;
  traceId?: string;
  custom?: string;
  // android
  action?: string;
  actionType?: number;
  // ios
  msgType?: number;
  groupId?: string;
  badge?: number;
  sound?: string;
  subtitle?: string;
  category?: string;
  badgeType?: number;
  mutableContent?: number;
  targetType?: number;
  pushTime?: number;
}

export interface MessageResult extends Result {
  data?: Message;
}
