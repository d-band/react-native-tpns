#import <Foundation/Foundation.h>


@interface TPushEventQueue : NSObject

+ (nonnull instancetype) sharedQueue;

@property NSMutableDictionary<NSString *, NSMutableArray *> * _Nullable _eventCache;
@property NSMutableDictionary<NSString *, NSNumber *> * _Nullable _hasListen;

- (void) addEvent:(nonnull NSString *) event body:(nullable NSDictionary *) body;
- (nullable NSNumber *) hasListen:(nonnull NSString *) event;
- (void) startListen:(nonnull NSString *) event;
- (nullable NSMutableArray *) getEvent:(nonnull NSString *) event;
- (void) removeEvent:(nonnull NSString *) event;

@end
