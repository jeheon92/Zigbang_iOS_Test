//
//  DataCenter.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

+ (instancetype)sharedInstance {
    
    static DataCenter *data;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[DataCenter alloc] init];
    });
    
    return data;
}

@end
