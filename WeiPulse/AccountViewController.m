//
//  AccountViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-10.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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
    self.view.frame = CGRectMake(0, 0, 320, 460);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *accounts = [UITableView new];
    accounts.frame = CGRectMake(0, 0, 320, 406);
    [self.view addSubview:accounts];
    
    UIView *botBackg = [UIView new];
    botBackg.backgroundColor = [UIColor redColor];
    botBackg.frame = CGRectMake(0, 406, 320, 54);
    [self.view addSubview:botBackg];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    add.frame = CGRectMake(10, 411, 44, 44);
    [self.view addSubview:add];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancel.frame = CGRectMake(266, 411, 44, 44);
    [self.view addSubview:cancel];
    
    
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
