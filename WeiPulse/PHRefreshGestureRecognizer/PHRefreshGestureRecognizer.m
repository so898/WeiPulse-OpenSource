//
//  PHRefreshTriggerView.m
//  PHRefreshTriggerView
//
//  Created by Pier-Olivier Thibault on 11-12-19.
//  Copyright (c) 2011 25th Avenue. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "PHRefreshGestureRecognizer.h"
#import "RefreshSpin.h"
#import "Sound.h"

#define FLIP_ARROW_ANIMATION_TIME 0.18f
NSString * const PHRefreshGestureAnimationKey       = @"PHRefreshGestureAnimationKey";
NSString * const PHRefreshResetGestureAnimationKey  = @"PHRefreshResetGestureAnimationKey";

@interface PHRefreshGestureRecognizer ()

- (CABasicAnimation *)triggeredAnimation;
- (CABasicAnimation *)idlingAnimation;

@property (nonatomic, strong, readwrite) PHRefreshTriggerView *triggerView;

@end

@implementation PHRefreshGestureRecognizer
@synthesize triggerView     = _triggerView;
@synthesize refreshState    = _refreshState;
@synthesize delegatex       = delegate_;
#pragma mark - Life Cycle
- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    
    if (self) {
        self.triggerView                    = [[PHRefreshTriggerView alloc] initWithFrame:CGRectZero];
        self.triggerView.titleLabel.text    = NSLocalizedString(@"下拉可以刷新", @"PHRefreshTriggerView default");
        self.scrollView.scrollsToTop = NO;
        
        [self addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"view"];
    //self.triggerView = nil;
}

- (void)refreshLastUpdatedDate {
	if ([delegate_ respondsToSelector:@selector(PHRefreshDataSourceLastUpdated:)]) {
		
		NSDate *date = [delegate_ PHRefreshDataSourceLastUpdated:self];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		self.triggerView.timeLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:self.triggerView.timeLabel.text forKey:@"PHRefresh_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		self.triggerView.timeLabel.text = nil;
		
	}
}



#pragma mark - Accessories
- (void)setRefreshState:(PHRefreshState)refreshState {
    if (refreshState != self->_refreshState) {
        __weak UIScrollView *bScrollView = self.scrollView;
        
        switch (refreshState) {
            case PHRefreshTriggered:
                self.triggerView.titleLabel.text = NSLocalizedString(@"释放可以刷新", @"PHRefreshTriggerView Triggered");
                break;
            case PHRefreshIdle:
                if (self->_refreshState == PHRefreshLoading) {
                    [self.triggerView.spin stopInfiniteAnimation];
                    [UIView animateWithDuration:0.2 animations:^{
                        bScrollView.contentInset = UIEdgeInsetsMake(0,
                                                                    self.scrollView.contentInset.left,
                                                                    self.scrollView.contentInset.bottom,
                                                                    self.scrollView.contentInset.right);
                    }];
                    
                    
                } else if (self->_refreshState == PHRefreshTriggered) {
                    
                }
                
                self.triggerView.titleLabel.text = NSLocalizedString(@"下拉可以刷新", @"PHRefreshTriggerView default");
                [self refreshLastUpdatedDate];
                break;
            case PHRefreshLoading:
                [Sound RefreshSound];
                [UIView animateWithDuration:0.2 animations:^{
                    bScrollView.contentInset = UIEdgeInsetsMake(64,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom,
                                                                self.scrollView.contentInset.right);
                }];
                self.triggerView.titleLabel.text = NSLocalizedString(@"刷新中...", @"PHRefreshTriggerView loading");
                [self.triggerView.spin startInfiniteAnimation];
                break;
        }
        
        self->_refreshState = refreshState;
    }
}

- (CABasicAnimation *)triggeredAnimation {
    CABasicAnimation *animation     = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration              = FLIP_ARROW_ANIMATION_TIME;
    animation.toValue               = [NSNumber numberWithDouble:M_PI];
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = NO;
    return animation;
}

- (CABasicAnimation *)idlingAnimation {
    CABasicAnimation *animation     = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.delegate              = self;
    animation.duration              = FLIP_ARROW_ANIMATION_TIME;
    animation.toValue               = [NSNumber numberWithDouble:0];
    animation.removedOnCompletion   = YES;
    return animation;
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.view;
}

#pragma mark - Key-Value Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id obj = [object valueForKeyPath:keyPath];
    if ([obj isKindOfClass:[UIScrollView class]]) {
        self->_triggerFlags.isBoundToScrollView = YES;
        self.triggerView.frame = CGRectMake(0, -64, CGRectGetWidth(self.view.frame), 64);
        [obj addSubview:self.triggerView];
    } else {
        self->_triggerFlags.isBoundToScrollView = NO;
    }
}

#pragma mark UIGestureRecognizer
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == PHRefreshLoading || !_triggerFlags.isBoundToScrollView)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == PHRefreshLoading)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    if (_triggerFlags.isBoundToScrollView)
        if (self.scrollView.contentOffset.y < -64) {
            self.refreshState = PHRefreshTriggered;
            self.triggerView.spin.progress = 99.9f;
        }
        else if (self.state != UIGestureRecognizerStateRecognized) {
            self.refreshState = PHRefreshIdle;
            self.triggerView.spin.progress = (-self.scrollView.contentOffset.y)/64.0 * 100.0 - 1.0;
        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == PHRefreshLoading)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    if (_triggerFlags.isBoundToScrollView)
        if (self.refreshState == PHRefreshTriggered)
        {
            self.refreshState = PHRefreshLoading;
            self.state = UIGestureRecognizerStateRecognized;
            [self.triggerView.spin startInfiniteAnimation];
        }
        else {
            self.refreshState = PHRefreshIdle;
            self.state = UIGestureRecognizerStateFailed;
        }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    self.state = UIGestureRecognizerStateFailed;
}

#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.triggerView.spin stopInfiniteAnimation];
}


@end


@implementation UIScrollView (PHRefreshGestureRecognizer)

- (PHRefreshGestureRecognizer *)refreshGestureRecognizer {
    PHRefreshGestureRecognizer *refreshRecognizer = nil;
    for (PHRefreshGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[PHRefreshGestureRecognizer class]]) {
            refreshRecognizer = recognizer;
        }
    }
    return refreshRecognizer;
}

@end
