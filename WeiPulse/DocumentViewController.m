//
//  DocumentViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-22.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, 320, 460);
        self.view.backgroundColor = [UIColor clearColor];
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(0, 460, 320, 460);
        [self.view addSubview:mainView];
        
        topView = [UIView new];
        topView.frame = CGRectMake(0, 0, 320, 40);
        topView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.];
        [mainView addSubview:topView];
        
        title = [UILabel new];
        title.frame = CGRectMake(0, 8, 320, 20);
        title.alpha = 0;
        title.textAlignment = UITextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.];
        [topView addSubview:title];
        
        close = [UIButton new];
        close.frame = CGRectMake(290, 8, 22, 22);
        [close setBackgroundImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:close];
        
        webV = [UIWebView new];
        webV.frame = CGRectMake(0, 40, 320, 420);
        [mainView addSubview:webV];
        
    }
    return self;
}

- (void)setLocalWeb:(NSString *)webUrl title:(NSString *)t
{
    NSString *fullPath = [NSBundle pathForResource:webUrl
                                            ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSURL* url = [NSURL fileURLWithPath:fullPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webV loadRequest:request];
    [title setText:t];
    [UIView animateWithDuration:0.3 animations:^{
        mainView.frame = CGRectMake(0, 0, 320, 460);
        title.alpha = 1;
    }];
}

- (void)exit
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 460, 320, 460);
    } completion:^(BOOL complete){
        UIViewController * temp = [UIViewController new];
        temp.view.userInteractionEnabled = NO;
        self.slidingViewController.topCoverViewController = temp;
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
