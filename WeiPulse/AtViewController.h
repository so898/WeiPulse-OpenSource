//
//  AtViewController.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ECSlidingViewController.h"
#import "Draft.h"
#import "WeiBoMessageManager.h"
#import "MBProgressHUD.h"
#import "AtUserView.h"
#import "HotTypeView.h"
#import "Status.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"

typedef enum {
    AtViewFromTopView,
    AtViewFromTopCoverView,
}AtViewType;

@interface AtViewController : UIViewController <EGORefreshTableHeaderDelegate, UITextViewDelegate, AtUserViewDelegate, HotTypeViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    //Draft *draft;
    Status *sts;
    Comment *com;
    OHAttributedLabel *text;
    UIScrollView *scrollview, *textBackg;
    UITextView *input;
    UIButton *closetype, *exit, *commentOri;
    UIView *mainView, *inputAccView, *buttonBackg;
    UILabel *dragText, *num, *num_s;
    UIImageView *dragIcon, *dragBackg;
    WeiBoMessageManager *manager;
    BOOL _reloading, _allowed, atType, hotType;
    int commentOrigin, wordNum;
    AtViewType type;
}

- (void)setStatus:(Status *)s type:(AtViewType)t;

@end
