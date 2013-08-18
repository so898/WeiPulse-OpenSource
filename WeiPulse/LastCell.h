//
//  LastCell.h
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-20.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastCell : UITableViewCell{
    UIImageView *line;
    UILabel *last;
}
@property (nonatomic, retain) NSTimer *timer;

@end
