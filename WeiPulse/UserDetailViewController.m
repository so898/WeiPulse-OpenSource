//
//  UserDetailViewController.m
//  WeiPulse
//
//  Created by so898 on 12-8-2.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "UserDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "Status.h"
#import "LastCell.h"
#import "MessageDetail.h"
#import "MTInfoPanel.h"
#import "BlockActionSheet.h"
#import "WebViewController.h"
#import "ImageDetailViewController.h"
#import "FansDetailViewController.h"
#import "AddMessage.h"
#import "UserInfoViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0;
        self.view.frame = CGRectMake(0, 0, 320, 460);
        
        listener = NO;
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(320, 0, 320, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        UIView *titleBackg = [UIView new];
        titleBackg.frame = CGRectMake(0, 0, 320, 165);
        titleBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"user_detail_title"]];
        [mainView addSubview:titleBackg];
        
        avastBackg = [UIView new];
        avastBackg.frame = CGRectMake(4, 4, 86, 86);
        avastBackg.backgroundColor = [UIColor blackColor];
        avastBackg.layer.cornerRadius = 3;
        avastBackg.layer.masksToBounds = YES;
        [mainView addSubview:avastBackg];
        
        avast = [UIImageView new];
        avast.frame = CGRectMake(3, 3, 80, 80);
        avast.backgroundColor = [UIColor blackColor];
        avast.alpha = 0.0f;
        [avastBackg addSubview:avast];
        
        v = [UIImageView new];
        v.frame = CGRectMake(74, 73, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        v.alpha = 0.0f;
        [mainView addSubview:v];
        
        UIImageView *sexSign = [UIImageView new];
        sexSign.image = [UIImage imageNamed:@"sex_sign"];
        sexSign.frame = CGRectMake(110, 10, 21, 20);
        [mainView addSubview:sexSign];
        
        sex = [UILabel new];
        sex.frame = CGRectMake(135, 10, 40, 20);
        sex.backgroundColor = [UIColor clearColor];
        sex.font = [UIFont systemFontOfSize:16];
        [mainView addSubview:sex];
        
        UIImageView *locationSign = [UIImageView new];
        locationSign.image = [UIImage imageNamed:@"location_sign"];
        locationSign.frame = CGRectMake(110, 40, 21, 20);
        [mainView addSubview:locationSign];
        
        location = [UILabel new];
        location.frame = CGRectMake(135, 40, 135, 20);
        location.backgroundColor = [UIColor clearColor];
        location.font = [UIFont systemFontOfSize:16];
        [location setTextColor:[UIColor blackColor]];
        [mainView addSubview:location];
        
        ID = [UILabel new];
        ID.frame = CGRectMake(6, 95, 84, 32);
        ID.numberOfLines = 0;
        ID.lineBreakMode = UILineBreakModeWordWrap;
        ID.textAlignment = UITextAlignmentCenter;
        ID.backgroundColor = [UIColor clearColor];
        ID.font = [UIFont systemFontOfSize:14];
        ID.alpha = 0.0f;
        [mainView addSubview:ID];
        
        name = [UILabel new];
        name.frame = CGRectMake(6, 128, 84, 28);
        name.numberOfLines = 0;
        name.lineBreakMode = UILineBreakModeWordWrap;
        name.textAlignment = UITextAlignmentCenter;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:14];
        name.alpha = 0.0f;
        name.textColor = [UIColor grayColor];
        [mainView addSubview:name];
        
        UIImage * backImage = [[UIImage imageNamed:@"button_backg"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        followed = [UIButton new];
        followed.frame = CGRectMake(96, 68, 173, 43);
        [followed setBackgroundImage:backImage forState:UIControlStateNormal];
        [followed addTarget:self action:@selector(goToFansViewWithFollowing) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:followed];
        
        follow = [UILabel new];
        follow.frame = CGRectMake(70, 12, 90, 20);
        follow.backgroundColor = [UIColor clearColor];
        follow.textAlignment = UITextAlignmentCenter;
        [follow setTextColor:[UIColor whiteColor]];
        follow.text = @"0";
        [followed addSubview:follow];
        
        UILabel *tmp1 = [UILabel new];
        tmp1.frame = CGRectMake(10, 12, 60, 20);
        tmp1.text = @"关注：";
        tmp1.backgroundColor = [UIColor clearColor];
        tmp1.textAlignment = UITextAlignmentCenter;
        [tmp1 setTextColor:[UIColor whiteColor]];
        [followed addSubview:tmp1];
        
        following = [UIButton new];
        following.frame = CGRectMake(96, 113, 173, 43);
        [following setBackgroundImage:backImage forState:UIControlStateNormal];
        [following addTarget:self action:@selector(goToFansViewWithFollowBy) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:following];
        
        fans = [UILabel new];
        fans.frame = CGRectMake(70, 12, 90, 20);
        fans.backgroundColor = [UIColor clearColor];
        fans.textAlignment = UITextAlignmentCenter;
        [fans setTextColor:[UIColor whiteColor]];
        fans.text = @"0";
        [following addSubview:fans];
        
        UILabel *tmp2 = [UILabel new];
        tmp2.frame = CGRectMake(10, 12, 60, 20);
        tmp2.text = @"粉丝：";
        tmp2.backgroundColor = [UIColor clearColor];
        tmp2.textAlignment = UITextAlignmentCenter;
        [tmp2 setTextColor:[UIColor whiteColor]];
        [following addSubview:tmp2];
        
        UIView *buttonBackg = [UIView new];
        buttonBackg.frame = CGRectMake(270, 4, 44, 44);
        buttonBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
        [mainView addSubview:buttonBackg];
        
        close = [UIButton new];
        close.frame = CGRectMake(275, 9, 35, 35);
        [close setImage:[UIImage imageNamed:@"exit_button"] forState:UIControlStateNormal];
        [close setImage:[UIImage imageNamed:@"exit_button_hl"] forState:UIControlStateHighlighted];
        [close addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:close];
        
        UIView *buttonBackg5 = [UIView new];
        buttonBackg5.frame = CGRectMake(270, 50, 44, 44);
        buttonBackg5.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
        [mainView addSubview:buttonBackg5];
        
        more = [UIButton new];
        more.frame = CGRectMake(275, 55, 35, 35);
        //more.frame = CGRectMake(110, 65, 150, 35);
        [more setImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
        [more setImage:[UIImage imageNamed:@"more_button_hl"] forState:UIControlStateHighlighted];
        [more addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:more];
        
        mainTable = [UITableView new];
        mainTable.frame = CGRectMake(0, 165, 320, 295);
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.scrollsToTop = NO;
        mainTable.separatorStyle = NO;
        [mainView addSubview:mainTable];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self makeListeners];
}

- (void)makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserWeibo:)    name:MMSinaGotUserStatus          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmGotFriendShips:)   name:MMSinaGotFriendShips        object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmFollowUser:)   name:MMSinaFollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmUnfollowUser:)   name:MMSinaUnfollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    statuses = [NSMutableArray new];
    _addMessage = NO;
    shouldHave = 0;
    user = [User new];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    manager = [WeiBoMessageManager getInstance];
}

