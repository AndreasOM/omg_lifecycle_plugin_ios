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

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog( @"OMGLifecyclePlugin_iOS - applicationDidBecomeActive" );
	OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
	if( plugin ) {
		plugin->applicationDidBecomeActive();
	}
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
	NSLog( @"OMGLifecyclePlugin_iOS - didFinishLaunchingWithOptions" );

	[launchOptions enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
		NSLog(@"%@ => %@", key, value);
		if( key == UIApplicationLaunchOptionsURLKey ) {
			OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
			if( plugin ) {
				plugin->openURL( value );
			} else {
				OMGLifecyclePlugin_iOS::pEarlyOpenURL = [value copy];
			}
		}
	}];

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

	OMGLifecyclePlugin_iOS* plugin = OMGLifecyclePlugin_iOS::get_singleton();
	if( plugin ) {
		plugin->openURL( url );
	}
	return true;
}

@end
