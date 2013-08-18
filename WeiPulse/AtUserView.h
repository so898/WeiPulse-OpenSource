//
//  AtUserView.h
//  WeiPulse
//
//  Created by so898 on 12-8-5.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "AtTypeViewCell.h"

@protocol AtUserViewDelegate;
@interface AtUserView : UIView<UITableViewDataSource, UITableViewDelegate, AtTypeViewDelegate>{
    UITableView *table;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    NSMutableArray *users;
    UILabel *notice;
}

@property (nonatomic, assign) id <AtUserViewDelegate> delegate;
- (void)loadView;

@end
@protocol AtUserViewDelegate <NSObject>

- (void) returnUserName:(NSString *)name;

@end
