//
//  MessageRightViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-1.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageRightViewController.h"

@interface MessageRightViewController ()
@property (nonatomic, unsafe_unretained) CGFloat peekLeftAmount;
@end

@implementation MessageRightViewController
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
    
    type = AtMessage;
    
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
    
    atMessage = [UIButton new];
    atMessage.frame = CGRectMake(17, 60, 40, 40);
    [atMessage setTitle:@"转发" forState:UIControlStateNormal];
    [atMessage addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    commentMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    commentMessage.frame = CGRectMake(17, 110, 40, 40);
    [commentMessage setTitle:@"评论" forState:UIControlStateNormal];
    [commentMessage addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    //mailMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    //mailMessage.frame = CGRectMake(17, 160, 40, 40);
    //[mailMessage setTitle:@"私信" forState:UIControlStateNormal];
    //[mailMessage addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:atMessage];
    [self.view addSubview:commentMessage];
    //[self.view addSubview:mailMessage];
}

- (void)setType:(MessageViewType)t
{
    type = t;
    if (type == AtMessage){
        backg.frame = CGRectMake(0, 60, 70, 40);
    }
    if (type == CommentMessage){
        backg.frame = CGRectMake(0, 110, 70, 40);
    }
    if (type == MailMessage){
        backg.frame = CGRectMake(0, 160, 70, 40);
    }
}

- (void)changeType:(id)sender
{
    if (sender == atMessage && type != AtMessage){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:AtMessage];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 60, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = AtMessage;
    } else if (sender == commentMessage && type != CommentMessage){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:CommentMessage];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 110, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = CommentMessage;
    } else if (sender == mailMessage && type != MailMessage){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:MailMessage];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 160, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = MailMessage;
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