- (void)setUser:(User *)u type:(UserDetailViewType)t
{
    user = u;
    type = t;
    [manager getUserStatusUserID:[[NSString alloc] initWithFormat:@"%lld",user.userId] sinceID:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    [manager getFriendShips:[userId longLongValue] sourceName:nil targetId:user.userId targetName:nil];
    _showManu = NO;
    ID.text = user.screenName;
    [UIView animateWithDuration:0.3 animations:^{
        ID.alpha = 1.0f;
    }];
    if (user.remark.length != 0){
        [name setText:[[NSString alloc] initWithFormat:@"(%@)",user.remark]];
        [UIView animateWithDuration:0.3 animations:^{name.alpha = 1.0;}];
    }
    if (user.gender == GenderMale){
        [sex setText:@"男"];
        [sex setTextColor:[UIColor blueColor]];
    }
    else if (user.gender == GenderFemale){
        [sex setText:@"女"];
        [sex setTextColor:[UIColor redColor]];
    }
    else if (user.gender == GenderUnknow)
        [sex setText:@"未知"];
    [location setText:user.location];
    if (user.verified){
        if (user.verifiedType == 0)
            v.alpha = 1;
        else {
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            v.alpha = 1;
        }
    } else if (user.verifiedType == 220){
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
        v.alpha = 1;
    }
    [self setAvast];
    if ([userId longLongValue] == user.userId)
        _self = YES;
    else
        _self = NO;
    follow.text = [[NSString alloc] initWithFormat:@"%d",user.friendsCount];
    fans.text = [[NSString alloc] initWithFormat:@"%d",user.followersCount];
    if (type == UserFromTopCoverView && mainView.frame.origin.x != 0)
        mainView.frame = CGRectMake(0, 0, 320, 460);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0f;
        mainView.frame = CGRectMake(0, 0, 320, 460);
    }];
}

