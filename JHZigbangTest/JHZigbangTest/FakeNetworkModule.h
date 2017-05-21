//
//  FakeNetworkCenter.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 19..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeNetworkModule : NSObject

#pragma mark - Fake Network Sigleton Manager
+ (instancetype)networkManager;     // sigleton


#pragma mark - Fake Network Methods
- (void)getAptInfosWithFarRightLat:(CGFloat)frLat      // FarRight : Top Right, corner of the mapView camera
                   withFarRightLng:(CGFloat)frLng
                   withNearLeftLat:(CGFloat)nlLat      // NearLeft : Bottom Left, corner of the mapView camera
                   withNearLeftLng:(CGFloat)nlLng
               withCompletionBlock:(void (^)(RLMArray<AptDataSet *> *aptList))completionBlock;

- (void)getAptListWithCompletionBlock:(void (^)(RLMArray<AptDataSet *> *aptList))completionBlock;

@end
