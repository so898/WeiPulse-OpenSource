//
//  PHRefreshTriggerView.m
//  PHRefreshTriggerView
//
//  Created by Pier-Olivier Thibault on 11-12-20.
//  Copyright (c) 2011 25th Avenue. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "PHRefreshTriggerView.h"
#import <QuartzCore/QuartzCore.h>
#import "RefreshSpin.h"

@interface PHRefreshTriggerView (Private)

@end

@implementation PHRefreshTriggerView
@synthesize titleLabel      = _titleLabel;
@synthesize timeLabel      = _timeLabel;
@synthesize spin            = _spin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.timeLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.timeLabel];
        
        self.spin = [[RefreshSpin alloc] initWithFrame:CGRectZero];
        [self addSubview:self.spin];
        
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PHRefresh_backg"]];
        
    }
    return self;
}




- (void)layoutSubviews {
    self.titleLabel.frame               = CGRectIntegral(CGRectMake(80.0f, CGRectGetHeight(self.bounds) - 52.0f, CGRectGetWidth(self.bounds), 20.0f));
    self.timeLabel.frame                = CGRectIntegral(CGRectMake(80.0f, CGRectGetHeight(self.bounds) - 35.0f, CGRectGetWidth(self.bounds), 20.0f));
    self.spin.frame                     = CGRectMake(25, 10, 42, 42);
}


@end
