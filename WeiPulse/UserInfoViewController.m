//
//  UserInfoViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ASIHTTPRequest.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0;
        self.view.frame = CGRectMake(0, 0, 320, 460);
        
        listener = NO;
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(320, 0, 320, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        UIView *titleBackg = [UIView new];
        titleBackg.frame = CGRectMake(0, 0, 320, 43);
        titleBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fans_detail_title"]];
        [mainView addSubview:titleBackg];
        
        title = [UILabel new];
        title.frame = CGRectMake(10, 9, 320, 20);
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"用户信息";
        [mainView addSubview:title];
        
        UIView *buttonBackg = [UIView new];
        buttonBackg.frame = CGRectMake(270, -2, 44, 44);
        buttonBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
        [mainView addSubview:buttonBackg];
        
        close = [UIButton new];
        close.frame = CGRectMake(275, 3, 35, 35);
        [close setImage:[UIImage imageNamed:@"exit_button"] forState:UIControlStateNormal];
        [close setImage:[UIImage imageNamed:@"exit_button_hl"] forState:UIControlStateHighlighted];
        [close addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:close];
        
        mainPart = [UIScrollView new];
        mainPart.frame = CGRectMake(0, 43, 320, 417);
        mainPart.alwaysBounceVertical = YES;
        mainPart.scrollsToTop = YES;
        mainPart.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [mainView addSubview:mainPart];
        
        avastBackg = [UIView new];
        avastBackg.frame = CGRectMake(4, 4, 86, 86);
        avastBackg.backgroundColor = [UIColor blackColor];
        avastBackg.layer.cornerRadius = 3;
        avastBackg.layer.masksToBounds = YES;
        [mainPart addSubview:avastBackg];
        
        avast = [UIImageView new];
        avast.frame = CGRectMake(3, 3, 80, 80);
        avast.backgroundColor = [UIColor blackColor];
        avast.alpha = 0.0f;
        [avastBackg addSubview:avast];
        
        v = [UIImageView new];
        v.frame = CGRectMake(74, 73, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        v.alpha = 0.0f;
        [mainPart addSubview:v];
        
        UILabel *one = [UILabel new];
        one.text = @"ID：";
        one.frame = CGRectMake(100, 10, 50, 20);
        one.backgroundColor = [UIColor clearColor];
        one.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:one];
        
        ID = [UILabel new];
        ID.frame = CGRectMake(155, 10, 155, 40);
        ID.numberOfLines = 0;
        ID.lineBreakMode = UILineBreakModeWordWrap;
        ID.backgroundColor = [UIColor clearColor];
        ID.font = [UIFont systemFontOfSize:16];
        ID.alpha = 0.0f;
        [mainPart addSubview:ID];
        
        UILabel *three = [UILabel new];
        three.text = @"性别：";
        three.frame = CGRectMake(10, 100, 50, 20);
        three.backgroundColor = [UIColor clearColor];
        three.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:three];
        
        sex = [UILabel new];
        sex.frame = CGRectMake(65, 100, 50, 20);
        sex.backgroundColor = [UIColor clearColor];
        sex.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:sex];
        
        UILabel *four = [UILabel new];
        four.text = @"位置：";
        four.frame = CGRectMake(10, 125, 50, 20);
        four.backgroundColor = [UIColor clearColor];
        four.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:four];
        
        location = [UILabel new];
        location.frame = CGRectMake(65, 125, 245, 20);
        location.backgroundColor = [UIColor clearColor];
        location.font = [UIFont systemFontOfSize:16];
        [location setTextColor:[UIColor blackColor]];
        [mainPart addSubview:location];
        
        height = 145;
    }
    return self;
}

