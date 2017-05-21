//
//  ListViewController.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 21..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "ListViewController.h"
#import "AptTableViewCell.h"
#import "MapViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property RLMArray<AptDataSet *> *aptList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];       // show SVProgressHUD
    [[FakeNetworkModule networkManager] getAptListWithCompletionBlock:^(RLMArray<AptDataSet *> *aptList) {
        [SVProgressHUD dismiss];       // dismiss SVProgressHUD
        self.aptList = aptList;
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.aptList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AptTableViewCell *aptCell = [tableView dequeueReusableCellWithIdentifier:@"aptCell" forIndexPath:indexPath];
    
    [aptCell setAptCell:self.aptList[indexPath.row]];
    
    return aptCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.25f;   // Plain style, Separator Line 계속 생기지 않게 처리
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [(MapViewController *)[UIApplication sharedApplication].keyWindow.rootViewController showSelectedApt:self.aptList[indexPath.row]];
    
    NSLog(@"self.aptList[indexPath.row] : %@", self.aptList[indexPath.row]);
    [self dismissViewController];
}


# pragma mark - IBAction Btn Method
- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewController];
}


# pragma mark - Custom Method
- (void)dismissViewController {
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end
