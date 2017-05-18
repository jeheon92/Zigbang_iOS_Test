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

@end
