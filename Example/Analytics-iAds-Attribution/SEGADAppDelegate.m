#import "SEGADAppDelegate.h"

#if __has_include(<Analytics/SEGAnalytics.h>)
#import <Analytics/SEGAnalytics.h>
#else
#import <Segment/SEGAnalytics.h>
#endif

#import "SEGADTracker.h"

@implementation SEGADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize the analytics client as you would normally.
    // https://segment.com/segment-mobile/sources/ios/settings/keys
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"H18ZaUENQGcg4t7mJnYt1XrgG5vNkULh"];

    // Configure the client with the iAD middleware.
    configuration.sourceMiddleware = @[ [SEGADTracker middleware] ];
    configuration.trackApplicationLifecycleEvents = YES;
    configuration.flushAt = 1;
    [SEGAnalytics setupWithConfiguration:configuration];
    [SEGAnalytics debug:YES];
    
    [[SEGAnalytics sharedAnalytics] track:@"Item Purchased"
                               properties:@{ @"item": @"Sword of Heracles", @"revenue": @2.95 }];
    
    [[SEGAnalytics sharedAnalytics] track:@"Testing Kochava"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
