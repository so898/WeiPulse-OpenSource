//
//  MenuViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MenuViewController.h"
#import "ASIHTTPRequest.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "HotViewController.h"
#import "FansViewController.h"
#import "PersonViewController.h"
#import "SettingViewController.h"
#import "BlockAlertView.h"
#import "Sound.h"

static MenuViewController * instance=nil;

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(MenuViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[MenuViewController new];
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
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backg"]];
    List = [UITableView new];
	// Do any additional setup after loading the view.
    
    avast_button = [UIView new];
    avast_button.frame = CGRectMake(10, 0, 320, 112);
    avast_button.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menu_avast_button"]];
    [self.view addSubview:avast_button];
    
    UIView *avastBackg = [UIView new];
    avastBackg.frame = CGRectMake(13, 3, 104, 104);
    avastBackg.backgroundColor = [UIColor colorWithRed:0.956863 green:0.956863 blue:0.956863 alpha:1.0];
    [self.view addSubview:avastBackg];
    
    avast = [UIImageView new];
    avast.frame = CGRectMake(15, 5, 100, 100);
    avast.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:avast];
    
    name = [UILabel new];
    name.frame = CGRectMake(125, 5, 125, 50);
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = UITextAlignmentLeft;
    name.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    name.textColor = [UIColor colorWithRed:0.956863 green:0.956863 blue:0.956863 alpha:1.0];
    name.shadowColor = [UIColor blackColor];
    name.shadowOffset = CGSizeMake(2, 2.0f);
    name.numberOfLines = 0;
    name.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:name];
    
    UIImage * backImage = [[UIImage imageNamed:@"sign_out_backg"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *otherBackImage = [[UIImage imageNamed:@"sign_out_backg_hover"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    signOut = [UIButton new];
    signOut.frame = CGRectMake(130, 70, 100, 30);
    [signOut setBackgroundImage:backImage forState:UIControlStateNormal];
    [signOut setBackgroundImage:otherBackImage forState:UIControlStateHighlighted];
    [signOut addTarget:self action:@selector(signOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOut];
    
    UIImageView *outLogo = [UIImageView new];
    outLogo.image = [UIImage imageNamed:@"sign_out"];
    outLogo.frame = CGRectMake(10, 6, 16, 16);
    [signOut addSubview:outLogo];
    
    UILabel *sign = [UILabel new];
    sign.text = @"登出";
    sign.backgroundColor = [UIColor clearColor];
    sign.frame = CGRectMake(45, 7, 40, 16);
    sign.font = [UIFont systemFontOfSize:16];
    sign.textColor = [UIColor blackColor];
    sign.shadowColor = [UIColor whiteColor];
    sign.shadowOffset = CGSizeMake(0, 1);
    [signOut addSubview:sign];
    
    List.frame = CGRectMake(10, 116, 310, 344);
    List.delegate = self;
    List.dataSource = self;
    List.backgroundColor = [UIColor clearColor];
    List.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:List];
    
    NSString *aname = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_NAME];
    if (aname.length != 0)
        [name setText:aname];
    NSString *aavast = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVAST];
    if (aavast.length != 0)
        [self setAvast:aavast];
    manager = [WeiBoMessageManager new];
    manager.delegate = self;
    _showMenu = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    if (indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"timeline"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"时间轴";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    } else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"message"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"消息";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    } else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"hot"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"热门";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    } else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"fans"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"粉丝";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    } else if (indexPath.row == 4){
        cell.imageView.image = [UIImage imageNamed:@"person"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"个人资料";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    } else if (indexPath.row == 5){
        cell.imageView.image = [UIImage imageNamed:@"setting"];
        cell.frame = CGRectMake(10, 116, 310, 55);
        cell.textLabel.text = @"设置";
        cell.textLabel.frame = CGRectMake(50, 0, 60, 55);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(2, 2);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_menu_cell"]]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_menu_cell"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self tlAction];
            break;
        case 1:
            [self messageAction];
            break;
        case 2:
            [self hotAction];
            break;
        case 3:
            [self fansAction];
            break;
        case 4:
            [self personAction];
            break;
        case 5:
            [self settingAction];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)reSetUser
{
    NSString *aname = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_NAME];
    if (aname.length != 0)
        [name setText:aname];
    NSString *aavast = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVAST];
    if (aavast.length != 0)
        [self setAvast:aavast];
}

- (void)setName:(NSString *)atext
{
    if (name.text.length == 0){
        [name setText:atext];
    }
}

- (void)setAvast:(NSString *)aurl
{
    if (!avast.image){
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", name.text, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            avast.image = [[UIImage alloc] initWithContentsOfFile: path];
        }
        else {
            NSURL *url = [NSURL URLWithString:aurl];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                avast.image = [[UIImage alloc] initWithContentsOfFile: path];
            }];
            [request startAsynchronous];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) signOutAction
{
    if (!_showMenu){
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"登出" message:@"您确定要登出么？"];
        [alert setDestructiveButtonWithTitle:@"登出" block:^{
            [manager signOut];
            _showMenu = NO;
        }];
        
        [alert setCancelButtonWithTitle:@"取消" block:^{
            _showMenu = NO;
        }];
        [alert show];
        _showMenu = YES;
    }
    
}

- (void)SignOut:(User *)auser
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    User *user = auser;
    if (user.userId == [userId longLongValue]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_AVAST];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_NAME];
        [MessageViewController deleteInstance];
        [HotViewController deleteInstance];
        [FansViewController deleteInstance];
        [PersonViewController deleteInstance];
        [SettingViewController deleteInstance];
        [StatusViewController deleteInstance];
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            [HomeViewController deleteInstance];
            HomeViewController *c = [HomeViewController getInstance];
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = c;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
            [avast removeFromSuperview];
            [name removeFromSuperview];
            avast = nil;
            name = nil;
            avast = [UIImageView new];
            avast.frame = CGRectMake(15, 5, 100, 100);
            avast.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:avast];
            name = [UILabel new];
            name.frame = CGRectMake(125, 5, 125, 50);
            name.backgroundColor = [UIColor clearColor];
            name.textAlignment = UITextAlignmentLeft;
            name.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
            name.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
            name.shadowColor = [UIColor blueColor];
            name.shadowOffset = CGSizeMake(0, -1.0f);
            name.numberOfLines = 0;
            name.lineBreakMode = UILineBreakModeWordWrap;
            [self.view addSubview:name];
        }];
    }
}

- (void) tlAction
{
    [Sound ClickSound];
    HomeViewController *x = [HomeViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setTimeLine:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) messageAction
{
    [Sound ClickSound];
    MessageViewController *x = [MessageViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setAt:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) hotAction
{
    [Sound ClickSound];
    HotViewController *x = [HotViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setReply:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) fansAction
{
    [Sound ClickSound];
    FansViewController *x = [FansViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setMessage:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) personAction
{
    [Sound ClickSound];
    PersonViewController *x = [PersonViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setPerson:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) settingAction
{
    [Sound ClickSound];
    SettingViewController *x = [SettingViewController getInstance];
    StatusViewController *status = [StatusViewController getInstance];
    [status setSetting:[NSNumber numberWithInt:1]];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = x;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end
