//
//  MenuViewController.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "WeiBoMessageManager.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WeiBoManagerDelegate>{
    UIImageView *avast;
    UILabel *name;
    UIButton *signOut;
    UIView *avast_button;
    WeiBoMessageManager *manager;
    BOOL _showMenu;
    UITableView *List;
}

+(MenuViewController*)getInstance;
+(void)deleteInstance;

- (void)reSetUser;

@end
