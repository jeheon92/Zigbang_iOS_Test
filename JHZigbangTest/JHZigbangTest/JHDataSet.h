//
//  JHDataSet.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Realm/Realm.h>

@interface JHDataSet : RLMObject
// Add properties here to define the model
@end

// This protocol enables typed collections. i.e.:
// RLMArray<JHDataSet *><JHDataSet>
RLM_ARRAY_TYPE(JHDataSet)
