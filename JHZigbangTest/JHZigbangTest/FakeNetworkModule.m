//
//  FakeNetworkCenter.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 19..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "FakeNetworkModule.h"

@interface FakeNetworkModule ()

@property (nonatomic) RLMArray<AptDataSet *> *jsonAptDataArr;

@end


@implementation FakeNetworkModule

#pragma mark - Fake Network Sigleton Manager & Initial Setting Methods
+ (instancetype)networkManager {
    
    static FakeNetworkModule *network;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[FakeNetworkModule alloc] init];
    });
    
    return network;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setJsonAptDataArrWithFile];
    }
    return self;
}

- (void)setJsonAptDataArrWithFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mobile" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    self.jsonAptDataArr = [dataDic objectForKey:@"filtered"];
}



#pragma mark - Fake Network Methods
- (void)getAptInfosWithFarRightLat:(CGFloat)frLat      // FarRight : Top Right, corner of the mapView camera
                   withFarRightLng:(CGFloat)frLng
                   withNearLeftLat:(CGFloat)nlLat      // NearLeft : Bottom Left, corner of the mapView camera
                   withNearLeftLng:(CGFloat)nlLng
               withCompletionBlock:(void (^)(RLMArray<AptDataSet *> *aptList))completionBlock {
    

    // 서버 통신과정 생략
    // 원래는 서버에서 처리할 부분 ----------------------------- //
    
    // 위도는 보통 frLat > nlLat (예외 상황 180 ~ -180, 태평양..)
    // 경도는 항상 frLng > nlLng
    // 한국 서비스라 가정하고, 위도 예외상황 발생 없음.
    
    NSMutableArray *aptDicArr = [[NSMutableArray alloc] init];      // 스크린 범위 안에 들어가는 아파트 정보 Dic을 모은 Arr, 서버로부터 받는 데이터
    
    for (NSDictionary *aptDic in self.jsonAptDataArr) {
        CGFloat lat = [[aptDic objectForKey:@"lat"] doubleValue];
        CGFloat lng = [[aptDic objectForKey:@"lng"] doubleValue];
        
        if (lat<=frLat && lat>=nlLat && lng<=frLng && lng>=nlLng) {
            [aptDicArr addObject:aptDic];
        }
    }
    // -------------------------------------------------- //
    
    RLMArray<AptDataSet *> *aptList = [[DataCenter sharedInstance] setAptDataWithAptDicArr:aptDicArr];  // 데이터 Add or Update
    
    completionBlock(aptList);  // 지도있는 컨트롤러로 반환
    
}


@end
