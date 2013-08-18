//
//  MessageSmallCell.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "Status.h"

@protocol MessageSmallCellDelegate;
@interface MessageSmallCell : UITableViewCell<OHAttributedLabelDelegate>{
    UIImageView *image, *oimage, *location;
    UILabel *repost, *reply, *time, *oname, *via;
    OHAttributedLabel *text, *otext;
    float height;
    BOOL pic, opic;
    UIViewController *homeView;
    NSString *bigImageUrl;
    UIView * oback;
    Status *sts;
}

- (void) setStatus:(Status*)s;
- (float) returnHeight;
@property(nonatomic,assign) id <MessageSmallCellDelegate> delegate;

@end
@protocol MessageSmallCellDelegate <NSObject>
- (void) openImage:(NSString *)imgURL;
- (void) openTheURL:(NSString *)url;
- (void) openUserDetail:(NSString *)name;
@end
