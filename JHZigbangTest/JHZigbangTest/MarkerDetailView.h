//
//  MarkerDetailView.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 20..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerDetailView : UIView

- (void)showMarkerDetailView:(AptDataSet *)aptData
         withCompletionBlock:(void (^)())completionBlock;

@end
