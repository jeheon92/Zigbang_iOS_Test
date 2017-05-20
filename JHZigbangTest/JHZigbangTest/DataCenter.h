//
//  DataCenter.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

#pragma mark - DataCenter Sigleton Object
+ (instancetype)sharedInstance;     // sigleton


#pragma mark - Save & Update Apt Data
- (RLMArray<AptDataSet *> *)setAptDataWithAptDicArr:(NSArray *)aptDicArr;


#pragma mark - Find Data With PK (id)
- (AptDataSet *)findAptDataWithPK:(NSInteger)pk;
- (AddressDataSet *)findAddressDataWithPK:(NSInteger)pk;
- (MarkerDataSet *)findMarkerDataWithPK:(NSInteger)pk;

@end
