//
//  OAuthWebView.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "OAuthWebView.h"
#import "WeiBoHttpManager.h"

@implementation OAuthWebView


- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}

//剥离出url中的access_token的值
- (void) dialogDidSucceed:(NSURL*)url {
    NSString *q = [url absoluteString];
    token = [self getStringFromUrl:q needle:@"access_token="];
    
    //用户点取消 error_code=21330
    NSString *errorCode = [self getStringFromUrl:q needle:@"error_code="];
    if (errorCode != nil && [errorCode isEqualToString: @"21330"]) {
        NSLog(@"Oauth canceled");
        WeiBoHttpManager *weiboHttpManager = [[WeiBoHttpManager alloc]initWithDelegate:self];
        NSURL *url = [weiboHttpManager getOauthCodeUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [webV loadRequest:request];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = (id)self;
        HUD.labelText = @"请稍等";
        HUD.detailsLabelText = @"正在加载页面";
        HUD.square = YES;
        [HUD show:YES];
    }
    
    NSString *refreshToken  = [self getStringFromUrl:q needle:@"refresh_token="];
    NSString *expTime       = [self getStringFromUrl:q needle:@"expires_in="];
    NSString *uid           = [self getStringFromUrl:q needle:@"uid="];
    NSString *remindIn      = [self getStringFromUrl:q needle:@"remind_in="];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSDate *expirationDate =nil;
    NSLog(@"jtone \n\ntoken=%@\nrefreshToken=%@\nexpTime=%@\nuid=%@\nremindIn=%@\n\n",token,refreshToken,expTime,uid,remindIn);
    if (expTime != nil) {
        int expVal = [expTime intValue]-3600;
        if (expVal == 0) 
        {
            
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
			NSLog(@"jtone time = %@",expirationDate);
        } 
    } 
    if (token) {
        if ([self.delegate respondsToSelector:@selector(loginSucceed)]){
            [self.delegate performSelector:@selector(loginSucceed)];
        }
        //[self.navigationController popViewControllerAnimated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{self.view.frame = CGRectMake(0, 460, 320, 460);} completion:^(BOOL complete){
            [HUD removeFromSuperview];
            HUD = nil;
            [webV removeFromSuperview];
            UIViewController *a = [UIViewController new];
            a.view.userInteractionEnabled = NO;
            self.slidingViewController.topCoverViewController = a;
            
            
        }];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 460, 320, 460);
    
    webV = [UIWebView new];
    webV.frame = CGRectMake(0, 0, 320, 460);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.view.alpha = 0.0f;
    webV.delegate = self;
    WeiBoHttpManager *weiboHttpManager = [[WeiBoHttpManager alloc]initWithDelegate:self];
    NSURL *url = [weiboHttpManager getOauthCodeUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    webV.scrollView.scrollsToTop = NO;
	[webV loadRequest:request];
    [self.view addSubview:webV];
    [UIView animateWithDuration:0.5 animations:^{self.view.alpha = 1.0f;self.view.frame = CGRectMake(0, 0, 320, 480);}];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    webV = nil;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
	NSURL *url = [request URL];
    NSLog(@"webview's url = %@",url);
	NSArray *array = [[url absoluteString] componentsSeparatedByString:@"#"];
	if ([array count]>1) {
		[self dialogDidSucceed:url];
		return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = (id)self;
    HUD.labelText = @"请稍等";
    HUD.detailsLabelText = @"正在加载页面";
    HUD.square = YES;
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

@end
