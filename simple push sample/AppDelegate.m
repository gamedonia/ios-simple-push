//
//  AppDelegate.m
//  simple push sample
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "AppDelegate.h"

#import <GamedoniaSDK/Gamedonia.h>

#include <GamedoniaSDK/OpenUDID.h>
#include <GamedoniaSDK/GamedoniaPush.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    GDOptions *options = [[GDOptions alloc] init];
    options.push = true;
    
    NSString *apiKey = @"";
    NSString *secret = @"";
    
    if ( [apiKey isEqual: @""] || [secret isEqual: @""] ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Configuration error" message:@"Api key/Secret are empty. Check the README.txt for more info." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [Gamedonia initializeWithOptions:apiKey secret:secret apiServerUrl:@"http://api.gamedonia.com" apiVersion:@"v1" options:options];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    return YES;
}


- (void) applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:nil userInfo:userInfo];
}

-(void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [[Gamedonia push] registerDeviceToken:deviceToken];
}

-(void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to register for remote notifications.");
}
                                                                                                                    
                                                                                                                
@end
