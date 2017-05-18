//
//  MainViewController.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomDownBtn;

@property (nonatomic) RLMArray<AptDataSet *> *aptList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithMapView];
}


- (void)initWithMapView {
    
    self.mapView.myLocationEnabled = YES;           // myLocation Enabled
    self.mapView.settings.rotateGestures = NO;      // rotate gesture Disabled
    
    // MapView Btns
    for (UIButton *btn in @[self.myLocationBtn, self.zoomUpBtn, self.zoomDownBtn]) {
        [self.mapView bringSubviewToFront:btn];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    // 내 위치를 중심으로 Map 띄우기
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        while([self.mapView myLocation].coordinate.latitude == 0.0f);   // myLocation 받아오기까지 조금 시간 걸림
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.mapView myLocation].coordinate.latitude
                                                                    longitude:[self.mapView myLocation].coordinate.longitude
                                                                         zoom:16.0f];
            
            [self.mapView setCamera:camera];    // myLocation 중심으로 카메라 세팅
        });
    });
}






#pragma mark - MapView Btns Action Methods

- (IBAction)myLocationBtnAction:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.mapView myLocation].coordinate.latitude
                                                            longitude:[self.mapView myLocation].coordinate.longitude
                                                                 zoom:self.mapView.camera.zoom];
    
    [self.mapView setCamera:camera];    // 내 위치 중심으로 카메라 설정
    
}

- (IBAction)zoomUpBtnAction:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.mapView.camera.target.latitude
                                                            longitude:self.mapView.camera.target.longitude
                                                                 zoom:self.mapView.camera.zoom + 0.5f];
    [self.mapView animateToCameraPosition:camera];

}

- (IBAction)zoomDownBtnAction:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.mapView.camera.target.latitude
                                                            longitude:self.mapView.camera.target.longitude
                                                                 zoom:self.mapView.camera.zoom - 0.5f];
    [self.mapView animateToCameraPosition:camera];

}




#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"idleAtCameraPosition lat: %lf, lng: %lf", position.target.latitude, position.target.longitude);
    
    GMSVisibleRegion visibleRegion = [self.mapView.projection visibleRegion];
    
    self.aptList = [[FakeNetworkModule networkManager] getAptInfosWithFarRightLat:visibleRegion.farRight.latitude
                                                                  withFarRightLng:visibleRegion.farRight.longitude
                                                                  withNearLeftLat:visibleRegion.nearLeft.latitude
                                                                  withNearLeftLng:visibleRegion.nearLeft.longitude];
    
    
}



@end
