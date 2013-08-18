//
//  DocumentViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-22.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface DocumentViewController : UIViewController{
    UIWebView *webV;
    UIView *topView, *mainView;
    UIButton *close;
    UILabel *title;
}

- (void) setLocalWeb:(NSString *)webUrl title:(NSString *)t;

@end
