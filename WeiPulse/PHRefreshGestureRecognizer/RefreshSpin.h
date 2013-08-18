//
//  RefreshSpin.h
//  Refresh
//
//  Created by tianran DING on 12-3-5.
//  Copyright (c) 2012年 dingtr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RefreshSpin : UIView {
    UIImage *_containnerImage;
    UIImage *_spinImage;
    float _progress;
    BOOL _infinite;
    
    NSTimer *infiniteTimer;
    
}

@property (nonatomic, strong) UIImage *containnerImage;
@property (nonatomic, strong) UIImage *spinImage;
@property (nonatomic) float progress;
@property (nonatomic, assign) BOOL infinite;

- (void) startInfiniteAnimation;
- (void) stopInfiniteAnimation;

@end
