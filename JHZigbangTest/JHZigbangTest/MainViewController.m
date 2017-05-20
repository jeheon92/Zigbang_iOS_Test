//
//  MainViewController.m
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MainViewController.h"
#import "MarkerDetailView.h"

#define SMALL_MARKER_ZOOM 14.0f
#define LARGE_MARKER_ZOOM 16.0f
#define MARKER_DETAIL_VIEW_HEIGHT 230.0f

@interface MainViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomDownBtn;

@property (weak, nonatomic) MarkerDetailView *markerDetailView;

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
                                                                         zoom:LARGE_MARKER_ZOOM];
            
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
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    if (mapView.selectedMarker != nil) {
        MarkerDataSet *markerData = [[DataCenter sharedInstance] findMarkerDataWithPK:mapView.selectedMarker.iconView.tag];
        [self setMarkerImage:mapView.selectedMarker withMarkerData:markerData isSelected:NO];   // 이전 선택했던 마커 선택해제

        mapView.selectedMarker = nil;       // 선택마커 없음
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"idleAtCameraPosition lat: %lf, lng: %lf", position.target.latitude, position.target.longitude);
    
    // 지도 마커 초기화
    self.aptList = nil;
    [self.mapView clear];

    if (position.zoom >= SMALL_MARKER_ZOOM) {
        GMSVisibleRegion visibleRegion = [self.mapView.projection visibleRegion];
        self.aptList = [[FakeNetworkModule networkManager] getAptInfosWithFarRightLat:visibleRegion.farRight.latitude
                                                                      withFarRightLng:visibleRegion.farRight.longitude
                                                                      withNearLeftLat:visibleRegion.nearLeft.latitude
                                                                      withNearLeftLng:visibleRegion.nearLeft.longitude];
    }

    // 등록된 핀
    for (AptDataSet *aptData in self.aptList) {
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(aptData.marker.lat, aptData.marker.lng);
        
        marker.iconView = [[UIImageView alloc] init];       // UIImageView를 만들어 넣음
        marker.iconView.tag = aptData.id;                   // pk값 iconView.tag에 저장
        [self setMarkerImage:marker withMarkerData:aptData.marker isSelected:NO];   // 마커 이미지 세팅
        
    }
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"didTapMarker");
    
    if (mapView.selectedMarker != nil) {
        MarkerDataSet *markerData = [[DataCenter sharedInstance] findMarkerDataWithPK:mapView.selectedMarker.iconView.tag];
        [self setMarkerImage:mapView.selectedMarker withMarkerData:markerData isSelected:NO];   // 이전 선택했던 마커 선택해제
    }
    
    MarkerDataSet *markerData = [[DataCenter sharedInstance] findMarkerDataWithPK:marker.iconView.tag];
    [self setMarkerImage:marker withMarkerData:markerData isSelected:YES];      // 마커 이미지 Selected로 세팅
 
    NSLog(@"end didTapMarker");
    mapView.selectedMarker = marker;    // 선택 마커 세팅

    return YES;
}

- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    NSLog(@"markerInfoWindow");
    
    // 그림자, 선택 마커 중심으로 이동 처리 필요
    
    // MarkerDetailView
    MarkerDetailView *markerDetailView = [[MarkerDetailView alloc] init];       // + loadNib
    markerDetailView.frame = CGRectMake(0, 0, self.mapView.frame.size.width, MARKER_DETAIL_VIEW_HEIGHT);
    
    AptDataSet *aptData = [[DataCenter sharedInstance] findAptDataWithPK:marker.iconView.tag];
    [self.markerDetailView showMarkerDetailView:aptData];       // markerDetailView 정보 세팅

    
    return markerDetailView;
}


#pragma mark - Custom Methods
// Marker Img Setting Method
- (void)setMarkerImage:(GMSMarker *)marker withMarkerData:(MarkerDataSet *)markerData isSelected:(BOOL)isSelected {

    NSString *markerUrlStr;

    if (isSelected) {
        markerUrlStr = self.mapView.camera.zoom>=LARGE_MARKER_ZOOM ? markerData.largeSelected : markerData.smallSelected;
        marker.zIndex = 1;      // 마커 가려지지 않게 처리
    } else {
        markerUrlStr = self.mapView.camera.zoom>=LARGE_MARKER_ZOOM ? markerData.largeBase : markerData.smallBase;
        marker.zIndex = 0;
    }
    
    NSURL *markerUrl = [NSURL URLWithString:markerUrlStr];
    
    [SVProgressHUD show];       // show SVProgressHUD
    [(UIImageView *)marker.iconView sd_setImageWithURL:markerUrl
                                      placeholderImage:((UIImageView *)marker.iconView).image   // 이전 쓰던 마커이미지 placeholderImage로 사용
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 [SVProgressHUD dismiss];           // dismiss SVProgressHUD
                                                 
                                                 marker.iconView.frame = self.mapView.camera.zoom>=LARGE_MARKER_ZOOM ? CGRectMake(0, 0, 80, 70) : CGRectMake(0, 0, 80, 35);
                                                 [marker.iconView setContentMode:UIViewContentModeScaleAspectFit];

                                                 marker.map = self.mapView;
                                                 
                                             }];
}


@end
