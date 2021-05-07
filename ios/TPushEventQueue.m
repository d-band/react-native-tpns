#import "TPushEventQueue.h"
#import <React/RCTUtils.h>

@implementation TPushEventQueue

+ (instancetype)sharedQueue {
    static TPushEventQueue *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self._eventCache = [NSMutableDictionary new];
        self._hasListen = [NSMutableDictionary new];
    }
    return self;
}

- (void) addEvent:(nonnull NSString *) event body:(nullable NSDictionary *) body {
    NSMutableArray *list = [self._eventCache objectForKey:event];
    if (!list) {
        list = [NSMutableArray new];
    }
    [list addObject:RCTNullIfNil(body)];
    [self._eventCache setObject:list forKey:event];
}

- (nullable NSNumber *) hasListen:(nonnull NSString *) event {
    return [self._hasListen objectForKey:event];
}

- (void) startListen:(nonnull NSString *) event {
    [self._hasListen setObject:@1 forKey:event];
}

- (nullable NSMutableArray *) getEvent:(nonnull NSString *) event {
    return [self._eventCache objectForKey:event];
}

- (void) removeEvent:(nonnull NSString *) event {
    [self._eventCache removeObjectForKey:event];
}
@end
