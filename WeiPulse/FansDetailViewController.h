//
//  FansDetailViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-21.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeiBoMessageManager.h"
#import "FansUserCell.h"
#import "PHRefreshGestureRecognizer.h"
#import "FansRightViewController.h"

typedef enum {
    FansDetailFromTopView,
    FansDetailFromTopCoverView,
}FansDetailViewType;

@interface FansDetailViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,FansUserCellDelegate>{
    NSMutableArray *fans;
    UITableView *mainTable;
    UIView *mainView;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    User *user, *tmp_user;
    int int_fans, cursor;
    UILabel *notice, *name;
    UIButton *close;
    FansViewType fType;
    FansDetailViewType type;
    BOOL listener;
}

- (void) setDetail:(FansViewType)t user:(User *)u type:(FansDetailViewType)t2;
- (void) setDetail:(FansViewType)t type:(FansDetailViewType)t2;

@end