- (void) setUserName:(NSString *)aname type:(UserDetailViewType)t
{
    type = t;
    [manager getUserInfoWithUserName:aname];
    if (type == UserFromTopView){
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 1.0f;
            mainView.frame = CGRectMake(0, 0, 320, 460);
        }];
    } else {
        mainView.frame = CGRectMake(0, 460, 320, 460);
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 1.0f;
            mainView.frame = CGRectMake(0, 0, 320, 460);
        }];
    }
}

- (void)didGetUserInfo:(NSNotification *)sender
{
    User *auser = sender.object;
    [self setUser:auser type:type];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deleteListeners];
}

- (void)deleteListeners
{
    if (listener){
        listener = NO;
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserStatus          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotFriendShips            object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaUnfollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo             object:nil];
    }
    
}

- (void)didGetUserWeibo:(NSNotification *)sender
{
    shouldHave ++;
    if (!_addMessage){
        [statuses removeAllObjects];
        statuses = sender.object;
        [mainTable reloadData];
    } else {
        NSMutableArray *tmp = sender.object;
        [statuses addObjectsFromArray:tmp];
        [mainTable reloadData];
    }
}

- (void)mmGotFriendShips :(NSNotification *)sender
{
    NSDictionary *result = sender.object;
    NSString *followeds = [result objectForKey:@"followed_by"];
    if ([followeds intValue] == 1)
        _followed = YES;
    else
        _followed = NO;
    NSString *followings = [result objectForKey:@"following"];
    if ([followings intValue] == 1)
        _following = YES;
    else
        _following = NO;
}

- (void)mmFollowUser: (NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"关注%@成功", user.screenName];
        [MTInfoPanel showPanelInView:self.view type:MTInfoPanelTypeSuccess
                               title:@"关注"
                            subtitle:title
                           hideAfter:3.0];
        _followed = YES;
    }
}

- (void)mmUnfollowUser:(NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"已取消关注%@", user.screenName];
        [MTInfoPanel showPanelInView:self.view type:MTInfoPanelTypeSuccess
                                                    title:@"关注"
                                                 subtitle:title
                                                hideAfter:3.0];
        _followed = NO;
        if ([self.slidingViewController.topViewController respondsToSelector:@selector(refreshAllStatues)]) {
            [self.slidingViewController.topViewController performSelector:@selector(refreshAllStatues)];
        }
    }
}

- (void) Exit
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (type == UserFromTopView){
                             self.view.frame = CGRectMake(320, 0, 320, 460);
                             self.view.alpha = 0.0f;
                         } else {
                             [self dismissModalViewControllerAnimated:YES];
                         }
                     }completion:^(BOOL complete){
                         if (type == UserFromTopView){
                             if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                             }
                             UIViewController *tmp = [UIViewController new];
                             tmp.view.userInteractionEnabled = NO;
                             self.slidingViewController.topCoverViewController=tmp;
                         } else {
                             if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.parentViewController performSelector:@selector(makeListeners)];
                             }
                         }
                     }];
    
}

- (void)addMoreMessage
{
    _addMessage = YES;
    Status *tmp = [statuses objectAtIndex:(statuses.count-1)];
    [manager getUserStatusUserID:[[NSString alloc] initWithFormat:@"%lld",user.userId] sinceID:-1 maxID:(tmp.statusId-1) count:50 page:-1 baseApp:-1 feature:-1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return [[NSString alloc] initWithFormat:@"总微博数：%d",user.statusesCount];
    }else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil){
        return nil;
    }
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(20, 3, 300, 16);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.];
    label.textColor = [UIColor blackColor];
    label.text = sectionTitle;
    UIView *titleLine_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, tableView.bounds.size.width, 2)];
    titleLine_2.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    sectionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5f];
    [sectionView addSubview:label];
    [sectionView addSubview:titleLine_2];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (statuses.count == 0)
        return 0;
    else if (statuses.count == shouldHave * 50)
        return statuses.count + 1;
    else
        return statuses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = (UITableView *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity;
    if (indexPath.row == statuses.count){
        LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil)
            cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.frame = CGRectMake(0, 0, 320, 50);
        return cell;
    }
    
    MessageSmallCell *cell = (MessageSmallCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[MessageSmallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    Status *sts = [statuses objectAtIndex:indexPath.row];
    [cell setStatus:sts];
    cell.delegate = self;
    cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == statuses.count){
        [self addMoreMessage];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self deleteListeners];
    MessageDetail *detail = [MessageDetail new];
    Status *sts = [statuses objectAtIndex:indexPath.row];
    [self presentModalViewController:detail animated:YES];
    [detail setStatus:sts type:MessageFromTopCoverView];
}

