//
//  MessageViewCell.h
//  WeiPulse
//
//  Created by so898 on 12-8-1.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OHAttributedLabel.h"
#import "Status.h"
#import "Comment.h"

@protocol MessageViewCellDelegate;
@interface MessageViewCell : UITableViewCell<OHAttributedLabelDelegate>{
    UILabel *name, *via, *time;
    OHAttributedLabel *text, *otext;
    UIButton *button;
    UIImageView *avast, *v, *oimage;
    UIView *oback;
    float height;
    BOOL opic;
    NSString *bigImageUrl;
    Status *sts;
    Comment *com;
}

@property (nonatomic, assign) id <MessageViewCellDelegate> delegate;

- (float) returnHeight;
- (void) setStatus:(Status *)s;
- (void) setComment:(Comment *)c;

@end
@protocol MessageViewCellDelegate <NSObject>

- (void) openImage:(NSString *)imgURL;
- (void) openAvast:(User *)u;
- (void) openTheURL:(NSString *)url;
- (void) openUserDetail:(NSString *)name;
- (void) repostStatus:(Status *)s;
- (void) replyComment:(Comment *)c;

@end
