//
//  FansViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "FansViewController.h"
#import "MenuViewController.h"
#import "StatusViewController.h"
#import "LastCell.h"
#import "MTInfoPanel.h"
#import "UserDetailViewController.h"

static FansViewController * instance=nil;

@interface FansViewController ()

@end

@implementation FansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
        self.view.alpha = 1.0f;
        
        listener = NO;
        mainView = [UIView new];
        mainView.frame = CGRectMake(10, 0, 310, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        notice = [UILabel new];
        notice.text = @"您的此列表为空";
        notice.frame = CGRectMake(0, 20, 310, 30);
        notice.textAlignment = UITextAlignmentCenter;
        notice.textColor = [UIColor grayColor];
        notice.backgroundColor = [UIColor clearColor];
        notice.shadowColor = [UIColor whiteColor];
        notice.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:notice];
        
        mainTable = [UITableView new];
        mainTable.frame = CGRectMake(0, 0, 310, 460);
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

+(FansViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[FansViewController new];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 5.0f;
    MenuViewController *menu = [MenuViewController getInstance];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = menu;
    }
    right =[FansRightViewController new];
    if (![self.slidingViewController.underRightViewController isKindOfClass:[FansRightViewController class]]) {
        self.slidingViewController.underRightViewController = right;
    }
    right.delegate = self;
    [right setType:type];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (type == FollowedBy && followBy.count ==0){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        if (user && int_followBy != 2){
            [manager getFollowedUserList:user.userId count:50 cursor:0];
        }
    } else if (type == Following && following.count ==0){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        if (user && int_following != 2){
            [manager getFollowingUserList:user.userId count:50 cursor:0];
        }
    } else if (type == TwoFollow && twoFollow.count ==0){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        if (user && int_twoFollow != 2){
            [manager getBilateralUserListAll:user.userId sort:0];
        }
    }
    [self makeListeners];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 320, 460);
    
    followBy = [NSMutableArray new];
    following = [NSMutableArray new];
    twoFollow = [NSMutableArray new];
    type = FollowedBy;
    user = [User new];
    _followBy = NO;
    _following = NO;
    _twoFollow = NO;
    int_followBy = 2;
    int_following = 2;
    int_twoFollow = 2;
    cursorFollowBy = 0;
    cursorFollowing = 0;
    
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    manager = [WeiBoMessageManager getInstance];
    [manager getUserInfoWithUserID:[userId longLongValue]];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    
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

- (void)deleteListeners
{
    if (listener){
        listener = NO;
        [defaultNotifCenter removeObserver:self name:MMSinaGotFollowedUserList          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotFollowingUserList          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotBilateralUserList          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaUnfollowedByUserIDWithResult             object:nil];
    }
}

- (void)makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetFollowed:)    name:MMSinaGotFollowedUserList          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetFollowing:)    name:MMSinaGotFollowingUserList          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetTwoFollow:)    name:MMSinaGotBilateralUserList          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmFollowUser:)   name:MMSinaFollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmUnfollowUser:)   name:MMSinaUnfollowedByUserIDWithResult         object:nil];
    }
}

- (void)stateChanged :(UIGestureRecognizer *)gesture
{
    [self.slidingViewController resetTopView];
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (type == FollowedBy){
            int_followBy = 2;
            [manager getFollowedUserList:user.userId count:50 cursor:0];
        } else if (type == Following){
            int_following = 2;
            [manager getFollowingUserList:user.userId count:50 cursor:0];
        } else if (type == TwoFollow){
            int_twoFollow = 2;
            [manager getBilateralUserListAll:user.userId sort:0];
        }
    }
}

- (void)didGetUserInfo:(NSNotification *)sender
{
    user = sender.object;
    [manager getFollowedUserList:user.userId count:50 cursor:0];
    [manager getFollowingUserList:user.userId count:50 cursor:0];
    [manager getBilateralUserListAll:user.userId sort:0];
}

- (void)addMoreMessage
{
    if (type == FollowedBy){
        [manager getFollowedUserList:user.userId count:50 cursor:cursorFollowBy];
        int_followBy ++;
    } else if (type == Following){
        [manager getFollowingUserList:user.userId count:50 cursor:cursorFollowing];
        int_following ++;
    } else if (type == TwoFollow){
        [manager getBilateralIdList:user.userId count:50 page:int_twoFollow sort:0];
        int_twoFollow ++;
    }
}

