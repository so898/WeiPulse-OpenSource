//
//  MessageViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MessageRightViewController.h"
#import "MessageViewCell.h"
#import "WeiBoMessageManager.h"
#import "PHRefreshGestureRecognizer.h"

@interface MessageViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, MessageRightViewDelegate,MessageViewCellDelegate, WeiBoManagerDelegate>{
    NSMutableArray *rePost, *comment, *mail, *repostArr, *comArr;
    UITableView *mainTable;
    UIView *mainView;
    MessageViewType type;
    int reCountRePost, reCountComment;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    BOOL shouldRePost, shouldComment, listener;
    UILabel *notice;
}

+(MessageViewController*)getInstance;
+(void)deleteInstance;
+(BOOL)returnInstance;
-(void)changeSetting;

@end
