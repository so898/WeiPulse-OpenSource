//
//  StatusViewController.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-10.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController{
    UIImageView *avast_d, *tl_d, *at_d, *reply_d, *message_d, *person_d, *setting_d,
                *avast_s, *tl_s, *at_s, *reply_s, *message_s, *person_s, *setting_s,
                *avast_p, *tl_p, *at_p, *reply_p, *message_p, *person_p, *setting_p;
    UIView *handle;
}

+ (StatusViewController*)getInstance;
+ (void)deleteInstance;
- (void)setAvast:(NSNumber *)situations;
- (void)setTimeLine:(NSNumber *)situations;
- (void)setAt:(NSNumber *)situations;
- (void)setReply:(NSNumber *)situations;
- (void)setMessage:(NSNumber *)situations;
- (void)setPerson:(NSNumber *)situations;
- (void)setSetting:(NSNumber *)situations;
@end
