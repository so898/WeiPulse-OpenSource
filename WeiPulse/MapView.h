//
//  MapView.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIView <MKMapViewDelegate>{
    MKMapView *map;
}

- (void) setMap:(float)x latitude:(float)y;
- (void) setMap:(CLLocation *)location;

@end
