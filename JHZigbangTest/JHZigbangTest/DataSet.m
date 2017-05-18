//
//  JHDataSet.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "DataSet.h"

#pragma mark - Apartment Data Set
@implementation AptDataSet

+ (NSString *)primaryKey {
    return @"id";
}

+ (AptDataSet *)makeAptDataWithDic:(NSDictionary *)aptDic {
    //realm transaction 속에서 불림
    
    AptDataSet *aptData;
    
    // PK값으로 기존 데이터 있는지 확인
    NSInteger aptID = [[aptDic objectForKey:@"id"] integerValue];

    if ([AptDataSet objectsWhere:[NSString stringWithFormat:@"id==%ld", aptID]].count != 0) {
        aptData = [AptDataSet objectsWhere:[NSString stringWithFormat:@"id==%ld", aptID]][0];
    } else {
        aptData = [[AptDataSet alloc] init];
        aptData.address = [[AddressDataSet alloc] init];
        aptData.marker = [[MarkerDataSet alloc] init];

        aptData.id = aptID;
        aptData.address.id = aptID;
        aptData.marker.id = aptID;
    }
    
    aptData.name = [aptDic objectForKey:@"name"];
    aptData.score = [[aptDic objectForKey:@"score"] doubleValue];
    aptData.image = [aptDic objectForKey:@"image"];
    aptData.brand = [aptDic objectForKey:@"brand"];
    aptData.households = [[aptDic objectForKey:@"households"] integerValue];
    aptData.buildDate = [aptDic objectForKey:@"buildDate"];
    aptData.price = [[aptDic objectForKey:@"price"] integerValue];
    aptData.floorArea = [[aptDic objectForKey:@"floorArea"] doubleValue];
    
    // Address Data
    aptData.address.sido = [aptDic objectForKey:@"sido"];
    aptData.address.gugun = [aptDic objectForKey:@"gugun"];
    aptData.address.dong = [aptDic objectForKey:@"dong"];
    aptData.address.bunji = [aptDic objectForKey:@"bunji"];

    // Marker Data
    aptData.marker.lat = [[aptDic objectForKey:@"lat"] doubleValue];
    aptData.marker.lng = [[aptDic objectForKey:@"lng"] doubleValue];
    aptData.marker.smallBase = [[[[aptDic objectForKey:@"marker"] objectForKey:@"small"] objectForKey:@"xxxh"] objectForKey:@"base"];
    aptData.marker.smallSelected = [[[[aptDic objectForKey:@"marker"] objectForKey:@"small"] objectForKey:@"xxxh"] objectForKey:@"selected"];
    aptData.marker.largeBase = [[[[aptDic objectForKey:@"marker"] objectForKey:@"large"] objectForKey:@"xxxh"] objectForKey:@"base"];
    aptData.marker.largeSelected = [[[[aptDic objectForKey:@"marker"] objectForKey:@"large"] objectForKey:@"xxxh"] objectForKey:@"selected"];
    
    return aptData;
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
