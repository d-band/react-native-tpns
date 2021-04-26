#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import <TPNS-iOS/XGPush.h>
#import <TPNS-iOS/XGPushPrivate.h>

@interface TPushModule : RCTEventEmitter <RCTBridgeModule, XGPushDelegate, XGPushTokenManagerDelegate>

@end
