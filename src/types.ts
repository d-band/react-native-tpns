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

export enum AccountEvent {
  UPSERT = 'xgPushDidUpsertAccounts',
  DEL = 'xgPushDidDelAccounts',
  CLEAR = 'xgPushDidClearAccounts',
}

export enum TagEvent {
  ADD = 'xgPushDidAddTags',
  SET = 'xgPushDidSetTags',
  DEL = 'xgPushDidDelTags',
  CLEAR = 'xgPushDidClearTags',
}

export enum AttrEvent {
  ADD = 'xgPushDidAddAttrs',
  SET = 'xgPushDidSetAttrs',
  DEL = 'xgPushDidDelAttrs',
  CLEAR = 'xgPushDidClearAttrs',
}

export interface AccountInfo {
  name: string;
  type: AccountType;
}

export interface Result {
  resultCode: number;
  content?: string;
}

export interface TokenResult extends Result {
  xgToken: string;
}
