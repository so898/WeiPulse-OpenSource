//
//  MessageCell.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-7.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Status.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"

@protocol MessageCellDelegate;
@interface MessageCell : UITableViewCell <OHAttributedLabelDelegate>{
    UIImageView *avast, *image, *oimage, *location, *v;
    OHAttributedLabel *text, *otext;
    UILabel *repost, *reply, *time, *name, *oname, *source;
    float height;
    BOOL pic, opic;
    NSString *bigImageUrl;
    UIView * oback;
    Status *sts;
}

- (void) setStatus:(Status*)s;
- (float) returnHeight;
@property(nonatomic,assign) id <MessageCellDelegate> delegate;

@end

@protocol MessageCellDelegate <NSObject>
- (void) openImage:(NSString *)imgURL;
- (void) openAvast:(User *)u;
- (void) openTheURL:(NSString *)url;
- (void) openUserDetail:(NSString *)name;
@end
