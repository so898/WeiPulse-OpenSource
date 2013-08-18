//
//  SettingViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "ECSlidingViewController.h"
#import "LeveyPopListView.h"
#import "Purchases.h"
#import "WeiBoMessageManager.h"

@interface SettingViewController : UIViewController<UIScrollViewDelegate, LeveyPopListViewDelegate, MFMailComposeViewControllerDelegate, PurchasesDelegate>{
    UIView *mainView;
    UIScrollView *mainPart;
    UIButton *font, *timeStamp, *userShow, *showFace, *webType, *savePic, *webShare, *sound, *deleteAD, *deleteCache, *atAuthor, *atWeibo, *help, *feedback, *giveComment, *about;
    LeveyPopListView *fontList, *webTypeList, *userShowList;
    Purchases *p;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    BOOL listener;
}

+(SettingViewController*)getInstance;
+(void)deleteInstance;

@end
