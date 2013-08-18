//
//  WebViewController.h
//  WeiPulse
//
//  Created by so898 on 12-8-6.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "YLProgressBar.h"

typedef enum {
    WebFromTopCoverView,
    WebFromTopView,
}WebViewType;

@interface WebViewController : UIViewController<UIWebViewDelegate>{
    UIWebView *webV;
    WebViewType type;
    UIView *topView, *botView, *mainView;
    UIButton *close, *back, *forward, *stop, *reload, *share;
    BOOL _showMenu;
    YLProgressBar *processBar;
    NSTimer *timer;
    UILabel *title;
}

- (void) setWeb:(NSString *)webUrl type:(WebViewType)t;
- (void) setLocalWeb:(NSString *)webUrl;

@end
