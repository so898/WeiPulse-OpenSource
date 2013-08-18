//
//  WebViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-6.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "WebViewController.h"
#import "BlockActionSheet.h"
#import "SHK.h"
#import "SHKCustomShareMenu.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
        title.frame = CGRectMake(10, 8, 270, 20);
        title.alpha = 0;
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.];
        [topView addSubview:title];
        
        close = [UIButton new];
        close.frame = CGRectMake(290, 4, 22, 22);
        [close setBackgroundImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:close];
        
        processBar = [YLProgressBar new];
        processBar.frame = CGRectMake(0, 30, 320, 9);
        processBar.progressTintColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        [topView addSubview:processBar];
        
        webV = [UIWebView new];
        webV.delegate = self;
        webV.frame = CGRectMake(0, 40, 320, 390);
        [mainView addSubview:webV];
        
        botView = [UIView new];
        botView.frame = CGRectMake(0, 420, 320, 43);
        botView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"web_botview_backg"]];
        [mainView addSubview:botView];
        
        back = [UIButton new];
        back.frame = CGRectMake(24, 14, 16, 16);
        [back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(webBack) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:back];
        
        forward = [UIButton new];
        forward.frame = CGRectMake(88, 14, 16, 16);
        [forward setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
        [forward addTarget:self action:@selector(webForward) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:forward];
        
        reload = [UIButton new];
        reload.frame = CGRectMake(153, 14, 14, 16);
        [reload setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [reload addTarget:self action:@selector(webReload) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:reload];
        
        stop = [UIButton new];
        stop.frame = CGRectMake(217, 15, 14, 14);
        [stop setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [stop addTarget:self action:@selector(webStop) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:stop];
        
        share = [UIButton new];
        share.frame = CGRectMake(280, 14, 16, 16);
        [share setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(webShare) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:share];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _showMenu = NO;
}

- (void)setWeb:(NSString *)webUrl type:(WebViewType)t
{
    type = t;
    NSString *tmp = [NSString new];
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WebReader"] intValue]) {
        case 2:
            tmp = [NSString stringWithFormat:@"http://h2w.iask.cn/h2wdisplay.php?u=%@",webUrl];
            break;
        case 3:
            tmp = [NSString stringWithFormat:@"http://gate.baidu.com/tc?from=opentc&src=%@",webUrl];
            break;
        case 4:
            tmp = [NSString stringWithFormat:@"http://www.google.com/gwt/x?u=%@",webUrl];
            break;
        default:
            tmp = webUrl;
            break;
    }
    NSURL *url = [NSURL URLWithString:tmp];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webV loadRequest:request];
    [UIView animateWithDuration:0.3 animations:^{
        mainView.frame = CGRectMake(0, 0, 320, 460);
    }];
}

- (void)setLocalWeb:(NSString *)webUrl
{
    NSURL *url = [NSURL URLWithString:webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webV loadRequest:request];
    [UIView animateWithDuration:0.3 animations:^{
        mainView.frame = CGRectMake(0, 0, 320, 460);
    }];
}

- (void)exit
{
    if (type == WebFromTopView){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 460, 320, 460);
        } completion:^(BOOL complete){
            UIViewController * temp = [UIViewController new];
            temp.view.userInteractionEnabled = NO;
            self.slidingViewController.topCoverViewController = temp;
        }];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)webBack
{
    [webV goBack];
}

- (void)webForward
{
    [webV goForward];
}

- (void)webReload
{
    [webV reload];
}

- (void)webStop
{
    [webV stopLoading];
    [UIView animateWithDuration:0.5 animations:^{processBar.alpha = 0;}];
}

- (void)webShare
{
    if (!_showMenu){
        BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"将当前页面页面..."];
        [sheet addButtonWithTitle:@"通过Safari打开" block:^{
            NSURL *linkUrl = [NSURL URLWithString:webV.request.URL.absoluteString];
            if ( ( [ [ linkUrl scheme ] isEqualToString: @"http" ] || [ [ linkUrl scheme ] isEqualToString: @"https" ] || [ [ linkUrl scheme ] isEqualToString: @"mailto" ])) {
                [ [ UIApplication sharedApplication ] openURL:linkUrl  ];
                return;
            }
            _showMenu = NO;
        }];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShareWeb"] intValue] == 1){
            [sheet addButtonWithTitle:@"分享到..." block:^{
                NSString *atitle = [webV pageTitle];
                
                // which can be used like:
                SHKItem *item = [SHKItem URL:webV.request.URL title:atitle];
                SHKShareMenu *shareMenu = [[SHKCustomShareMenu alloc] initWithStyle:UITableViewStyleGrouped];
                shareMenu.item = item;
                [[SHK currentHelper] showViewController:shareMenu];
                _showMenu = NO;
            }];
        }
        [sheet setCancelButtonWithTitle:@"取消" block:^{
            _showMenu = NO;
        }];
        [sheet showInView:self.view];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    if ([request respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WebReader"] intValue] == 1)
            [request setValue:[NSString stringWithFormat:@"%@ Safari/528.16", [request valueForHTTPHeaderField:@"User-Agent"]] forHTTPHeaderField:@"User_Agent"];
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WebReader"] intValue] == 0)
            [request setValue:[NSString stringWithFormat:@"%@ Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10", [request valueForHTTPHeaderField:@"User-Agent"]] forHTTPHeaderField:@"User_Agent"];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [processBar setProgress:0.1f animated:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(changeProgressValue)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)changeProgressValue
{
    float progressValue = processBar.progress;
    
    progressValue       += 0.01f;
    if (progressValue < 90)
    {
        [processBar setProgress:progressValue];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    title.text = [webView pageTitle];
    [processBar setProgress:1.f animated:YES];
    [UIView animateWithDuration:0.5 animations:^{processBar.alpha = 0;title.alpha = 1;}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
