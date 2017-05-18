//
//  JHDataSet.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "JHDataSet.h"

#pragma mark - Apartment Data Set
@implementation AptDataSet

+ (NSString *)primaryKey {
    return @"id";
}

@end


#pragma mark - Address Data Set
@implementation AddressDataSet

+ (NSString *)primaryKey {
    return @"id";
}

@end


#pragma mark - Marker Data Set
@implementation MarkerDataSet

+ (NSString *)primaryKey {
    return @"id";
}

@end
