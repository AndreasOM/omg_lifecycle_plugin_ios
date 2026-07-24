#import "godot_plugin_application_delegate.h"

//#import "platform/ios/godot_app_delegate.h"
// Godot 4.4 -> 4.5
#import "drivers/apple_embedded/godot_app_delegate.h"

#import "godot_plugin_implementation.h"

struct PluginApplicationDelegateInitializer {
	PluginApplicationDelegateInitializer() {
		NSLog(@"OMGLifecyclePlugin_iOS - PluginApplicationDelegateInitializer - Constructor");

//		[GodotApplicationDelegate addService:[PluginApplicationDelegate shared]];
// Godot 4.4 -> 4.5
		[GDTApplicationDelegate addService:[PluginApplicationDelegate shared]];
	}
};
static PluginApplicationDelegateInitializer initializer;

@interface PluginApplicationDelegate ()

- (void)handleURL:(NSURL *)url;

@end

@implementation PluginApplicationDelegate

- (instancetype)init {
	NSLog(@"OMGLifecyclePlugin_iOS - PluginApplicationDelegate - init");
	self = [super init];

	if (self) {
		// init data here
	}

	return self;
}

+ (instancetype)shared {
	NSLog(@"OMGLifecyclePlugin_iOS - PluginApplicationDelegate - shared");
	static PluginApplicationDelegate *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[PluginApplicationDelegate alloc] init];
	});
	return sharedInstance;
}

// Before godot_plugin_init has created the singleton, URLs are stashed and
// drained by the singleton's constructor.
- (void)handleURL:(NSURL *)url {
	OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
	if( plugin ) {
		plugin->openURL( url );
	} else {
		OMGLifecyclePlugin_iOS::pEarlyOpenURL = [url copy];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog( @"OMGLifecyclePlugin_iOS - applicationDidBecomeActive" );
	OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
	if( plugin ) {
		plugin->applicationDidBecomeActive();
	}
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
	NSLog( @"OMGLifecyclePlugin_iOS - didFinishLaunchingWithOptions" );

	// Under the UIScene lifecycle (Godot 4.7+) the launch URL is not in
	// launchOptions; it arrives via scene:willConnectToSession:options:.
	NSURL* url = launchOptions[UIApplicationLaunchOptionsURLKey];
	if( url ) {
		[self handleURL:url];
	}

	return true;
}


- (void) applicationDidFinishLaunching:(UIApplication *) application
{
	NSLog( @"OMGLifecyclePlugin_iOS - applicationDidFinishLaunching" );
}

- (BOOL) application:(UIApplication *) app 
			openURL:(NSURL *)url
			options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
	NSLog( @"OMGLifecyclePlugin_iOS - application openURL - 2" );

	[self handleURL:url];
	return true;
}

// UIScene lifecycle: Godot 4.7+ exports enable UIApplicationSceneManifest,
// which makes UIKit skip the UIApplicationDelegate callbacks above. The engine
// forwards these scene callbacks to registered services (never both sets).

- (void)sceneDidBecomeActive:(UIScene *)scene {
	NSLog( @"OMGLifecyclePlugin_iOS - sceneDidBecomeActive" );
	OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
	if( plugin ) {
		plugin->applicationDidBecomeActive();
	}
}

// Cold launch: the launch URL arrives here, not in didFinishLaunchingWithOptions.
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
	NSLog( @"OMGLifecyclePlugin_iOS - scene willConnectToSession" );
	for( UIOpenURLContext* context in connectionOptions.URLContexts ) {
		[self handleURL:context.URL];
	}
}

// Warm deep-link while running.
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
	NSLog( @"OMGLifecyclePlugin_iOS - scene openURLContexts" );
	for( UIOpenURLContext* context in URLContexts ) {
		[self handleURL:context.URL];
	}
}

@end
