//
//  AddMessageViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "AddMessageViewController.h"

@interface AddMessageViewController ()
@property (nonatomic, unsafe_unretained) CGFloat peekLeftAmount;
@end

@implementation AddMessageViewController
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
    self.view.layer.shadowOpacity = 5.0f;
    self.view.layer.shadowRadius = 5.0f;
    self.view.layer.shadowColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.].CGColor;
    self.peekLeftAmount = 250.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cutted_backg"]];
	// Do any additional setup after loading the view.
    
    type = All;
    
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
    
    //Buttons
    addMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    addMessage.frame = CGRectMake(17, 10, 40, 40);
    [addMessage setBackgroundImage:[UIImage imageNamed:@"new_message"] forState:UIControlStateNormal];
    [addMessage addTarget:self action:@selector(addMessages:) forControlEvents:UIControlEventTouchUpInside];
    
    all = [UIButton buttonWithType:UIButtonTypeCustom];
    all.frame = CGRectMake(17, 60, 40, 40);
    [all setTitle:@"全部" forState:UIControlStateNormal];
    [all addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    original = [UIButton buttonWithType:UIButtonTypeCustom];
    original.frame = CGRectMake(17, 110, 40, 40);
    [original setTitle:@"原创" forState:UIControlStateNormal];
    [original addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIButton buttonWithType:UIButtonTypeCustom];
    image.frame = CGRectMake(17, 160, 40, 40);
    [image setTitle:@"图片" forState:UIControlStateNormal];
    [image addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    /*video = [UIButton buttonWithType:UIButtonTypeCustom];
    video.frame = CGRectMake(17, 210, 40, 40);
    [video setTitle:@"V" forState:UIControlStateNormal];
    
    music = [UIButton buttonWithType:UIButtonTypeCustom];
    music.frame = CGRectMake(17, 260, 40, 40);
    [music setTitle:@"M" forState:UIControlStateNormal];*/
    
    
    [self.view addSubview:addMessage];
    [self.view addSubview:all];
    [self.view addSubview:original];
    [self.view addSubview:image];
    //[self.view addSubview:video];
    //[self.view addSubview:music];
}

- (void)setType:(AddMessageViewType)t
{
    type = t;
    if (type == All){
        backg.frame = CGRectMake(0, 60, 70, 40);
    }
    if (type == Original){
        backg.frame = CGRectMake(0, 110, 70, 40);
    }
    if (type == Image){
        backg.frame = CGRectMake(0, 160, 70, 40);
    }
}

- (void)changeType:(id)sender
{
    if (sender == all && type != All){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:All];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 60, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = All;
    } else if (sender == original && type != Original){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:Original];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 110, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = Original;
    } else if (sender == image && type != Image){
        if ([self.delegate respondsToSelector:@selector(changeTypeFromRight:)]) {
            [self.delegate changeTypeFromRight:Image];
        }
        [UIView animateWithDuration:0.25f animations:^{backg.frame = CGRectMake(0, 160, 70, 40);} completion:^(BOOL complete){[self.slidingViewController resetTopView];}];
        type = Image;
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

- (void)addMessages :(id)addMessage
{
    AddMessage *a = [AddMessage new];
    [self.slidingViewController resetTopView];
    self.slidingViewController.topCoverViewController=a;
}

@end
