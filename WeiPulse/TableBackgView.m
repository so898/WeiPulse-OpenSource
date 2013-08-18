//
//  TableBackgView.m
//  WeiPulse
//
//  Created by so898 on 12-8-1.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "TableBackgView.h"

@implementation TableBackgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        UILabel *notice = [UILabel new];
        notice.text = @"您的此列表为空";
        notice.frame = CGRectMake(0, 20, 310, 30);
        notice.textAlignment = UITextAlignmentCenter;
        notice.textColor = [UIColor grayColor];
        notice.backgroundColor = [UIColor clearColor];
        notice.shadowColor = [UIColor whiteColor];
        notice.shadowOffset = CGSizeMake(0, -1.0f);
        [self addSubview:notice];
    }
    return self;
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
