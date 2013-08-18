//
//  HotRightViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-2.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "HotRightViewController.h"

@interface HotRightViewController ()
@property (nonatomic, unsafe_unretained) CGFloat peekLeftAmount;
@end

@implementation HotRightViewController
@synthesize peekLeftAmount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.layer.shadowOpacity = 5.0f;
    self.view.layer.shadowRadius = 5.0f;
    self.view.layer.shadowColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.].CGColor;
    self.peekLeftAmount = 250.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cutted_backg"]];
    
    //Border
    border = [UIView new];
    border.frame = CGRectMake(0, 0, 4, 480);
    border.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    border.alpha = 0.8f;
    [self.view addSubview:border];
    
    backg = [UIView new];
    backg.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    backg.alpha = 0.8f;
    [self.view addSubview:backg];
    
    status = [UIButton new];
    status.frame = CGRectMake(8, 60, 60, 40);
    status.titleLabel.font = [UIFont systemFontOfSize:14];
    [status setTitle:@"热门转发" forState:UIControlStateNormal];
    [status addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = CGRectMake(8, 110, 60, 40);
    comment.titleLabel.font = [UIFont systemFontOfSize:14];
    [comment setTitle:@"热门评论" forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    /*mailMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    mailMessage.frame = CGRectMake(17, 160, 40, 40);
    [mailMessage setTitle:@"私信" forState:UIControlStateNormal];
    [mailMessage addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];*/
    
    
    [self.view addSubview:status];
    [self.view addSubview:comment];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setType:(HotViewType)t
{
    type = t;
    if (type == HotRepost){
        backg.frame = CGRectMake(0, 60, 70, 40);
    }
    if (type == HotComment){
        backg.frame = CGRectMake(0, 110, 70, 40);
    }
    /*if (type == MailMessage){
        backg.frame = CGRectMake(0, 160, 70, 40);
    }*/
}

- (void)changeType:(id)sender
{
    if (sender == status && type != HotRepost){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:HotRepost];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 60, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = HotRepost;
    } else if (sender == comment && type != HotComment){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:HotComment];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 110, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = HotComment;
    } /*else if (sender == mailMessage && type != MailMessage){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:MailMessage];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 160, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = MailMessage;
    } */else {
        [self.slidingViewController resetTopView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
