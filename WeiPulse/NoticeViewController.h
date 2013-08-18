//
//  NoticeViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-23.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"

@interface NoticeViewController : UIViewController{
    NSNotificationCenter *defaultNotifCenter;
    WeiBoMessageManager *manager;
    int unreadRepost, unreadComment, unreadFriend;
}

@property (nonatomic, retain) NSTimer *timer; 

+ (NoticeViewController*)getInstance;
+ (void)deleteInstance;
- (void)startTimer;

@end
