//
//  FansUserCell.h
//  WeiPulse
//
//  Created by so898 on 12-7-31.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@protocol FansUserCellDelegate;
@interface FansUserCell : UITableViewCell{
    UILabel *name, *personName, *followBy, *sex, *location, *notice;
    UIView *avastBackg;
    UIImageView *avast, *v;
    UIButton *fan;
    User *user;
    BOOL two;
}

@property(nonatomic,assign) id <FansUserCellDelegate> delegate;

- (void) setUser:(User *)use;
- (void) setType;

@end

@protocol FansUserCellDelegate <NSObject>
- (void)removeUserFromFollow:(User *)u;
- (void)addUserToFollow:(User *)u;
@end