- (void) otherBuild
{
    height += 5;
    UILabel *five = [UILabel new];
    five.text = @"个人介绍：";
    five.frame = CGRectMake(10, height, 100, 20);
    five.backgroundColor = [UIColor clearColor];
    five.font = [UIFont systemFontOfSize:16];
    [mainPart addSubview:five];
    height += 25;
    descript = [UILabel new];
    descript.frame = CGRectMake(10, height, 300, 80);
    descript.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    descript.font = [UIFont systemFontOfSize:16];
    [descript setTextColor:[UIColor blackColor]];
    descript.numberOfLines = 0;
    descript.lineBreakMode = UILineBreakModeWordWrap;
    descript.text = user.description;
    [mainPart addSubview:descript];
    height += 85;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) setUser:(User *)u type:(UserInfoViewType)t
{
    user = u;
    type = t;
    ID.text = user.screenName;
    [UIView animateWithDuration:0.3 animations:^{
        ID.alpha = 1.0f;
    }];
    if (user.remark.length != 0){
        UILabel *two = [UILabel new];
        two.text = @"昵称：";
        two.frame = CGRectMake(100, 55, 50, 20);
        two.backgroundColor = [UIColor clearColor];
        two.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:two];
        
        name = [UILabel new];
        name.frame = CGRectMake(155, 55, 155, 40);
        name.numberOfLines = 0;
        name.lineBreakMode = UILineBreakModeWordWrap;
        name.textAlignment = UITextAlignmentCenter;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:16];
        name.alpha = 0.0f;
        name.textColor = [UIColor grayColor];
        [mainPart addSubview:name];
        [name setText:user.remark];
        [UIView animateWithDuration:0.3 animations:^{name.alpha = 1.0;}];
    }
    if (user.gender == GenderMale){
        [sex setText:@"男"];
        [sex setTextColor:[UIColor blueColor]];
    }
    else if (user.gender == GenderFemale){
        [sex setText:@"女"];
        [sex setTextColor:[UIColor redColor]];
    }
    else if (user.gender == GenderUnknow)
        [sex setText:@"未知"];
    [location setText:user.location];
    if (user.verified){
        if (user.verifiedType == 0)
            v.alpha = 1;
        else {
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            v.alpha = 1;
        }
        height += 5;
        UILabel *five = [UILabel new];
        five.text = @"认证原因：";
        five.frame = CGRectMake(10, height, 100, 20);
        five.backgroundColor = [UIColor clearColor];
        five.font = [UIFont systemFontOfSize:16];
        [mainPart addSubview:five];
        height += 25;
        reason = [UILabel new];
        reason.frame = CGRectMake(10, height, 300, 80);
        reason.backgroundColor = [UIColor clearColor];
        reason.font = [UIFont systemFontOfSize:16];
        [reason setTextColor:[UIColor blackColor]];
        reason.numberOfLines = 0;
        reason.lineBreakMode = UILineBreakModeWordWrap;
        reason.textAlignment = UITextAlignmentCenter;
        reason.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
        reason.text = user.verifiedReason;
        [mainPart addSubview:reason];
        height += 85;
    } else if (user.verifiedType == 220){
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
        v.alpha = 1;
    }
    [self setAvast];
    [self otherBuild];
    mainPart.contentSize = CGSizeMake( 320, height);
    if (type == UserInfoFromTopCoverView && mainView.frame.origin.x != 0)
        mainView.frame = CGRectMake(0, 0, 320, 460);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0f;
        mainView.frame = CGRectMake(0, 0, 320, 460);
    }];
}

- (void) Exit
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (type == UserInfoFromTopView){
                             self.view.frame = CGRectMake(320, 0, 320, 460);
                         } else {
                             [self dismissModalViewControllerAnimated:YES];
                         }
                     }completion:^(BOOL complete){
                         if (type == UserInfoFromTopView){
                             if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                             }
                             UIViewController *tmp = [UIViewController new];
                             tmp.view.userInteractionEnabled = NO;
                             self.slidingViewController.topCoverViewController=tmp;
                         } else {
                             if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.parentViewController performSelector:@selector(makeListeners)];
                             }
                         }
                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAvast
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [user.profileLargeImageUrl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", user.screenName, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast.image = [[UIImage alloc] initWithContentsOfFile: path];
        [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
    }
    else {
        NSURL *url = [NSURL URLWithString:user.profileLargeImageUrl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast.image = [[UIImage alloc] initWithContentsOfFile: path];
            [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}

@end
