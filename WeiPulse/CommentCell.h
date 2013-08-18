//
//  CommentCell.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-25.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "Status.h"
#import "Comment.h"

@protocol CommentCellDelegate;
@interface CommentCell : UITableViewCell<OHAttributedLabelDelegate>{
    UILabel *name, *via, *time;
    OHAttributedLabel *text;
    UIButton *button;
    float height;
    Status *sts;
    Comment *com;
}

@property (nonatomic, assign) id <CommentCellDelegate> delegate;
- (float) returnHeight;
- (void) setName:(NSString *)aname;
- (void) setPost:(NSString *)atext;
- (void) setVia: (NSString *)source;
- (void) setTime: (time_t)date;
- (void) setType:(int)i;
- (void) setStatus:(Status *)s;
- (void) setComment:(Comment *)c;

@end
@protocol CommentCellDelegate <NSObject>
- (void) openTheURL:(NSString *)url;
- (void) openUserDetail:(NSString *)name;
- (void) openStatus:(Status *)s;
- (void) openComment:(Comment *)c;
@end
