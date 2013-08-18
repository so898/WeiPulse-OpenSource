//
//  StartScreenView.m
//  WeiPulse
//
//  Created by so898 on 12-8-16.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "StartScreenView.h"

@implementation StartScreenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 460);
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"start_backg"]];
        
        icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"icon_clear_show"];
        icon.frame = CGRectMake(110, 50, 100, 100);
        [self addSubview:icon];
        
        title = [UILabel new];
        title.textAlignment = UITextAlignmentCenter;
        title.frame = CGRectMake(0, 170, 320, 40);
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        title.text = @"WeiPulse";
        title.backgroundColor  = [UIColor clearColor];
        title.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        [self addSubview:title];
        
        copyRight = [UILabel new];
        copyRight.textAlignment = UITextAlignmentCenter;
        copyRight.frame = CGRectMake(0, 435, 320, 15);
        copyRight.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        copyRight.text = @"Copyright © 2012 by R³ Studio";
        copyRight.backgroundColor  = [UIColor clearColor];
        copyRight.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        [self addSubview:copyRight];
    }
    return self;
}

- (void)disappear
{
    [UIView animateWithDuration:0.8 animations:^{
        icon.frame = CGRectMake(90, 30, 140, 140);
        icon.alpha = 0;
        title.alpha = 0;
        copyRight.alpha = 0;
    } completion:^(BOOL complete){
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
        } completion:^(BOOL complete){
            [self removeFromSuperview];
        }];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
