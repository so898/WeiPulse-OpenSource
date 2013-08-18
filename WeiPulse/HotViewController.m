//
//  HotViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "HotViewController.h"
#import "MenuViewController.h"
#import "MessageDetail.h"
#import "ImageDetailViewController.h"
#import "UserDetailViewController.h"
#import "WebViewController.h"

static HotViewController * instance=nil;

@interface HotViewController ()

@end

@implementation HotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, 320, 460);
        self.view.backgroundColor = [UIColor clearColor];
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(10, 0, 310, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        mainTable = [UITableView new];
        mainTable.frame = CGRectMake(0, 0, 310, 460);
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.scrollsToTop = YES;
        mainTable.separatorStyle = NO;
        mainTable.backgroundColor = [UIColor clearColor];
        [mainView addSubview:mainTable];
        
        PHRefreshGestureRecognizer *PHR = [[PHRefreshGestureRecognizer alloc] initWithTarget:self action:@selector(stateChanged:)];
        [mainTable addGestureRecognizer:PHR];
        
    }
    return self;
}

+ (HotViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[HotViewController new];
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

+ (BOOL)returnInstance
{
    @synchronized(self) {
        if (instance!=nil) {
            return YES;
        } else
            return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 5.0f;
    MenuViewController *menu = [MenuViewController getInstance];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = menu;
    }
    HotRightViewController *rightView = [HotRightViewController new];
    if (![self.slidingViewController.underRightViewController isKindOfClass:[HotRightViewController class]]) {
        self.slidingViewController.underRightViewController  = rightView;
    }
    rightView.delegate = self;
    [rightView setType:type];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    if (type == HotRepost && !shouldStatus)
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    else if (type == HotComment && !shouldComment)
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    statuses = [NSMutableArray new];
    comments = [NSMutableArray new];
    shouldComment = YES;
    shouldStatus = YES;
    type = HotRepost;
    
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    [defaultNotifCenter addObserver:self selector:@selector(didGetRepost:)    name:MMSinaGotHotRepostDaily          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetComment:)    name:MMSinaGotHotCommentDaily          object:nil];
    
    manager = [WeiBoMessageManager getInstance];
    [manager getHotRepostDaily:50];
    [manager getHotCommnetDaily:50];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [defaultNotifCenter removeObserver:self name:MMSinaGotHotRepostDaily          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHotCommentDaily          object:nil];
}

- (void)stateChanged :(UIGestureRecognizer *)gesture
{
    [self.slidingViewController resetTopView];
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (type == HotRepost){
            [manager getHotRepostDaily:50];
            shouldStatus = YES;
        } else if (type == HotComment){
            [manager getHotCommnetDaily:50];
            shouldComment = YES;
        }
        
    }
}

- (void)changeSetting
{
    [mainTable reloadData];
}

- (void)didGetRepost:(NSNotification *)sender
{
    [statuses removeAllObjects];
    statuses = sender.object;
    if (type == HotRepost){
        [mainTable reloadData];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
        shouldStatus = NO;
    }
}

- (void)didGetComment:(NSNotification *)sender
{
    [comments removeAllObjects];
    comments = sender.object;
    if (type == HotComment){
        [mainTable reloadData];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
        shouldComment = NO;
    }
}

#pragma mark -
#pragma mark uitalbleviewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return statuses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = (UITableView *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.slidingViewController resetTopView];
    static NSString *cellIdentity = @"Cell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    Status *sts = [Status new];
    if (type == HotRepost)
        sts = [statuses objectAtIndex:indexPath.row];
    else
        sts = [comments objectAtIndex:indexPath.row];
    [cell setStatus:sts];
    cell.delegate = self;
    cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.slidingViewController resetTopView];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageDetail *detail = [MessageDetail new];
    self.slidingViewController.topCoverViewController = detail;
    Status *sts = [Status new];
    if (type == HotRepost)
        sts = [statuses objectAtIndex:indexPath.row];
    else
        sts = [comments objectAtIndex:indexPath.row];
    [detail setStatus:sts type:MessageFromTopView];
}

- (void) openImage:(NSString *)imgURL
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [imageDetail setImageUrl:imgURL type:ImageFromTopView];
    imageDetail.view.frame = CGRectMake(0, 0, 320, 460);
    self.slidingViewController.topCoverViewController = imageDetail;
}

- (void) openAvast:(User *)u
{
    UserDetailViewController *userDetail = [UserDetailViewController new];
    [userDetail setUser:u type:UserFromTopView];
    self.slidingViewController.topCoverViewController = userDetail;
}

- (void) openTheURL:(NSString *)url
{
    WebViewController *web = [WebViewController new];
    [web setWeb:url type:WebFromTopView];
    self.slidingViewController.topCoverViewController = web;
}

- (void) openUserDetail:(NSString *)name
{
    UserDetailViewController *userDetail = [UserDetailViewController new];
    [userDetail setUserName:name type:UserFromTopView];
    self.slidingViewController.topCoverViewController = userDetail;
}

- (void)changeTypeFromRight:(HotViewType)t
{
    type = t;
    if (type == HotRepost){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (statuses.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
    if (type == HotComment){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (comments.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
    /*if (type == MailMessage){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (mail.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }*/
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slidingViewController resetTopView];
}

- (NSDate*)PHRefreshDataSourceLastUpdated:(PHRefreshGestureRecognizer*)object{
	return [NSDate date]; // should return date data source was last changed
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
