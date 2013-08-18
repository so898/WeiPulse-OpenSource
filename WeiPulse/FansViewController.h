//
//  FansViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "WeiBoMessageManager.h"
#import "User.h"
#import "FansUserCell.h"
#import "FansRightViewController.h"
#import "PHRefreshGestureRecognizer.h"

@interface FansViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,FansUserCellDelegate,FansRightViewDelegate>{
    NSMutableArray *followBy, *following, *twoFollow;
    UITableView *mainTable;
    UIView *mainView;
    FansViewType type;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    User *user, *tmp_user;
    BOOL _followBy, _following, _twoFollow, listener;
    int int_followBy, int_following, int_twoFollow, cursorFollowBy, cursorFollowing;
    FansRightViewController *right;
    UILabel *notice;
}

+(FansViewController*)getInstance;
+(void)deleteInstance;
- (void)setType:(FansViewType)t;

@end
