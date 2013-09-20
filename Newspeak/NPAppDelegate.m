//
//  NPAppDelegate.m
//  Newspeak
//
//  Copyright (C) 2013 Jahn Bertsch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the License.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "AFNetworking.h" // for AFNetworkActivityIndicatorManager
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"
#import "CBIntrospect.h"
#import "TestFlight.h"
#import "NPAppDelegate.h"
#import "NPCoreDataSingleton.h"
#import "NPIncrementalStore.h"
#import "NPAPIClient.h"
#import "UIColor+NPColor.h"

#if TARGET_IPHONE_SIMULATOR
#import "CBIntrospect.h"
#endif

@implementation NPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setup networking
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:(8 * 1024 * 1024) diskCapacity:(20 * 1024 * 1024) diskPath:nil];

    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    // setup coredata
    [NPCoreDataSingleton sharedInstance].useCustomStore = YES;
    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[[NPCoreDataSingleton sharedInstance].persistentStoreCoordinator addPersistentStoreWithType:[NPIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
    [[NPCoreDataSingleton sharedInstance] addDefaultSQLiteStoreTo:incrementalStore.backingPersistentStoreCoordinator];

    [self customizeAppearance];

#if TARGET_IPHONE_SIMULATOR
    [[CBIntrospect sharedIntrospector] start];
    [CBIntrospect setIntrospectorKeyName:@"newspeak"];
#else
    // register at http://testflightapp.com/ to obtain your testflight token
    // [TestFlight takeOff:@"YOUR_TESTFLIGHT_TOKEN_HERE"];
#endif

    return YES;
}

- (void)customizeAppearance
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        [[UISlider appearance] setThumbTintColor:[UIColor whiteColor]];
        [[UISlider appearance] setMinimumTrackTintColor:[UIColor grayColor]];
        [[UISlider appearance] setMaximumTrackTintColor:[UIColor whiteColor]];
        [[UISwitch appearance] setOnTintColor:[UIColor grayColor]];
        [[UISwitch appearance] setThumbTintColor:[UIColor whiteColor]];
        [[UIProgressView appearance] setProgressTintColor:[UIColor lightGrayColor]];
        [[UIProgressView appearance] setTrackTintColor:[UIColor whiteColor]];
        [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor grayColor]];
    } else {
        // ios 7
        self.window.tintColor = [UIColor defaultTintColor];
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]}];
        [[UISlider appearance] setMinimumTrackTintColor:[UIColor darkGrayColor]];
    }
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUInteger deviceTokenLength = [deviceToken length];
    NSMutableString *deviceTokenString = [NSMutableString stringWithCapacity:(deviceTokenLength * 2)];
    const unsigned char *deviceTokenBytes = [deviceToken bytes];

    for (NSInteger idx = 0; idx < deviceTokenLength; ++idx) {
        [deviceTokenString appendFormat:@"%02x", deviceTokenBytes[idx]];
    }

    DLog(@"deviceTokenString=%@", deviceTokenString);

    // register device
    NSManagedObjectContext *managedObjectContext = [NPCoreDataSingleton sharedInstance].managedObjectContext;
    [managedObjectContext performBlock:^{
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:managedObjectContext];
        [managedObject setValue:deviceTokenString forKey:@"deviceToken"];
        [managedObject setValue:@"user" forKey:@"username"];
        NSError *error;

        if (![managedObjectContext save:&error]) {
            DLog(@"did not save device token. error=%@", error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Could not register device", @"in status message")];
    DLog(@"Failed to get device token, error: %@", error);
    [TestFlight passCheckpoint:@"device registration failed"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"didReceiveRemoteNotification:fetchCompletionHandler: %@", userInfo[@"aps"][@"alert"][@"body"]);
    [TestFlight passCheckpoint:@"received remote notification"];
    [self pushNotificationReceived:userInfo];
}

- (void)pushNotificationReceived:(NSDictionary *)userInfo
{
    NSString *message = userInfo[@"aps"][@"alert"][@"body"];
    NSString *user = userInfo[@"subscriber"];

    [[[UIAlertView alloc] initWithTitle:user message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
