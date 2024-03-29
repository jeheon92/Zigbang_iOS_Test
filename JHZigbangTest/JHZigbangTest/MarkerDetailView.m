
//
//  MarkerDetailView.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 20..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MarkerDetailView.h"

@interface MarkerDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aptInfosLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceAndFloorAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerPyeongLabel;

@property (weak, nonatomic) IBOutlet UIStackView *starScoreStackView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starScoreView;
@property (weak, nonatomic) IBOutlet UILabel *starScoreLabel;

@end


@implementation MarkerDetailView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil][0];
    self = [super init];
    if (self) {
        // Shadow setting
        self.layer.shadowOffset = CGSizeMake(0.0f, -10.0f);
        self.layer.shadowRadius = 10.0f;
        self.layer.shadowOpacity = 0.4f;
    }
    return self;
}

- (void)showMarkerDetailView:(AptDataSet *)aptData {
    
    [SVProgressHUD show];       // show SVProgressHUD
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:aptData.image]
                      placeholderImage:[UIImage imageNamed:@"aptPlaceholderImg.png"]
                               options:SDWebImageHighPriority
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [SVProgressHUD dismiss];       // dismiss SVProgressHUD                                 
                             }];
    
    self.nameLabel.text = aptData.name;
    self.aptInfosLabel.text = [NSString stringWithFormat:@"%@ %@ ・%ld년 준공 ・%ld세대", aptData.address.gugun, aptData.address.dong, aptData.buildDate/100, aptData.households];
    
    self.priceAndFloorAreaLabel.text = [NSString stringWithFormat:@"%.1lf억 / %.0lf㎡", aptData.price/10000.0f+0.05f, aptData.floorArea+0.5f];   // 반올림 적용
    self.pricePerPyeongLabel.text = [NSString stringWithFormat:@"%.0lf만 / 3.3㎡", aptData.price*3.3f/aptData.floorArea + 0.5f];      // 반올림 적용
    
    if (aptData.score > 0.0f) {
        self.starScoreView.value = aptData.score;
        self.starScoreLabel.text = [NSString stringWithFormat:@"%.1lf", aptData.score];
        self.starScoreStackView.hidden = NO;
    } else {
        self.starScoreStackView.hidden = YES;   // 평가 없으므로, Hidden
    }
}


@end
