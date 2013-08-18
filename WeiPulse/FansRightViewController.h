//
//  FansRightViewController.h
//  WeiPulse
//
//  Created by so898 on 12-7-31.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

typedef enum {
    FollowedBy,     //粉丝
    Following,      //关注
    TwoFollow,      //互粉
}FansViewType;

@protocol FansRightViewDelegate;
@interface FansRightViewController : UIViewController{
    UIView *border, *backg;
    UIButton *followBy, *following, *biFollow;
    FansViewType type;
    //id <FansRightViewDelegate> delegate;
}

@property(nonatomic,assign) id <FansRightViewDelegate> delegate;

- (void)setType:(FansViewType)t;

@end

@protocol FansRightViewDelegate <NSObject>
- (void)changeTypeFromRight:(FansViewType)t;
@end
