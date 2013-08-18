//
//  UserDetailViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-2.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "WeiBoMessageManager.h"
#import "MessageSmallCell.h"

typedef enum{
    UserFromTopView,
    UserFromTopCoverView,
}UserDetailViewType;

@interface UserDetailViewController : UIViewController< UITableViewDataSource, UITableViewDelegate, MessageSmallCellDelegate>{
    User *user;
    UIImageView *avast, *v;
    UIView *mainView, *avastBackg;
    UIButton *more, *followed, *following, *close;
    UILabel *ID, *name, *sex, *location, *follow, *fans;
    UITableView *mainTable;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    NSMutableArray *statuses;
    BOOL _addMessage, _followed, _following, _self, _showManu, _comment, _add, listener;
    int shouldHave;
    UserDetailViewType type;
}

- (void) setUser:(User *)u type:(UserDetailViewType)t;
- (void) setUserName:(NSString *)aname type:(UserDetailViewType)t;
@end
