//
//  LastCell.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-20.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "LastCell.h"
#import "MessageCellBackgView.h"

@implementation LastCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Show_Line"]];
        line.frame = CGRectMake(-120, 0, 120, 50);
    }
    last = [UILabel new];
    last.text = @"点击载入更多";
    last.textAlignment = UITextAlignmentCenter;
    last.backgroundColor = [UIColor clearColor];
    last.frame = CGRectMake(0, 15, 320, 20);
    [self.contentView addSubview:line];
    [self.contentView addSubview:last];
    [self.timer invalidate];
    self.timer = nil;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    if (selected){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        last.text = @"载入中";
    }
        
    // Configure the view for the selected state
}

- (void)handleTimer: (id)sender
{
    [UIView animateWithDuration:0.8 animations:^{line.frame = CGRectMake(440, 0, 120, 50);} completion:^(BOOL finished){line.frame = CGRectMake(-120, 0, 120, 50);}];
}


@end
