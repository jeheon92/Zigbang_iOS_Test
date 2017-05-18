//
//  JHDataSet.h
//  JHZigbangTest
//
//  Created by Jeheon Choi on 2017. 5. 18..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Realm/Realm.h>

@class AptDataSet;
@class AddressDataSet;
@class MarkerDataSet;


#pragma mark - Apartment Data Set
@interface AptDataSet : RLMObject

@property NSInteger id;

@property NSString *name;
@property AddressDataSet *address;

@property CGFloat score;
@property NSString *image;
@property NSString *brand;
@property NSString *buildDate;

@property NSInteger price;
@property CGFloat floorArea;

@property MarkerDataSet *marker;

@end


#pragma mark - Address Data Set
@interface AddressDataSet : RLMObject

@property NSInteger id;

@property NSString *sido;
@property NSString *gugun;
@property NSString *dong;
@property NSString *bunji;

@end


#pragma mark - Marker Data Set
@interface MarkerDataSet : RLMObject

@property NSInteger id;

@property CGFloat lat;
@property CGFloat lng;

@property NSString *smallBase;
@property NSString *smallSelected;

@property NSString *largeBase;
@property NSString *largeSelected;


@end

