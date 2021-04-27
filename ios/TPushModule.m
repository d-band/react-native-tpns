#import "TPushModule.h"
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// callback
// DeviceToken回调
#define OnRegisteredDeviceToken  @"onRegisteredDeviceToken"
// 注册推送服务成功回调
#define OnRegisteredDone @"onRegisteredDone"
// 注销推送服务回调
#define UnRegistered @"unRegistered"
// 收到通知消息回调
#define OnReceiveNotificationResponse @"onReceiveNotificationResponse"
// 收到透传、静默消息回调
#define OnReceiveMessage @"onReceiveMessage"
// 通知点击回调
#define ClickAction  @"xgPushClickAction"
// 设置角标回调
#define DidSetBadge @"xgPushDidSetBadge"
// 添加或更新账号
#define DidUpsertAccounts @"xgPushDidUpsertAccounts"
// 删除账号
#define DidDelAccounts @"xgPushDidDelAccounts"
// 清空账号
#define DidClearAccounts @"xgPushDidClearAccounts"
// 添加标签
#define DidAddTags @"xgPushDidAddTags"
// 更新标签
#define DidSetTags @"xgPushDidSetTags"
// 删除标签
#define DidDelTags @"xgPushDidDelTags"
// 清空标签
#define DidClearTags @"xgPushDidClearTags"
// 添加属性
#define DidAddAttrs @"xgPushDidAddAttrs"
// 更新属性
#define DidSetAttrs @"xgPushDidSetAttrs"
// 删除属性
#define DidDelAttrs @"xgPushDidDelAttrs"
// 清空属性
#define DidClearAttrs @"xgPushDidClearAttrs"

@implementation TPushModule

RCT_EXPORT_MODULE(TPushModule);

static NSDictionary *FormatMessage(NSDictionary *message)
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (message == nil) {
        return data;
    }
    NSDictionary *xg = message[@"xg"];
    data[@"custom"] = message[@"custom"];
    if (![xg isEqual:[NSNull null]]) {
        data[@"msgId"] = xg[@"msgid"];
        data[@"pushChannel"] = xg[@"pushChannel"];
        data[@"collapseId"] = xg[@"tpnsCollapseId"];
        data[@"templateId"] = xg[@"templateId"];
        data[@"traceId"] = xg[@"traceId"];
        data[@"msgType"] = xg[@"msgtype"];
        data[@"groupId"] = xg[@"groupId"];
        data[@"targetType"] = xg[@"targettype"];
        data[@"pushTime"] = xg[@"pushTime"];
    }
    NSDictionary *aps = message[@"aps"];
    if (![aps isEqual:[NSNull null]]) {
        NSDictionary *alert = aps[@"alert"];
        if (![alert isEqual:[NSNull null]]) {
            data[@"title"] = alert[@"title"];
            data[@"body"] = alert[@"body"];
            data[@"subtitle"] = alert[@"subtitle"];
        }
        data[@"badge"] = aps[@"badge"];
        data[@"sound"] = aps[@"sound"];
        data[@"category"] = aps[@"category"];
        data[@"badgeType"] = aps[@"badge_type"];
        data[@"mutableContent"] = aps[@"mutable-content"];
    }
    return data;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
        OnRegisteredDeviceToken,
        OnRegisteredDone,
        UnRegistered,
        OnReceiveNotificationResponse,
        OnReceiveMessage,
        ClickAction,
        DidSetBadge,
        DidUpsertAccounts,
        DidDelAccounts,
        DidClearAccounts,
        DidAddTags,
        DidSetTags,
        DidDelTags,
        DidClearTags,
        DidAddAttrs,
        DidSetAttrs,
        DidDelAttrs,
        DidClearAttrs
    ];
}

/***********************************************************************************************
***                                   TPNS注册反注册和debug接口                                 ***
***********************************************************************************************/

/// 集群域名配置（非广州集群需要在startXg之前调用此函数）
RCT_EXPORT_METHOD(configureClusterDomainName:(NSString *)domainName)
{
    [[XGPush defaultManager] configureClusterDomainName:domainName];
}

/// 注册推送服务
RCT_EXPORT_METHOD(register:(NSString *)appId andSequenceNum:(NSString *)appKey)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[XGPush defaultManager] startXGWithAccessID:(uint32_t)[appId longLongValue] accessKey:appKey delegate:self];
    });
}

/// 注销推送服务
RCT_EXPORT_METHOD(unregister)
{
    [[XGPush defaultManager] stopXGNotification];
}

/// debug模式
RCT_EXPORT_METHOD(enableDebug:(BOOL)enable)
{
    [[XGPush defaultManager] setEnableDebug:enable];
}

RCT_EXPORT_METHOD(getToken:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *token = [[XGPushTokenManager defaultTokenManager] xgTokenString];
    resolve(token);
}

/***********************************************************************************************
***                                   账号相关接口1.0.8+                                       ***
***********************************************************************************************/

/// 添加或更新账号
RCT_EXPORT_METHOD(upsertAccounts:(nonnull NSArray<NSDictionary *> *)accounts)
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (id item in accounts) {
        NSString *name = item[@"name"];
        NSNumber *type = item[@"type"];
        dict[type] = name;
    }
    [[XGPushTokenManager defaultTokenManager] upsertAccountsByDict:dict];
}

/// 按类型删除账号
RCT_EXPORT_METHOD(delAccounts:(nonnull NSArray<NSNumber *> *)types)
{
    NSSet *keys = [NSSet setWithArray:types];
    [[XGPushTokenManager defaultTokenManager] delAccountsByKeys:keys];
}

