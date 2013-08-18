//
//  OAuthWebView.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "MBProgressHUD.h"
#import "ECSlidingViewController.h"

@protocol AuthWebDelegate;
@interface OAuthWebView : UIViewController<UIWebViewDelegate>{
    UIWebView *webV;
    NSString *token;
    MBProgressHUD *HUD;
}
@property (nonatomic, assign) id<AuthWebDelegate> delegate;

@end
@protocol AuthWebDelegate <NSObject>

- (void) loginSucceed;

@end
