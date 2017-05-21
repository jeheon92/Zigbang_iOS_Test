//
//  AppDelegate.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.0f];   // LaunchScreen 1sec Delay
    
    [GMSServices provideAPIKey:GOOGLE_API_KEY];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:236/255.0 green:143/255.0 blue:58/255.0 alpha:1.0f]];  // SVProgressHUD Color setting
//    [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];  // SVProgressHUD Color setting
    [SVProgressHUD setRingNoTextRadius:18.0f];
    
    return YES;
}


@end
