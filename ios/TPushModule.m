#import "TPushModule.h"
#import "TPushEventQueue.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// callback
#define EVENT_REGISTER @"TPushEventRegister"
#define EVENT_UNREGISTER @"TPushEventUnregister"
#define EVENT_NOTICE_RECEIVED @"TPushEventNoticeReceived"
#define EVENT_NOTICE_CLICKED @"TPushEventNoticeClicked"
#define EVENT_MESSAGE_RECEIVED @"TPushMessageReceived"
#define EVENT_SET_TAGS @"TPushEventSetTags"
#define EVENT_ADD_TAGS @"TPushEventAddTags"
#define EVENT_DEL_TAGS @"TPushEventDelTags"
#define EVENT_CLEAR_TAGS @"TPushEventClearTags"
#define EVENT_UPSERT_ACCOUNTS @"TPushEventUpsertAccounts"
#define EVENT_DEL_ACCOUNTS @"TPushEventDelAccounts"
#define EVENT_CLEAR_ACCOUNTS @"TPushEventClearAccounts"
#define EVENT_ADD_ATTRS @"TPushEventAddAttrs"
#define EVENT_SET_ATTRS @"TPushEventSetAttrs"
#define EVENT_DEL_ATTRS @"TPushEventDelAttrs"
#define EVENT_CLEAR_ATTRS @"TPushEventClearAttrs"
#define EVENT_SET_BADGE @"TPushEventSetBadge"

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

- (dispatch_queue_t)methodQueue
{
    NSDictionary *message = [[self.bridge launchOptions] objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSDictionary *body = @{@"code": @0, @"data": FormatMessage(message)};
        [[TPushEventQueue sharedQueue] addEvent:EVENT_NOTICE_CLICKED body:body];
    }
    return dispatch_queue_create("com.facebook.react.TPushModuleQueue", DISPATCH_QUEUE_SERIAL);
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
        EVENT_REGISTER,
        EVENT_UNREGISTER,
        EVENT_NOTICE_RECEIVED,
        EVENT_NOTICE_CLICKED,
        EVENT_MESSAGE_RECEIVED,
        EVENT_SET_TAGS,
        EVENT_ADD_TAGS,
        EVENT_DEL_TAGS,
        EVENT_CLEAR_TAGS,
        EVENT_UPSERT_ACCOUNTS,
        EVENT_DEL_ACCOUNTS,
        EVENT_CLEAR_ACCOUNTS,
        EVENT_ADD_ATTRS,
        EVENT_SET_ATTRS,
        EVENT_DEL_ATTRS,
        EVENT_CLEAR_ATTRS,
        EVENT_SET_BADGE
    ];
}

- (void)sendEvent:(nonnull NSString *)event body:(id)body {
    NSNumber *has = [[TPushEventQueue sharedQueue] hasListen:event];
    if (has) {
        [self sendEventWithName:event body:body];
    } else {
        [[TPushEventQueue sharedQueue] addEvent:event body:body];
    }
}

RCT_EXPORT_METHOD(startListen:(NSString *)event)
{
    [[TPushEventQueue sharedQueue] startListen:event];
    NSMutableArray *list = [[TPushEventQueue sharedQueue] getEvent:event];
    if (list && list.count) {
        for (id body in list) {
            [self sendEventWithName:event body:body];
        }
    }
    [[TPushEventQueue sharedQueue] removeEvent:event];
}

/**********************************************************************************************/
/***                                   TPNS??????????????????debug??????                               ***/
/**********************************************************************************************/

/// ?????????????????????????????????????????????startXg????????????????????????
RCT_EXPORT_METHOD(configureClusterDomainName:(NSString *)domainName)
{
    [[XGPush defaultManager] configureClusterDomainName:domainName];
}

/// ??????????????????
RCT_EXPORT_METHOD(register:(NSString *)appId andSequenceNum:(NSString *)appKey)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[XGPush defaultManager] startXGWithAccessID:(uint32_t)[appId longLongValue] accessKey:appKey delegate:self];
    });
}

/// ??????????????????
RCT_EXPORT_METHOD(unregister)
{
    [[XGPush defaultManager] stopXGNotification];
}

/// debug??????
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

/**********************************************************************************************/
/***                                   ??????????????????1.0.8+                                     ***/
/**********************************************************************************************/

/// ?????????????????????
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

/// ?????????????????????
RCT_EXPORT_METHOD(delAccounts:(nonnull NSArray<NSNumber *> *)types)
{
    NSSet *keys = [NSSet setWithArray:types];
    [[XGPushTokenManager defaultTokenManager] delAccountsByKeys:keys];
}

/// ??????????????????
RCT_EXPORT_METHOD(clearAccounts)
{
    [[XGPushTokenManager defaultTokenManager] clearAccounts];
}

/***********************************************************************************************/
/***                                   ??????????????????1.0.8+                                      ***/
/***********************************************************************************************/

/// ????????????
RCT_EXPORT_METHOD(addTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] appendTags:tags];
}

/// ????????????(???????????????????????????)
RCT_EXPORT_METHOD(setTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] clearAndAppendTags:tags];
}

