//
//  MessageRightViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-1.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

typedef enum {
    AtMessage,          //@微博
    CommentMessage,     //评论
    MailMessage,        //私信
}MessageViewType;

@protocol MessageRightViewDelegate;
@interface MessageRightViewController : UIViewController{
    UIView *border, *backg;
    UIButton *atMessage, *commentMessage, *mailMessage;
    MessageViewType type;
}

@property(nonatomic,assign) id <MessageRightViewDelegate> delegate;

- (void)setType:(MessageViewType)t;

@end

@protocol MessageRightViewDelegate <NSObject>
- (void)changeTypeFromRight:(MessageViewType)t;
@end

