//
//  NoticeViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-23.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "NoticeViewController.h"
#import "MTInfoPanel.h"
#import "StatusViewController.h"

static NoticeViewController * instance=nil;

@interface NoticeViewController ()

@end

@implementation NoticeViewController
@synthesize timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, 320, 460);
        self.view.userInteractionEnabled = NO;
    }
    return self;
}

+(NoticeViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[NoticeViewController new];
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
    unreadComment = 0;
    unreadRepost = 0;
    unreadFriend = 0;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUnreadCount:) name:MMSinaGotUnreadCount       object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed        object:nil];
    manager = [WeiBoMessageManager getInstance];
}

- (void)startTimer
{
    if (timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(timerOnActive) userInfo:nil repeats:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [defaultNotifCenter removeObserver:self name:MMSinaGotUnreadCount       object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
}

- (void)mmRequestFailed:(NSNotification *)sender
{
    NSString *note = sender.object;
    NSString *notic = [[NSString alloc] initWithFormat:@"网络连接失败\n%@",note];
    [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeError title:@"无法连接网络" subtitle:notic hideAfter:3.0];
}

-(void)didGetUnreadCount:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *sts_num = [dic objectForKey:@"status"];
    NSNumber *at_num = [dic objectForKey:@"mention_status"];
    NSNumber *cmt_num = [dic objectForKey:@"cmt"];
    //NSNumber *dm_num = [dic objectForKey:@"dm"];
    NSNumber *fo_num = [dic objectForKey:@"follower"];
    StatusViewController *status = [StatusViewController getInstance];
    
    if ([sts_num intValue] != 0) {
        NSString *notic = [[NSString alloc] initWithFormat:@"您有%@条未读消息，刷新主页可以查看。",sts_num];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeWarning title:@"未读消息" subtitle:notic hideAfter:3.0];
    }
    if ([at_num intValue] != 0 && [at_num intValue] > unreadRepost) {
        NSString *notic = [[NSString alloc] initWithFormat:@"您有%d条未读转发",[at_num intValue] - unreadRepost];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeWarning title:@"未读@消息" subtitle:notic hideAfter:3.0];
        [status setAt:[NSNumber numberWithInt:2]];
        unreadRepost = [at_num intValue];
    } else if ([at_num intValue] < unreadRepost){
        unreadRepost = 0;
    }
    if ([cmt_num intValue] != 0 && [cmt_num intValue] > unreadComment) {
        NSString *notic = [[NSString alloc] initWithFormat:@"您有%d条未读评论",[cmt_num intValue] - unreadComment];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeWarning title:@"未读评论" subtitle:notic hideAfter:3.0];
        [status setAt:[NSNumber numberWithInt:2]];
        unreadComment = [cmt_num intValue];
    } else if ([cmt_num intValue] < unreadComment){
        unreadComment = 0;
    }
    /*if ([dm_num intValue] != 0) {
     NSString *notic = [[NSString alloc] initWithFormat:@"您有%@条未读私信",dm_num];
     [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeWarning title:@"未读私信" subtitle:notic hideAfter:3.0];
     [status setAt:[NSNumber numberWithInt:2]];
     }*/
    if ([fo_num intValue] != 0 && [fo_num intValue] > unreadFriend) {
        NSString *notic = [[NSString alloc] initWithFormat:@"您有%@个新粉丝",fo_num];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeWarning title:@"新粉丝" subtitle:notic hideAfter:3.0];
        [status setMessage:[NSNumber numberWithInt:2]];
        unreadFriend = [fo_num intValue];
    } else if ([fo_num intValue] < unreadFriend)
        unreadFriend = 0;
}

-(void)timerOnActive
{
    [manager getUnreadCount:[[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
