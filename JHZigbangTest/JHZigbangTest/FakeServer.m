//
//  FakeServer.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "FakeServer.h"

@interface FakeServer ()

@property (nonatomic) NSDictionary *jsonData;

@end


@implementation FakeServer

#pragma mark - Fake Server Sigleton Manager
+ (instancetype)networkManager {
    
    static FakeServer *server;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[FakeServer alloc] init];
    });
    
    return server;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.jsonData = [self JSONFromFile];
    }
    return self;
}

- (NSDictionary *)JSONFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mobile" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}





#pragma mark - Fake Server APIs
- (RLMArray<AptDataSet *> *)getAptInfosWithMaxLat:(CGFloat)maxLat
                                       withMaxLng:(CGFloat)maxLng
                                       withMinLat:(CGFloat)minLat
                                       withMinLng:(CGFloat)minLng {
    
    
    return [[RLMArray alloc] initWithObjectClassName:@"AptDataSet"];
}



@end



