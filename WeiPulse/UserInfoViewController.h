//
//  UserInfoViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "WeiBoMessageManager.h"

typedef enum {
    UserInfoFromTopView,
    UserInfoFromTopCoverView,
}UserInfoViewType;

@interface UserInfoViewController : UIViewController{
    UIImageView *avast, *v;
    UIView *mainView, *avastBackg;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    User *user;
    BOOL listener;
    UILabel *title, *ID, *name, *sex, *location, *reason, *descript, *create;
    UIButton *close;
    UserInfoViewType type;
    UIScrollView *mainPart;
    int height;
}

- (void) setUser:(User *)u type:(UserInfoViewType)t;

@end
