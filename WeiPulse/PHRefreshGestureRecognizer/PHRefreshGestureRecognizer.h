//
//  PHRefreshTriggerView.h
//  PHRefreshTriggerView
//
//  Created by Pier-Olivier Thibault on 11-12-19.
//  Copyright (c) 2011 25th Avenue. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import <UIKit/UIKit.h>
#import "PHRefreshTriggerView.h"

typedef enum {
    PHRefreshIdle = 0,
    PHRefreshTriggered,
    PHRefreshLoading
} PHRefreshState;

@protocol PHRefreshDelegate;
@interface PHRefreshGestureRecognizer : UIGestureRecognizer {
    PHRefreshState          _refreshState;
    PHRefreshTriggerView    *_triggerView;
    id __weak delegate_;
    
    struct {
        BOOL isBoundToScrollView:1;
    } _triggerFlags;
}

@property(nonatomic,weak) id <PHRefreshDelegate> delegatex;
@property (nonatomic, assign) PHRefreshState refreshState; // You can force a state by modifying this value.
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, readonly, strong) PHRefreshTriggerView *triggerView;

- (void) refreshLastUpdatedDate;

@end
@protocol PHRefreshDelegate
- (NSDate*) PHRefreshDataSourceLastUpdated:(PHRefreshGestureRecognizer*) object;
@end

@interface UIScrollView (PHRefreshGestureRecognizer)
- (PHRefreshGestureRecognizer *)refreshGestureRecognizer; //Will return nil if there's no gesture attached to that scrollview
@end

