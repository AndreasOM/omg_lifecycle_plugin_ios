#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

// Godot 4.7 requires services to conform to UIWindowSceneDelegate (ios 13.0+);
// Godot 4.5 only requires UIApplicationDelegate and ignores the extra protocol.
// The 4.5 build targets min-iOS 12.0, so silence the availability warning for
// the conformance list.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
@interface PluginApplicationDelegate : NSObject <UIApplicationDelegate, UIWindowSceneDelegate>

+ (instancetype)shared;

// UIScene lifecycle: forwarded by the engine from Godot 4.7 on, never called on 4.5.
- (void)sceneDidBecomeActive:(UIScene *)scene API_AVAILABLE(ios(13.0));
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0));
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts API_AVAILABLE(ios(13.0));

@end
#pragma clang diagnostic pop
