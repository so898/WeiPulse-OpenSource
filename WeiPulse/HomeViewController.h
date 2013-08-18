//
//  HomeViewController.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "AddMessageViewController.h"
#import "PHRefreshGestureRecognizer.h"
#import "StatusViewController.h"
#import "OAuthWebView.h"
#import "WeiBoMessageManager.h"
#import "StatusCDItem.h"
#import "CoreDataManager.h"
#import "TimeScroller.h"
#import "StatusViewController.h"
#import "MessageCell.h"
#import "StartScreenView.h"
#import "NoticeViewController.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, PHRefreshDelegate, TimeScrollerDelegate,MessageCellDelegate, AddMessageViewDelegate, WeiBoManagerDelegate, AuthWebDelegate>{
    UITableView *mainTable;
    NSMutableArray *statuses, *s_ori, *s_pic, *stsArr, *oriArr, *picArr;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    NSString *userID;
    BOOL shouldLoad, firstRefresh, updateUp, update, listener;
    TimeScroller *timeScroller;
    OAuthWebView *webV;
    UIView *mainView;
    int tapCount, tappedRow;
    NSTimer *tapTimer;
    StartScreenView *startView;
    AddMessageType type;
    AddMessageViewController *right;
    
    UIButton *reFresh;
}

+ (HomeViewController*)getInstance;
+ (void)deleteInstance;
- (void)changeSetting;

@end