- (void)didGetFollowed:(NSNotification *)sender
{
    NSDictionary * tmp = sender.object;
    NSArray *tmpArr = [tmp objectForKey:@"userArrary"];
    cursorFollowBy = [[tmp objectForKey:@"nextcursor"] intValue];
    if (int_followBy != 2){
        [followBy addObjectsFromArray:tmpArr];
    } else {
        [followBy removeAllObjects];
        [followBy addObjectsFromArray:tmpArr];
    }
    if (type == FollowedBy){
        [mainTable reloadData];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
        if (followBy.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    }
    _followBy = YES;
    
}

- (void)didGetFollowing:(NSNotification *)sender
{
    NSDictionary * tmp = sender.object;
    NSArray *tmpArr = [tmp objectForKey:@"userArrary"];
    cursorFollowing = [[tmp objectForKey:@"nextcursor"] intValue];
    if (int_following != 2){
        [following addObjectsFromArray:tmpArr];
    } else {
        [following removeAllObjects];
        [following addObjectsFromArray:tmpArr];
    }
    if (type == Following){
        [mainTable reloadData];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
        if (following.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    }
    _following = YES;
}

- (void)didGetTwoFollow:(NSNotification *)sender
{
    if (int_followBy != 2){
        [twoFollow addObjectsFromArray:(NSArray *)sender.object];
    } else {
        [twoFollow removeAllObjects];
        twoFollow = sender.object;
    }
    if (type == TwoFollow){
        [mainTable reloadData];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
        if (twoFollow.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    }
    _twoFollow = YES;
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

- (void)setType:(FansViewType)t
{
    type = t;
    if (_followBy && type == FollowedBy){
        [mainTable reloadData];
        if (followBy.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    } else if (type == FollowedBy){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    }
    if (_following && type == Following){
        [mainTable reloadData];
        if (following.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    } else if (type == Following){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    }
    if (_twoFollow && type == TwoFollow){
        if (twoFollow.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
        [mainTable reloadData];
    } else if (type == TwoFollow){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (type == FollowedBy){
        if (followBy.count == 0)
            return 0;
        else if (int_followBy !=2 && cursorFollowBy == 0)
            return followBy.count;
        else
            return followBy.count + 1;
    } else if (type == Following){
        if (following.count == 0)
            return 0;
        else if (int_following !=2 && cursorFollowing == 0)
            return following.count;
        else
            return following.count + 1;
    } else if (type == TwoFollow){
        if (twoFollow.count == 0)
            return 0;
        else if (twoFollow.count == user.biFollowersCount)
            return twoFollow.count;
        else
            return twoFollow.count + 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = (UITableView *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (type == FollowedBy){
        if (indexPath.row == followBy.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
        static NSString *cellIdentity = @"FansCell";
        FansUserCell *cell = (FansUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil) {
            cell = [[FansUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        cell.delegate = self;
        User *u = [followBy objectAtIndex:indexPath.row];
        [cell setUser:u];
        cell.frame = CGRectMake(0, 0, 320, 70);
        return cell;
    } else if (type == Following){
        if (indexPath.row == following.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
        static NSString *cellIdentity = @"FansCell";
        FansUserCell *cell = (FansUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil) {
            cell = [[FansUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        cell.delegate = self;
        User *u = [following objectAtIndex:indexPath.row];
        [cell setUser:u];
        cell.frame = CGRectMake(0, 0, 320, 70);
        return cell;
    } else if (type == TwoFollow){
        if (indexPath.row == twoFollow.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
        static NSString *cellIdentity = @"FansCell";
        FansUserCell *cell = (FansUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil) {
            cell = [[FansUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        cell.delegate = self;
        User *u = [twoFollow objectAtIndex:indexPath.row];
        [cell setType];
        [cell setUser:u];
        cell.frame = CGRectMake(0, 0, 320, 70);
        return cell;
    } else {
        static NSString *cellIdentity;
        LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil)
            cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.frame = CGRectMake(0, 0, 320, 50);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (type == FollowedBy){
        if (followBy.count == indexPath.row){
            [self addMoreMessage];
            return;
        }
        [self deleteListeners];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UserDetailViewController *detail = [UserDetailViewController new];
        self.slidingViewController.topCoverViewController = detail;
        User *u = [followBy objectAtIndex:indexPath.row];
        [detail setUser:u type:UserFromTopView];
    } else if (type == Following){
        if (following.count == indexPath.row){
            [self addMoreMessage];
            return;
        }
        [self deleteListeners];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UserDetailViewController *detail = [UserDetailViewController new];
        self.slidingViewController.topCoverViewController = detail;
        User *u = [following objectAtIndex:indexPath.row];
        [detail setUser:u type:UserFromTopView];
    } else if (type == TwoFollow){
        if (twoFollow.count == indexPath.row){
            [self addMoreMessage];
            return;
        }
        [self deleteListeners];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UserDetailViewController *detail = [UserDetailViewController new];
        self.slidingViewController.topCoverViewController = detail;
        User *u = [twoFollow objectAtIndex:indexPath.row];
        [detail setUser:u type:UserFromTopView];
    }
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

- (void)changeTypeFromRight:(FansViewType)t
{
    type = t;
    if (_followBy && type == FollowedBy){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (followBy.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        if (followBy.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    } else if (type == FollowedBy){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (followBy.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        notice.alpha = 0;
    }
    if (_following && type == Following){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (following.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        if (following.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    } else if (type == Following){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (following.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        notice.alpha = 0;
    }
    if (_twoFollow && type == TwoFollow){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (twoFollow.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        if (twoFollow.count != 0)
            notice.alpha = 0;
        else
            notice.alpha = 1;
    } else if (type == TwoFollow){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (twoFollow.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
        notice.alpha = 0;
    }
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
