//
//  FakeServer.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeServer : NSObject

#pragma mark - Fake Server Sigleton Manager
+ (instancetype)networkManager;     // sigleton




#pragma mark - Fake Server APIs
- (RLMArray<AptDataSet *> *)getAptInfosWithMaxLat:(CGFloat)maxLat
                                       withMaxLng:(CGFloat)maxLng
                                       withMinLat:(CGFloat)minLat
                                       withMinLng:(CGFloat)minLng;


@end
