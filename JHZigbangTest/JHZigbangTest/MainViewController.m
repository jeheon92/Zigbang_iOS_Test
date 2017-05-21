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
@property (weak, nonatomic) IBOutlet UIButton *moveToJamwonBtn;
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomDownBtn;
@property (weak, nonatomic) IBOutlet UIView *notiZoomUpMessageView;

@property (nonatomic) BOOL showingSVProgressHUD;

@property (weak, nonatomic) MarkerDetailView *markerDetailView;
@property (nonatomic) BOOL movingToMarkerPosition;      // 선택 마커로 이동 중일 때, YES
@property (nonatomic) GMSMarker *selectedMarker;

@end


@implementation MainViewController

#pragma mark - ViewController Basic & Init Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithMapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.markerDetailView.frame = CGRectMake(0, self.mapView.frame.size.height-MARKER_DETAIL_VIEW_HEIGHT, self.mapView.frame.size.width, MARKER_DETAIL_VIEW_HEIGHT);        // markerDetailView frame 확정
}


- (void)initWithMapView {
    
    self.mapView.myLocationEnabled = YES;           // myLocation Enabled
    self.mapView.settings.rotateGestures = NO;      // rotate gesture Disabled
    [self.mapView bringSubviewToFront:self.notiZoomUpMessageView];
    
    // MapView Btns
    for (UIButton *btn in @[self.moveToJamwonBtn, self.myLocationBtn, self.zoomUpBtn, self.zoomDownBtn]) {
        [self.mapView bringSubviewToFront:btn];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    // MarkerDetailView
    MarkerDetailView *markerDetailView = [[MarkerDetailView alloc] init];       // + loadNib, markerDetailView 계속해서 재사용
    [self.mapView addSubview:markerDetailView];
    self.markerDetailView = markerDetailView;
    
    self.markerDetailView.hidden = YES;     // default로 Hidden
    
    
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
- (IBAction)moveToJamwonBtnAction:(id)sender {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.513640f
                                                            longitude:127.011266f
                                                                 zoom:self.mapView.camera.zoom];
    
    [self.mapView setCamera:camera];    // 잠원동 중심으로 카메라 이동
}

- (IBAction)myLocationBtnAction:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.mapView myLocation].coordinate.latitude
                                                            longitude:[self.mapView myLocation].coordinate.longitude
                                                                 zoom:self.mapView.camera.zoom];
    
    [self.mapView setCamera:camera];    // 내 위치 중심으로 카메라 이동
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
    NSLog(@"idleAtCameraPosition");
    
    self.movingToMarkerPosition = NO;
    
    // 지도 마커 초기화
    [mapView clear];
    
    if (position.zoom >= SMALL_MARKER_ZOOM) {
        self.notiZoomUpMessageView.hidden = YES;
        GMSVisibleRegion visibleRegion = [self.mapView.projection visibleRegion];
        [[FakeNetworkModule networkManager] getAptInfosWithFarRightLat:visibleRegion.farRight.latitude
                                                       withFarRightLng:visibleRegion.farRight.longitude
                                                       withNearLeftLat:visibleRegion.nearLeft.latitude
                                                       withNearLeftLng:visibleRegion.nearLeft.longitude
                                                   withCompletionBlock:^(RLMArray<AptDataSet *> *aptList) {
                                                       
                                                       [self setMarkers:aptList];    // Set Markers
                                                   }];
    } else {
        self.notiZoomUpMessageView.hidden = NO;
    }
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didChangeCameraPosition");
    
    if (self.movingToMarkerPosition == NO) {
        [self deselectSelectedMarker];      // 이전 선택마커 선택해제
    }
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"didTapMarker");
    [mapView animateToLocation:marker.position];
    self.movingToMarkerPosition = YES;
    
    [self deselectSelectedMarker];      // 이전 선택마커 선택해제
    
    MarkerDataSet *markerData = [[DataCenter sharedInstance] findMarkerDataWithPK:marker.iconView.tag];
    [self setMarkerImage:marker withMarkerData:markerData isSelected:YES];      // 마커 이미지 Selected로 세팅
    
    AptDataSet *aptData = [[DataCenter sharedInstance] findAptDataWithPK:marker.iconView.tag];
    [self.markerDetailView showMarkerDetailView:aptData];    // markerDetailView 정보 세팅

    self.markerDetailView.hidden = NO;
    self.selectedMarker = marker;       // 선택 마커 프로퍼티에 셋
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"didTapAtCoordinate");
    
    [self deselectSelectedMarker];  // 선택마커 선택해제
}


#pragma mark - Custom Methods

// Set Markers Method
- (void)setMarkers:(RLMArray<AptDataSet *> *)aptList {

    for (AptDataSet *aptData in aptList) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(aptData.marker.lat, aptData.marker.lng);
        
        marker.iconView = [[UIImageView alloc] init];       // UIImageView를 만들어 넣음
        marker.iconView.tag = aptData.id;                   // pk값 iconView.tag에 저장

        if (self.selectedMarker.iconView.tag == marker.iconView.tag) {      // 선택마커 있는지 확인
            [self setMarkerImage:marker withMarkerData:aptData.marker isSelected:YES];  // 선택 마커 이미지 세팅
            self.selectedMarker = marker;   // 선택마커 다시 세팅 (MapView의 모든 Marker를 clear한 후, 새로운 마커 객체를 만들었기 때문)
        } else {
            [self setMarkerImage:marker withMarkerData:aptData.marker isSelected:NO];   // 기본 마커 이미지 세팅
        }
        
        marker.map = self.mapView;
    }
}

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
                                               options:SDWebImageHighPriority
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 [SVProgressHUD dismiss];       // dismiss SVProgressHUD
                                                 
                                                 marker.iconView.frame = self.mapView.camera.zoom>=LARGE_MARKER_ZOOM ? CGRectMake(0, 0, 80, 70) : CGRectMake(0, 0, 80, 35);
                                                 [marker.iconView setContentMode:UIViewContentModeScaleAspectFit];
                                                 
                                             }];
    
}

// selectedMarker 선택해제 Method
- (void)deselectSelectedMarker {
    if (self.selectedMarker != nil) {
        MarkerDataSet *markerData = [[DataCenter sharedInstance] findMarkerDataWithPK:self.selectedMarker.iconView.tag];
        [self setMarkerImage:self.selectedMarker withMarkerData:markerData isSelected:NO];      // 이전 선택마커 선택해제
      
        self.markerDetailView.hidden = YES;
        self.selectedMarker = nil;       // selectedMarker nil로 세팅
    }
}


@end