- (void) openImage:(NSString *)imgURL
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [imageDetail setImageUrl:imgURL type:ImageFromTopCoverView];
    imageDetail.view.frame = CGRectMake(0, 0, 320, 460);
    [self presentModalViewController:imageDetail animated:YES];
}

- (void) openTheURL:(NSString *)url
{
    WebViewController *web = [WebViewController new];
    [web setWeb:url type:WebFromTopCoverView];
    [self presentModalViewController:web animated:YES];
}

- (void) openUserDetail:(NSString *)aname
{
    [self deleteListeners];
    UserDetailViewController *userDetail = [UserDetailViewController new];
    [userDetail setUserName:aname type:UserFromTopCoverView];
    [self presentModalViewController:userDetail animated:YES];
}

- (void)goToFansViewWithFollowBy
{
    FansDetailViewController *f = [FansDetailViewController new];
    [f setDetail:FollowedBy user:user type:UserFromTopCoverView];
    [self deleteListeners];
    [self presentModalViewController:f animated:YES];
}

- (void)goToFansViewWithFollowing
{
    FansDetailViewController *f = [FansDetailViewController new];
    [f setDetail:Following user:user type:FansDetailFromTopCoverView];
    [self deleteListeners];
    [self presentModalViewController:f animated:YES];
}

- (void)More
{
    if (!_showManu){
        NSString *showString = nil;
        if (_following)
            showString = [[NSString alloc]initWithFormat:@"%@\n关注了你", user.screenName];
        else if (!_self)
            showString = [[NSString alloc]initWithFormat:@"%@\n没有关注你", user.screenName];
        else
            showString = nil;
        BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:showString];
        if (_self){
            /*[sheet addButtonWithTitle:@"我的话题" block:^{
                //[self postStatusToMail];
                _showManu = NO;
            }];*/
            
            [sheet addButtonWithTitle:@"我的资料" block:^{
                [self showUserInfo];
                _showManu = NO;
            }];
        }
        else {
            if (_followed){
                [sheet setDestructiveButtonWithTitle:@"取消关注用户" block:^{
                    [manager unfollowByUserID:user.userId];
                    _showManu = NO;
                }];
            } else {
                [sheet addButtonWithTitle:@"关注用户" block:^{
                    [manager followByUserID:user.userId];
                    _showManu = NO;
                }];
            }
            
            if (user.gender == GenderMale){
                [sheet addButtonWithTitle:@"@他" block:^{
                    [self AtSomeone];
                    _showManu = NO;
                }];
                [sheet addButtonWithTitle:@"他的资料" block:^{
                    [self showUserInfo];
                    _showManu = NO;
                }];
            } else if (user.gender == GenderFemale) {
                [sheet addButtonWithTitle:@"@她" block:^{
                    [self AtSomeone];
                    _showManu = NO;
                }];
                [sheet addButtonWithTitle:@"她的资料" block:^{
                    [self showUserInfo];
                    _showManu = NO;
                }];
            } else {
                [sheet addButtonWithTitle:@"@他/她" block:^{
                    [self AtSomeone];
                    _showManu = NO;
                }];
                [sheet addButtonWithTitle:@"他/她的资料" block:^{
                    [self showUserInfo];
                    _showManu = NO;
                }];
            }
        }
        
        [sheet setCancelButtonWithTitle:@"取消" block:^{
            _showManu = NO;
        }];
        [sheet showInView:self.view];
        _showManu = YES;
    }
}

- (void)showUserInfo
{
    [self deleteListeners];
    UserInfoViewController *userInfo = [UserInfoViewController new];
    [userInfo setUser:user type:UserInfoFromTopCoverView];
    [self presentModalViewController:userInfo animated:YES];
}

- (void) AtSomeone
{
    AddMessage *a = [AddMessage new];
    [a setUser:user.screenName type:AddMessageFromTopCoverView];
    [self presentModalViewController:a animated:YES];
}

- (void)setAvast
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [user.profileLargeImageUrl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", user.screenName, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast.image = [[UIImage alloc] initWithContentsOfFile: path];
        [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
    }
    else {
        NSURL *url = [NSURL URLWithString:user.profileLargeImageUrl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast.image = [[UIImage alloc] initWithContentsOfFile: path];
            [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
