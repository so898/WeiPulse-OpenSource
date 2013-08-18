//
//  FansDetailViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-21.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "FansDetailViewController.h"
#import "LastCell.h"
#import "MTInfoPanel.h"
#import "UserDetailViewController.h"

@interface FansDetailViewController ()

@end

@implementation FansDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 1.0f;
        
        listener = NO;
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(0, 0, 320, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        UIView *titleBackg = [UIView new];
        titleBackg.frame = CGRectMake(0, 0, 320, 43);
        titleBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fans_detail_title"]];
        [mainView addSubview:titleBackg];
        
        name = [UILabel new];
        name.frame = CGRectMake(10, 9, 320, 20);
        name.textColor = [UIColor whiteColor];
        name.backgroundColor = [UIColor clearColor];
        [mainView addSubview:name];
        
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
        
        notice = [UILabel new];
        notice.text = @"此列表为空";
        notice.frame = CGRectMake(0, 63, 320, 30);
        notice.textAlignment = UITextAlignmentCenter;
        notice.textColor = [UIColor grayColor];
        notice.backgroundColor = [UIColor clearColor];
        notice.shadowColor = [UIColor whiteColor];
        notice.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:notice];
        
        mainTable = [UITableView new];
        mainTable.frame = CGRectMake(0, 42, 320, 418);
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.scrollsToTop = YES;
        mainTable.separatorStyle = NO;
        mainTable.backgroundColor = [UIColor clearColor];
        mainTable.contentOffset = CGPointMake(0, 0);
        [mainView addSubview:mainTable];
        
        PHRefreshGestureRecognizer *PHR = [[PHRefreshGestureRecognizer alloc] initWithTarget:self action:@selector(stateChanged:)];
        [mainTable addGestureRecognizer:PHR];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self makeListeners];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 460, 320, 460);
    fans = [NSMutableArray new];
    user = [User new];
    cursor = 0;
    int_fans = 2;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    manager = [WeiBoMessageManager getInstance];
}

- (void) setDetail:(FansViewType)t user:(User *)u type:(FansDetailViewType)t2
{
    fType = t;
    type = t2;
    [manager getUserInfoWithUserID:u.userId];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    if (type == FansDetailFromTopView){
        [UIView animateWithDuration:0.3 animations:^{self.view.frame = CGRectMake(0, 0, 320, 460);}];
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }
}

- (void) setDetail:(FansViewType)t type:(FansDetailViewType)t2
{
    fType = t;
    type = t2;
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    [manager getUserInfoWithUserID:[userId longLongValue]];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    if (type == FansDetailFromTopView){
        [UIView animateWithDuration:0.3 animations:^{self.view.frame = CGRectMake(0, 0, 320, 460);}];
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deleteListeners];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetFollowed:)    name:MMSinaGotFollowedUserList          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetFollowing:)    name:MMSinaGotFollowingUserList          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmFollowUser:)   name:MMSinaFollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmUnfollowUser:)   name:MMSinaUnfollowedByUserIDWithResult         object:nil];
    }
    
}

- (void)deleteListeners
{
    if (listener){
        listener = NO;
        [defaultNotifCenter removeObserver:self name:MMSinaGotFollowedUserList          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotFollowingUserList          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaUnfollowedByUserIDWithResult             object:nil];
    }
    
}

- (void)stateChanged :(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        int_fans = 2;
        if (fType == FollowedBy){
            [manager getFollowedUserList:user.userId count:50 cursor:0];
        } else if (fType == Following){
            [manager getFollowingUserList:user.userId count:50 cursor:0];
        }
    }
}

- (void)didGetUserInfo:(NSNotification *)sender
{
    user = sender.object;
    if (fType == FollowedBy){
        [name setText:[NSString stringWithFormat:@"%@的粉丝",user.screenName]];
        [manager getFollowedUserList:user.userId count:50 cursor:0];
    }
    else if (fType == Following){
        [name setText:[NSString stringWithFormat:@"%@关注的人",user.screenName]];
        [manager getFollowingUserList:user.userId count:50 cursor:0];
    }
}

