import {
  EmitterSubscription,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import {
  AccountInfo,
  TPushEvent,
  Result,
  TokenResult,
  MessageResult,
} from './types';

export * from './types';

const { TPushModule } = NativeModules;
const PushEventEmitter = new NativeEventEmitter(TPushModule);

export default class TPush {
  /**************************************************************************************/
  /***                                 TPNS注册等接口                                   ***/
  /**************************************************************************************/

  /// debug模式默认为关闭状态
  static enableDebug(enable: boolean) {
    TPushModule.enableDebug(enable);
  }

  /// 注册推送服务（iOS 需传 appId 和 appKey）
  static register(appId?: string, appKey?: string, domainName?: string) {
    if (Platform.OS === 'ios') {
      /// 集群域名配置（非广州集群需要在 register 之前调用此函数）
      /// 香港：tpns.hk.tencent.com
      /// 新加坡：tpns.sgp.tencent.com
      /// 上海：tpns.sh.tencent.com
      TPushModule.configureClusterDomainName(domainName);
      TPushModule.register(appId, appKey);
    } else {
      TPushModule.register();
    }
  }

  /// 注销推送服务
  static unregister() {
    TPushModule.unregister();
  }

  /**
   * 获取Xg的token
   * App 第一次注册会产生 Token，之后一直存在手机上，不管以后注销注册操作，该 Token 一直存在，
   * 当 App 完全卸载重装了 Token 会发生变化。不同 App 之间的 Token 不一样。
   */
  static getToken(): Promise<string> {
    return TPushModule.getToken();
  }

  /***********************************************************************************************/
  /***                                     账号相关接口                                          ***/
  /***********************************************************************************************/

  /// 添加账号
  static upsertAccounts(accounts: AccountInfo[]) {
    TPushModule.upsertAccounts(accounts);
  }

  /// 删除指定账号
  static delAccounts(types: number[]) {
    TPushModule.delAccounts(types);
  }

  /// 删除所有账号
  static clearAccounts() {
    TPushModule.clearAccounts();
  }

  /******************************************************************************************/
  /***                                   标签相关接口                                       ***/
  /******************************************************************************************/

  /// 追加标签
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) 字符串数组[tagStr]
  static addTags(tags: string[]) {
    TPushModule.addTags(tags);
  }

  /// 覆盖标签(清除所有标签再追加)
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) 字符串数组[tagStr]
  static setTags(tags: string[]) {
    TPushModule.setTags(tags);
  }

  /// 删除指定标签
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) 字符串数组[tagStr]
  static delTags(tags: string[]) {
    TPushModule.delTags(tags);
  }

  /// 清除所有标签
  static clearTags() {
    TPushModule.clearTags();
  }

  /******************************************************************************************/
  /***                                   属性相关接口                                       ***/
  /******************************************************************************************/

  /// 添加属性
  static addAttrs(attrs: { [key: string]: string }) {
    TPushModule.addAttrs(attrs);
  }

  /// 覆盖属性
  static setAttrs(attrs: { [key: string]: string }) {
    TPushModule.setAttrs(attrs);
  }

  /// 删除属性
  static delAttrs(keys: string[]) {
    TPushModule.delAttrs(keys);
  }

  /// 清除所有属性
  static clearAttrs() {
    TPushModule.clearAttrs();
  }

  /*******************************************************************************************/
  /***                                 角标管理仅iOS                                         ***/
  /*******************************************************************************************/

  /// 同步角标到TPNS服务器，仅iOS
  /// @param badgeSum int类型
  static setBadge(badgeSum: number) {
    if (Platform.OS === 'ios') {
      TPushModule.setBadge(badgeSum);
    }
  }

  /// 设置应用角标，仅iOS
  /// @param badgeSum int类型
  static setAppBadge(badgeSum: number) {
    if (Platform.OS === 'ios') {
      TPushModule.setAppBadge(badgeSum);
    }
  }

  /***********************************************************************************************/
  /***                                     TPNS 事件                                       ***/
  /***********************************************************************************************/

  /// 添加事件
  static addListener(
    event: TPushEvent,
    callback: (data: Result) => void
  ): EmitterSubscription {
    const subscription = PushEventEmitter.addListener(event, callback);
    TPushModule.startListen(event);
    return subscription;
  }

  /// 移除事件
  static removeListener(event: TPushEvent, callback: (data: any) => void) {
    PushEventEmitter.removeListener(event, callback);
  }
  // 按名称移除所有事件
  static removeListeners(event: TPushEvent) {
    PushEventEmitter.removeAllListeners(event);
  }
  // 移除所有事件
  static removeAllListeners() {
    Object.values(TPushEvent).forEach((v) => {
      PushEventEmitter.removeAllListeners(v);
    });
  }

  static onRegister(
    callback: (data: TokenResult) => void
  ): EmitterSubscription {
    return TPush.addListener(TPushEvent.REGISTER, callback);
  }

  static onNoticeReceived(
    callback: (data: MessageResult) => void
  ): EmitterSubscription {
    return TPush.addListener(TPushEvent.NOTICE_RECEIVED, callback);
  }

  static onNoticeClicked(
    callback: (data: MessageResult) => void
  ): EmitterSubscription {
    return TPush.addListener(TPushEvent.NOTICE_CLICKED, callback);
  }

  static onMessageReceived(
    callback: (data: MessageResult) => void
  ): EmitterSubscription {
    return TPush.addListener(TPushEvent.MESSAGE_RECEIVED, callback);
  }

  /***********************************************************************************************/
  /***                                   仅 Android                                            ***/
  /***********************************************************************************************/

  /// 设置心跳间隔（单位毫秒，仅 Android）
  static setHeartbeat(heartbeat: number) {
    if (Platform.OS === 'android') {
      TPushModule.setHeartbeat(heartbeat);
    }
  }

  // 开启第三方推送（需在 register 前调用）
  static enableOtherPush(enable: boolean) {
    if (Platform.OS === 'android') {
      TPushModule.enableOtherPush(enable);
    }
  }

  // 设置小米平台
  // 推荐有账号体系的App使用（此接口保留之前的账号，只做增加操作，一个token下最多只能有10个账号超过限制会自动顶掉之前绑定的账号)
  static setMiPush(appId: string, appKey: string) {
    if (Platform.OS === 'android') {
      TPushModule.setMiPush(appId, appKey);
    }
  }

  // 设置魅族平台
  static setMzPush(appId: string, appKey: string) {
    if (Platform.OS === 'android') {
      TPushModule.setMzPush(appId, appKey);
    }
  }

  /**
   * 在调用 register 前调用以下代码：
   * 在应用首次启动时弹出通知栏权限请求窗口，应用安装周期内，提示弹窗仅展示一次。
   * 需 TPNS-OPPO 依赖包版本在 1.1.5.1 及以上支持，系统 ColorOS 5.0 以上有效。
   */
  static enableOppoNotification(enable: boolean) {
    if (Platform.OS === 'android') {
      TPushModule.enableOppoNotification(enable);
    }
  }

  // 设置OPPO
  static setOppoPush(appId: string, appKey: string) {
    if (Platform.OS === 'android') {
      TPushModule.setOppoPush(appId, appKey);
    }
  }
}
