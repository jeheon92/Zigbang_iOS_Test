//
//  DataCenter.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

#pragma mark - DataCenter Sigleton Object
+ (instancetype)sharedInstance {
    
    static DataCenter *data;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[DataCenter alloc] init];
    });
    
    return data;
}




#pragma mark - Add or Update Apt Data
- (RLMArray<AptDataSet *> *)setAptDataWithAptDicArr:(NSArray *)aptDicArr {
    
    RLMArray *aptArr = [[RLMArray alloc] initWithObjectClassName:@"AptDataSet"];
    
    // 기존 캐싱되어있던 데이터 Update하는 경우도 있어, 통째로 realm transaction에서 불림
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        for (NSDictionary *aptDic in aptDicArr) {
            [aptArr addObject:[AptDataSet makeAptDataWithDic:aptDic]];
        }

        [realm addOrUpdateObjectsFromArray:aptArr];     // Realm DB에 Add or Update
    }];
    
    NSLog(@"Add or Update: %@", aptArr);
    
    return aptArr;
}



@end

