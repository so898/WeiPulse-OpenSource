//
//  AtTypeViewCell.h
//  WeiPulse
//
//  Created by so898 on 12-8-8.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol AtTypeViewDelegate;
@interface AtTypeViewCell : UITableViewCell {
    UIView *backg1, *backg2;
    UIImageView *avast1, *avast2;
    UILabel *name1, *name2;
    User *user1, *user2;
}

@property (nonatomic,assign) id<AtTypeViewDelegate> delegate;

- (void)setUser:(User *)u1 another:(User *)u2;

@end

@protocol AtTypeViewDelegate <NSObject>

- (void) returnUser:(User *)u;

@end
