//
//  StatusViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-10.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "StatusViewController.h"

static StatusViewController * instance=nil;

@interface StatusViewController ()

@end

@implementation StatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(StatusViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[StatusViewController new];
        }
    }
    return instance;
}

+ (void)deleteInstance
{
    @synchronized(self) {
        if (instance!=nil) {
            instance = nil;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 10, 480);
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage * backImage = [[UIImage imageNamed:@"normal_bar_button"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    avast_d = [[UIImageView alloc] initWithImage:backImage];
    avast_d.frame = CGRectMake(0, 0, 10, 112);
    [self.view addSubview:avast_d];
    
    handle = [UIView new];
    handle.backgroundColor = [UIColor clearColor];
    handle.frame = CGRectMake(0, 116, 10, 500);
    [self.view addSubview:handle];
    
    tl_d = [[UIImageView alloc] initWithImage:backImage];
    tl_d.frame = CGRectMake(0, 0, 10, 55);
    [handle addSubview:tl_d];
    
    at_d = [[UIImageView alloc] initWithImage:backImage];
    at_d.frame = CGRectMake(0, 55, 10, 55);
    [handle addSubview:at_d];
    
    reply_d = [[UIImageView alloc] initWithImage:backImage];
    reply_d.frame = CGRectMake(0, 110, 10, 55);
    [handle addSubview:reply_d];
    
    message_d = [[UIImageView alloc] initWithImage:backImage];
    message_d.frame = CGRectMake(0, 165, 10, 55);
    [handle addSubview:message_d];
    
    person_d = [[UIImageView alloc] initWithImage:backImage];
    person_d.frame = CGRectMake(0, 220, 10, 55);
    [handle addSubview:person_d];
    
    setting_d = [[UIImageView alloc] initWithImage:backImage];
    setting_d.frame = CGRectMake(0, 275, 10, 55);
    [handle addSubview:setting_d];
    
    //=================================================================================================
    
    UIImage * backImage2 = [[UIImage imageNamed:@"active_bar_button"] stretchableImageWithLeftCapWidth:0 topCapHeight:12];
    
    avast_s = [[UIImageView alloc] initWithImage:backImage2];
    avast_s.frame = CGRectMake(0, -12, 30, 136);
    [self.view addSubview:avast_s];
    
    tl_s = [[UIImageView alloc] initWithImage:backImage2];
    tl_s.frame = CGRectMake(0, -12, 30, 77);
    [handle addSubview:tl_s];
    
    at_s = [[UIImageView alloc] initWithImage:backImage2];
    at_s.frame = CGRectMake(0, 43, 30, 77);
    [handle addSubview:at_s];
    
    reply_s = [[UIImageView alloc] initWithImage:backImage2];
    reply_s.frame = CGRectMake(0, 98, 30, 77);
    [handle addSubview:reply_s];
    
    message_s = [[UIImageView alloc] initWithImage:backImage2];
    message_s.frame = CGRectMake(0, 153, 30, 77);
    [handle addSubview:message_s];
    
    person_s = [[UIImageView alloc] initWithImage:backImage2];
    person_s.frame = CGRectMake(0, 208, 30, 77);
    [handle addSubview:person_s];
    
    setting_s = [[UIImageView alloc] initWithImage:backImage2];
    setting_s.frame = CGRectMake(0, 263, 30, 77);
    [handle addSubview:setting_s];
    
    //=================================================================================================
    
    UIImage * backImage3 = [[UIImage imageNamed:@"position_bar_button"] stretchableImageWithLeftCapWidth:0 topCapHeight:12];
    
    avast_p = [[UIImageView alloc] initWithImage:backImage3];
    avast_p.frame = CGRectMake(0, -12, 30, 136);
    [self.view addSubview:avast_p];
    
    tl_p = [[UIImageView alloc] initWithImage:backImage3];
    tl_p.frame = CGRectMake(0, -12, 30, 77);
    [handle addSubview:tl_p];
    
    at_p = [[UIImageView alloc] initWithImage:backImage3];
    at_p.frame = CGRectMake(0, 43, 30, 77);
    [handle addSubview:at_p];
    
    reply_p = [[UIImageView alloc] initWithImage:backImage3];
    reply_p.frame = CGRectMake(0, 98, 30, 77);
    [handle addSubview:reply_p];
    
    message_p = [[UIImageView alloc] initWithImage:backImage3];
    message_p.frame = CGRectMake(0, 153, 30, 77);
    [handle addSubview:message_p];
    
    person_p = [[UIImageView alloc] initWithImage:backImage3];
    person_p.frame = CGRectMake(0, 208, 30, 77);
    [handle addSubview:person_p];
    
    setting_p = [[UIImageView alloc] initWithImage:backImage3];
    setting_p.frame = CGRectMake(0, 263, 30, 77);
    [handle addSubview:setting_p];
    
    //=================================================================================================
    
    avast_s.alpha = 0.0;
    tl_s.alpha = 0.0;
    at_s.alpha = 0.0;
    reply_s.alpha = 0.0;
    message_s.alpha = 0.0;
    person_s.alpha = 0.0;
    setting_s.alpha = 0.0;
    avast_p.alpha = 0.0;
    tl_p.alpha = 0.0;
    at_p.alpha = 0.0;
    reply_p.alpha = 0.0;
    message_p.alpha = 0.0;
    person_p.alpha = 0.0;
    setting_p.alpha = 0.0;

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

- (void)setAvast:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            avast_p.alpha = 1.0;
            tl_p.alpha = 0.0;
            at_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            message_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            avast_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            avast_s.alpha = 1.0;
        }];
    }
}

- (void)setTimeLine:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            tl_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            at_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            message_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            tl_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            tl_s.alpha = 1.0;
        }];
    }
}

- (void)setAt:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            at_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            tl_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            message_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            at_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            at_s.alpha = 1.0;
        }];
    }
}

- (void)setReply:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            reply_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            tl_p.alpha = 0.0;
            at_p.alpha = 0.0;
            message_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            reply_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            reply_s.alpha = 1.0;
        }];
    }
}

- (void)setMessage:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            message_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            tl_p.alpha = 0.0;
            at_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            message_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            message_s.alpha = 1.0;
        }];
    }
}

- (void)setPerson:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            person_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            tl_p.alpha = 0.0;
            at_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            message_p.alpha = 0.0;
            setting_p.alpha = 0.0;
            person_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            person_s.alpha = 1.0;
        }];
    }
}

- (void)setSetting:(NSNumber *)situations
{
    int situation = [situations intValue];
    if (situation == 1){
        [UIView animateWithDuration:0.5 animations:^{
            setting_p.alpha = 1.0;
            avast_p.alpha = 0.0;
            tl_p.alpha = 0.0;
            at_p.alpha = 0.0;
            reply_p.alpha = 0.0;
            message_p.alpha = 0.0;
            person_p.alpha = 0.0;
            setting_s.alpha = 0.0;
        }];
    }else if (situation == 2){
        [UIView animateWithDuration:0.5 animations:^{
            setting_s.alpha = 1.0;
        }];
    }
}

@end
