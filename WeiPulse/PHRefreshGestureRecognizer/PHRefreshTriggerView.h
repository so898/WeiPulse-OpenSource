//
//  PHRefreshTriggerView.h
//  PHRefreshTriggerView
//
//  Created by Pier-Olivier Thibault on 11-12-20.
//  Copyright (c) 2011 25th Avenue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshSpin;
@interface PHRefreshTriggerView : UIView {
    UILabel                 *_titleLabel, *_timeLabel;
    RefreshSpin             *_spin;
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) RefreshSpin *spin;

@end
