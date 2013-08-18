//
//  HotTypeView.h
//  WeiPulse
//
//  Created by so898 on 12-8-9.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"

@protocol HotTypeViewDelegate;
@interface HotTypeView : UIView<UITableViewDataSource, UITableViewDelegate>{
    UITableView *table;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    NSMutableArray *trends;
    UILabel *notice;
}

@property (nonatomic, assign) id<HotTypeViewDelegate> delegate;
- (void)loadView;

@end
@protocol HotTypeViewDelegate <NSObject>
- (void) returnHotTrend:(NSString *)trend;
@end