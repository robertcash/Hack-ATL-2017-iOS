//
//  AppDelegate.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/1/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)registerForRemoteNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
        [[HackATLAPI sharedManager] sendDeviceToken:token completionHandler:^(BOOL error) {
            if (error) {
                NSLog(@"send device token fail");
            }
            else {
                NSLog(@"send device token success");
            }
        }];
        return;
    }
    
    [[HackATLAPI sharedManager] createUser:[[NSUUID UUID] UUIDString] completionHandler:^(BOOL error) {
        if (error) {
            NSLog(@"user creation failed");
        }
        else {
            NSLog(@"user creation success");
            [[HackATLAPI sharedManager] sendDeviceToken:token completionHandler:^(BOOL error) {
                if (error) {
                    NSLog(@"send device token fail");
                }
                else {
                    NSLog(@"send device token success");
                }
            }];
        }
    }];
    
    NSLog(@"token: %@", token);
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"No push notifications enabled.");
    [self getUserId];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"New Message" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        topWindow.hidden = YES;
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)getUserId {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
        return;
    }
    [[HackATLAPI sharedManager] createUser:[[NSUUID UUID] UUIDString] completionHandler:^(BOOL error) {
        if (error) {
            NSLog(@"user creation failed");
        }
        else {
            NSLog(@"user creation success");
        }
    }];
}

@end
