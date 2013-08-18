//
//  HotViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "WeiBoMessageManager.h"
#import "PHRefreshGestureRecognizer.h"
#import "MessageCell.h"
#import "HotRightViewController.h"

@interface HotViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, PHRefreshDelegate, MessageCellDelegate, HotRightViewDelegate>{
    UITableView *mainTable;
    UIView *mainView;
    NSMutableArray *statuses, *comments;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    HotViewType type;
    BOOL shouldStatus, shouldComment;
}

+(HotViewController*)getInstance;
+(void)deleteInstance;
+(BOOL)returnInstance;
-(void)changeSetting;

@end
