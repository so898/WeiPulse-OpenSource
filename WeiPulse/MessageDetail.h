//
//  MessageDetail.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-7.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "Status.h"
#import "ECSlidingViewController.h"
#import "WeiBoMessageManager.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "CommentCell.h"

typedef enum{
    MessageFromTopView,
    MessageFromTopCoverView,
}MessageDetailViewType;

@interface MessageDetail : UIViewController<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, OHAttributedLabelDelegate,CommentCellDelegate>{
    Status *sts;
    UIImageView *avast, *image, *oimage, *backgView, *v;
    UIView *mainView, *avastBackg, *imageBackg, *oimageBackg, *oback, *border;
    UIScrollView *secondView;
    UIButton *repostTweet, *replyTweet, *more, *close, *position, *repostButton, *replyButton;
    UILabel *ID, *date, *via;
    OHAttributedLabel *text, *otext;
    UITableView *mainTable;
    float height;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    BOOL _followed, _following, _self, _showManu, _comment, _add, listener;
    NSMutableArray *comments, *reposts;
    int shouldComments, shouldReposts;
    MessageDetailViewType type;
}

- (void)setStatus:(Status *)status type:(MessageDetailViewType)t;

@end
