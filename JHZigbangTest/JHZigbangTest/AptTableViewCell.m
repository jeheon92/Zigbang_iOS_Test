//
//  AptTableViewCell.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 21..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "AptTableViewCell.h"

@interface AptTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *aptIconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aptInfosLabel;

@property (weak, nonatomic) IBOutlet UIStackView *starScoreStackView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starScoreView;
@property (weak, nonatomic) IBOutlet UILabel *starScoreLabel;

@end


@implementation AptTableViewCell

- (void)setAptCell:(AptDataSet *)aptData {
    
    [SVProgressHUD show];       // show SVProgressHUD
    [self.aptIconView sd_setImageWithURL:[NSURL URLWithString:aptData.marker.largeBase]
                        placeholderImage:nil
                                 options:SDWebImageHighPriority
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [SVProgressHUD dismiss];       // dismiss SVProgressHUD
                               }];
    
    self.nameLabel.text = aptData.name;
    self.aptInfosLabel.text = [NSString stringWithFormat:@"%@ %@ ・%ld년 준공 ・%ld세대", aptData.address.gugun, aptData.address.dong, aptData.buildDate/100, aptData.households];
    
    if (aptData.score > 0.0f) {
        self.starScoreView.value = aptData.score;
        self.starScoreLabel.text = [NSString stringWithFormat:@"%.1lf", aptData.score];
        self.starScoreStackView.hidden = NO;
    } else {
        self.starScoreStackView.hidden = YES;   // 평가 없으므로, Hidden
    }
}

@end
