//
//  ReplyViewController.h
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
    ReplyViewFromTopView,
    ReplyViewFromTopCoverView,
}ReplyViewType;

@interface ReplyViewController : UIViewController <EGORefreshTableHeaderDelegate, UITextViewDelegate, AtUserViewDelegate, HotTypeViewDelegate>{
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
    BOOL _reloading, _allowed, atType, hotType, toComment;
    int commentOrigin;
    ReplyViewType type;
}

- (void)setStatus:(Status *)s type:(ReplyViewType)t;
- (void)setComment:(Comment *)c type:(ReplyViewType)t;

@end
