//
//  HotRightViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-2.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

typedef enum {
    HotRepost,     //热门转发
    HotComment,      //热门评论
}HotViewType;

@protocol HotRightViewDelegate;
@interface HotRightViewController : UIViewController{
    UIView *border, *backg;
    UIButton *status, *comment;
    HotViewType type;
}

@property (nonatomic ,assign) id <HotRightViewDelegate> delegate;
- (void)setType:(HotViewType)t;

@end
@protocol HotRightViewDelegate <NSObject>
- (void)changeTypeFromRight:(HotViewType)t;
@end
