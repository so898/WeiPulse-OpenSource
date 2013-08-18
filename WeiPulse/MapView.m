//
//  MapView.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 460);
        self.alpha = 0;
        UIView *backg = [UIView new];
        backg.frame = CGRectMake(0, 0, 320, 460);
        backg.alpha = 0.5f;
        [self addSubview:backg];
        map = [MKMapView new];
        map.frame = CGRectMake(30, 80, 260, 200);
        map.mapType = MKMapTypeStandard;
        map.zoomEnabled = NO;
        map.scrollEnabled = NO;
        map.userInteractionEnabled = NO;
        map.delegate = self;
        [self addSubview:map];
        UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Exit)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapGestureRecognizer];
    }
    return self;
}

-(void)setMap:(float)x latitude:(float)y
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:x longitude:y];
    MKPointAnnotation *ann = [MKPointAnnotation new];
    ann.coordinate = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    [map setRegion:region];
    [map addAnnotation:ann];
    [UIView animateWithDuration:0.5 animations:^{
        map.frame = CGRectMake(30, 120, 260, 200);
        self.alpha = 1.0f;
    }];
}

-(void)setMap:(CLLocation *)location
{
    MKPointAnnotation *ann = [MKPointAnnotation new];
    ann.coordinate = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    [map setRegion:region];
    [map addAnnotation:ann];
    [UIView animateWithDuration:0.5 animations:^{
        map.frame = CGRectMake(30, 120, 260, 200);
        self.alpha = 1.0f;
    }];
}

- (MKPinAnnotationView *)mapView: (MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyLocation"];
    pinView.animatesDrop = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    pinView.canShowCallout = YES;
    return pinView;
}

- (void)Exit
{
    [UIView animateWithDuration:0.5 animations:^{self.alpha = 0;} 
                     completion:^(BOOL Complete){
                         [self removeFromSuperview];}];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
