//
//  FansRightViewController.m
//  WeiPulse
//
//  Created by so898 on 12-7-31.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "FansRightViewController.h"

@interface FansRightViewController ()
@property (nonatomic, unsafe_unretained) CGFloat peekLeftAmount;
@end

@implementation FansRightViewController
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
    
    followBy = [UIButton new];
    followBy.frame = CGRectMake(17, 60, 40, 40);
    [followBy setTitle:@"粉丝" forState:UIControlStateNormal];
    [followBy addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    following = [UIButton buttonWithType:UIButtonTypeCustom];
    following.frame = CGRectMake(17, 110, 40, 40);
    [following setTitle:@"关注" forState:UIControlStateNormal];
    [following addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    biFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    biFollow.frame = CGRectMake(17, 160, 40, 40);
    [biFollow setTitle:@"互粉" forState:UIControlStateNormal];
    [biFollow addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:followBy];
    [self.view addSubview:following];
    [self.view addSubview:biFollow];
    
}

- (void)setType:(FansViewType)t
{
    type = t;
    if (type == FollowedBy){
        backg.frame = CGRectMake(0, 60, 70, 40);
    }
    if (type == Following){
        backg.frame = CGRectMake(0, 110, 70, 40);
    }
    if (type == TwoFollow){
        backg.frame = CGRectMake(0, 160, 70, 40);
    }
}

- (void)changeType:(id)sender
{
    if (sender == followBy && type != FollowedBy){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:FollowedBy];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 60, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = FollowedBy;
    } else if (sender == following && type != Following){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:Following];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 110, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = Following;
    } else if (sender == biFollow && type != TwoFollow){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:TwoFollow];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 160, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = TwoFollow;
    } else {
        [self.slidingViewController resetTopView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