/// ??????????????????
RCT_EXPORT_METHOD(delTags:(nonnull NSArray<NSString *> *)tags)
{
    [[XGPushTokenManager defaultTokenManager] delTags:tags];
}

/// ??????????????????
RCT_EXPORT_METHOD(clearTags)
{
    [[XGPushTokenManager defaultTokenManager] clearTags];
}

/***********************************************************************************************/
/***                                             ??????????????????                                  ***/
/***********************************************************************************************/

/// ????????????
RCT_EXPORT_METHOD(addAttrs:(nonnull NSDictionary<NSString *,NSString *> *)attrs)
{
    [[XGPushTokenManager defaultTokenManager] upsertAttributes:attrs];
}

/// ????????????(???????????????????????????)
RCT_EXPORT_METHOD(setAttrs:(nonnull NSDictionary<NSString *,NSString *> *)attrs)
{
    [[XGPushTokenManager defaultTokenManager] clearAndAppendAttributes:attrs];
}

/// ????????????
RCT_EXPORT_METHOD(delAttrs:(nonnull NSArray<NSString *> *)keys)
{
    NSSet *set = [NSSet setWithArray:keys];
    [[XGPushTokenManager defaultTokenManager] delAttributes:set];
}

/// ????????????
RCT_EXPORT_METHOD(clearAttrs)
{
    [[XGPushTokenManager defaultTokenManager] clearAttributes];
}

/***********************************************************************************************/
/***                                      ????????????                                            ***/
/***********************************************************************************************/


// ???????????????TPNS?????????
// @param badgeSum ?????????
RCT_EXPORT_METHOD(setBadge:(int)badgeSum)
{
    [[XGPush defaultManager] setBadge:badgeSum];
}

// ??????????????????
// @param badgeSum ?????????
// ???????????????????????????????????????TPNS?????????????????????
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
    [self sendEvent:EVENT_UNREGISTER body:result];
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken xgToken:(NSString *)xgToken error:(NSError *)error {
    if (error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys: @-1, @"code", xgToken, @"token", error.description, @"content", nil];
        [self sendEvent:EVENT_REGISTER body:result];
    } else {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys: @0, @"code", xgToken, @"token", @"Success", @"content", nil];
        [self sendEvent:EVENT_REGISTER body:result];
        [[XGPushTokenManager defaultTokenManager] setDelegate:self];
    }
}

/// ??????????????????
/// @param response ??????iOS 10+/macOS 10.14+??????UNNotificationResponse???????????????????????????NSDictionary
- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    NSDictionary *message = nil;
    if ([response isKindOfClass:[UNNotificationResponse class]]) {
        /// iOS10+???????????????
        message = ((UNNotificationResponse *)response).notification.request.content.userInfo;
    } else if ([response isKindOfClass:[NSDictionary class]]) {
        /// <IOS10???????????????
        message = response;
    }
    NSDictionary *result = @{@"code": @0, @"data": FormatMessage(message)};
    completionHandler();
    [self sendEvent:EVENT_NOTICE_CLICKED body:result];
}

/// ???????????????????????????
/// @param notification ????????????(???2?????????NSDictionary???UNNotification??????????????????????????????)
/// @note ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
/// ???????????????????????????xg????????????msgtype???1?????????????????????msgtype???2?????????????????????
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
        /// ????????????????????????
        [self sendEvent:EVENT_NOTICE_RECEIVED body:result];
    } else {
          /// ????????????
        [self sendEvent:EVENT_MESSAGE_RECEIVED body:result];
    }
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_SET_BADGE body:result];
}


#pragma mark - XGPushTokenManagerDelegate

- (void)xgPushDidUpsertAccountsByDict:(nonnull NSDictionary *)accountsDict error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_UPSERT_ACCOUNTS body:result];
}

- (void)xgPushDidDelAccountsByKeys:(nonnull NSSet<NSNumber *> *)accountsKeys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_DEL_ACCOUNTS body:result];
}

- (void)xgPushDidClearAccountsError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_CLEAR_ACCOUNTS body:result];
}

- (void)xgPushDidAppendTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_ADD_TAGS body:result];
}

- (void)xgPushDidClearAndAppendTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_SET_TAGS body:result];
}

- (void)xgPushDidDelTags:(nonnull NSArray<NSString *> *)tags error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_DEL_TAGS body:result];
}

- (void)xgPushDidClearTagsError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_CLEAR_TAGS body:result];
}

- (void)xgPushDidUpsertAttributes:(nonnull NSDictionary *)attributes invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_ADD_ATTRS body:result];
}

- (void)xgPushDidClearAndAppendAttributes:(nonnull NSDictionary *)attributes invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_SET_ATTRS body:result];
}

- (void)xgPushDidDelAttributeKeys:(nonnull NSSet *)attributeKeys invalidKeys:(nullable NSArray *)keys error:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_DEL_ATTRS body:result];
}

- (void)xgPushDidClearAttributesWithError:(nullable NSError *)error {
    NSDictionary *result = @{ @"code":@0, @"content":@"Success" };
    if (error) {
        result = @{ @"code":@-1, @"content":error.description };
    }
    [self sendEvent:EVENT_CLEAR_ATTRS body:result];
}
@end