- (void)addMoreMessage
{
    int_fans++;
    if (fType == FollowedBy){
        [manager getFollowedUserList:user.userId count:50 cursor:cursor];
    } else if (fType == Following){
        [manager getFollowingUserList:user.userId count:50 cursor:cursor];
    }
}

- (void)didGetFollowed:(NSNotification *)sender
{
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    NSDictionary * tmp = sender.object;
    NSArray *tmpArr = [tmp objectForKey:@"userArrary"];
    cursor = [[tmp objectForKey:@"nextcursor"] intValue];
    if (int_fans != 2){
        [fans addObjectsFromArray:tmpArr];
    } else {
        [fans removeAllObjects];
        [fans addObjectsFromArray:tmpArr];
    }
    [mainTable reloadData];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    if (fans.count != 0)
        notice.alpha = 0;
    else
        notice.alpha = 1;
}

- (void)didGetFollowing:(NSNotification *)sender
{
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    NSDictionary * tmp = sender.object;
    NSArray *tmpArr = [tmp objectForKey:@"userArrary"];
    cursor = [[tmp objectForKey:@"nextcursor"] intValue];
    if (int_fans != 2){
        [fans addObjectsFromArray:tmpArr];
    } else {
        [fans removeAllObjects];
        [fans addObjectsFromArray:tmpArr];
    }
    [mainTable reloadData];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    if (fans.count != 0)
        notice.alpha = 0;
    else
        notice.alpha = 1;
}

- (void)mmFollowUser: (NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (tmp_user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        [manager getUserInfoWithUserID:user.userId];
        
        NSString *title = [[NSString alloc] initWithFormat:@"关注%@成功", tmp_user.screenName];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"关注"
                            subtitle:title
                           hideAfter:3.0];
    }
}

- (void)mmUnfollowUser:(NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (tmp_user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        [manager getUserInfoWithUserID:user.userId];
        
        NSString *title = [[NSString alloc] initWithFormat:@"已取消关注%@", tmp_user.screenName];
        UIViewController *tmp = [UIViewController new];
        tmp.view.userInteractionEnabled = NO;
        self.slidingViewController.topCoverViewController=tmp;
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"关注"
                            subtitle:title
                           hideAfter:3.0];
    }
}

- (void)Exit
{
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    if (type == FansDetailFromTopCoverView){
        if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
            [self.parentViewController performSelector:@selector(makeListeners)];
        }
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [UIView animateWithDuration:0.5
                         animations:^{
                            self.view.frame = CGRectMake(0, 460, 320, 460);
                            self.view.alpha = 0.0f;
                         }completion:^(BOOL complete){
                            if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                     [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                            }
                            UIViewController *tmp = [UIViewController new];
                            tmp.view.userInteractionEnabled = NO;
                            self.slidingViewController.topCoverViewController=tmp;
        }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fans.count == 0)
        return 0;
    else if (int_fans !=2 && cursor == 0)
        return fans.count;
    else
        return fans.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = (UITableView *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d",indexPath.row);
    static NSString *cellIdentity;
    if (indexPath.row == fans.count){
        LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil)
            cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.frame = CGRectMake(0, 0, 320, 50);
        return cell;
    }
    FansUserCell *cell = (FansUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[FansUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.delegate = self;
    User *u = [fans objectAtIndex:indexPath.row];
    [cell setUser:u];
    cell.frame = CGRectMake(0, 0, 320, 70);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (fans.count == indexPath.row){
        [self addMoreMessage];
        return;
    }
    [self deleteListeners];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailViewController *detail = [UserDetailViewController new];
    User *u = [fans objectAtIndex:indexPath.row];
    [detail setUser:u type:UserFromTopCoverView];
    [self presentModalViewController:detail animated:YES];
}

- (void)removeUserFromFollow:(User *)u
{
    tmp_user = u;
    [manager unfollowByUserID:u.userId];
}

- (void)addUserToFollow:(User *)u
{
    tmp_user = u;
    [manager followByUserID:u.userId];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slidingViewController resetTopView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
