//
//  PersonViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "User.h"
#import "WeiBoMessageManager.h"
#import "MessageSmallCell.h"

@interface PersonViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, MessageSmallCellDelegate>{
    User *user;
    UIImageView *avast, *v;
    UIView *mainView, *avastBackg;
    UIButton *more, *followed, *following;
    UILabel *ID, *follow, *fans;
    UITableView *mainTable;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    NSMutableArray *statuses;
    BOOL _showManu, _addMessage, listener;
    int shouldHave;
}

+(PersonViewController*)getInstance;
+(void)deleteInstance;
+(BOOL)returnInstance;
- (void)changeSetting;

@end
