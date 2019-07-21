#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [GMSServices provideAPIKey: @"AIzaSyCQCX67-q8zqbBwJXFpdSG3geAL0_9TOJI"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