/// 删除所有账号
RCT_EXPORT_METHOD(clearAccounts)
{
    [[XGPushTokenManager defaultTokenManager] clearAccounts];
}

/***********************************************************************************************
***                                   标签相关接口1.0.8+                                       ***
***********************************************************************************************/

/// 追加标签
RCT_EXPORT_METHOD(addTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] appendTags:tags];
}

/// 覆盖标签(清除所有标签再追加)
RCT_EXPORT_METHOD(setTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] clearAndAppendTags:tags];
}

/// 删除指定标签
RCT_EXPORT_METHOD(delTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] delTags:tags];
}

/// 清除全部标签
RCT_EXPORT_METHOD(clearTags)
{
    [[XGPushTokenManager defaultTokenManager] clearTags];
}

/***********************************************************************************************
***                                             属性相关接口                                             ***
***********************************************************************************************/

/// 添加属性
RCT_EXPORT_METHOD(addAttrs:(nonnull NSDictionary<NSString *,NSString *> *)attrs)
{
    [[XGPushTokenManager defaultTokenManager] upsertAttributes:attrs];
}

/// 覆盖属性(清除所有标签再追加)
RCT_EXPORT_METHOD(setAttrs:(nonnull NSDictionary<NSString *,NSString *> *)attrs)
{
    [[XGPushTokenManager defaultTokenManager] clearAndAppendAttributes:attrs];
}

/// 删除属性
RCT_EXPORT_METHOD(delAttrs:(nonnull NSArray<NSString *> *)keys)
{
    NSSet *set = [NSSet setWithArray:keys];
    [[XGPushTokenManager defaultTokenManager] delAttributes:set];
}

/// 清空属性
RCT_EXPORT_METHOD(clearAttrs)
{
    [[XGPushTokenManager defaultTokenManager] clearAttributes];
}

/***********************************************************************************************
***                                      角标管理                                              ***
***********************************************************************************************/


// 同步角标到TPNS服务器
// @param badgeSum 角标值
RCT_EXPORT_METHOD(setBadge:(int)badgeSum)
{
    [[XGPush defaultManager] setBadge:badgeSum];
}

// 设置应用角标
// @param badgeSum 角标值
// 使用场景：一般是角标同步到TPNS成功后进行调用
RCT_EXPORT_METHOD(setAppBadge:(int)badgeSum)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeSum];
    });
}

#pragma mark - XGPushDelegate

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:UnRegistered body:result];
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken xgToken:(NSString *)xgToken error:(NSError *)error {
    if (error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys: @-1, @"code", xgToken, @"xgToken", error.description, @"content", nil];
        [self sendEventWithName:OnRegisteredDeviceToken body:result];
    } else {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys: @0, @"code", xgToken, @"xgToken", @"Success", @"content", nil];
        [self sendEventWithName:OnRegisteredDone body:result];
        [[XGPushTokenManager defaultTokenManager] setDelegate:self];
    }
}

/// 统一点击回调
/// @param response 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary
- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    NSDictionary *message = nil;
    if ([response isKindOfClass:[UNNotificationResponse class]]) {
        /// iOS10+消息体获取
        message = ((UNNotificationResponse *)response).notification.request.content.userInfo;
    } else if ([response isKindOfClass:[NSDictionary class]]) {
        /// <IOS10消息体获取
        message = response;
    }
    NSDictionary *result = @{@"code": @0, @"data": FormatMessage(message)};
    completionHandler();
    [self sendEventWithName:ClickAction body:result];
}

/// 统一接收消息的回调
/// @param notification 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)
/// @note 此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）
/// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息msgtype为2则代表静默消息
- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler {
    NSDictionary *message = nil;
    if ([notification isKindOfClass:[UNNotification class]]) {
        message = ((UNNotification *)notification).request.content.userInfo;
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    } else if ([notification isKindOfClass:[NSDictionary class]]) {
        message = notification;
        completionHandler(UIBackgroundFetchResultNewData);
    }
    NSDictionary *data = FormatMessage(message);
    NSNumber *msgType = data[@"msgType"];
    NSDictionary *result = @{@"code": @0, @"data": data};
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && msgType.integerValue == 1) {
        /// 前台收到通知消息
        [self sendEventWithName:OnReceiveNotificationResponse body:result];
    } else {
          /// 静默消息
        [self sendEventWithName:OnReceiveMessage body:result];
    }
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidSetBadge body:result];
}


#pragma mark - XGPushTokenManagerDelegate

- (void)xgPushDidUpsertAccountsByDict:(nonnull NSDictionary *)accountsDict error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidUpsertAccounts body:result];
}

- (void)xgPushDidDelAccountsByKeys:(nonnull NSSet<NSNumber *> *)accountsKeys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidDelAccounts body:result];
}

- (void)xgPushDidClearAccountsError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidClearAccounts body:result];
}

- (void)xgPushDidAppendTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidAddTags body:result];
}

- (void)xgPushDidClearAndAppendTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidSetTags body:result];
}

- (void)xgPushDidDelTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidDelTags body:result];
}

- (void)xgPushDidClearTagsError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidClearTags body:result];
}

- (void)xgPushDidUpsertAttributes:(nonnull NSDictionary *)attributes invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidAddAttrs body:result];
}

- (void)xgPushDidClearAndAppendAttributes:(nonnull NSDictionary *)attributes invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidSetAttrs body:result];
}

- (void)xgPushDidDelAttributeKeys:(nonnull NSSet *)attributeKeys invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidDelAttrs body:result];
}

- (void)xgPushDidClearAttributesWithError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEventWithName:DidClearAttrs body:result];
}
@end
