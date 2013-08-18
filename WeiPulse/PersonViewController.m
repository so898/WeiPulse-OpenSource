//
//  PersonViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "PersonViewController.h"
#import "MenuViewController.h"
#import "BlockActionSheet.h"
#import "ASIHTTPRequest.h"
#import "LastCell.h"
#import "Status.h"
#import "MessageDetail.h"
#import "FansDetailViewController.h"
#import "ImageDetailViewController.h"
#import "UserDetailViewController.h"
#import "WebViewController.h"
#import "UserInfoViewController.h"

static PersonViewController * instance=nil;

@interface PersonViewController ()

@end

@implementation PersonViewController

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
        
        UIView *titleBackg = [UIView new];
        titleBackg.frame = CGRectMake(0, 0, 320, 105);
        titleBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"detail_title"]];
        [mainView addSubview:titleBackg];
        
        avastBackg = [UIView new];
        avastBackg.frame = CGRectMake(5, 4, 86, 86);
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
        
        UIImageView *title = [UIImageView new];
        title.image = [UIImage imageNamed:@"person_detail_name"];
        title.frame = CGRectMake(105, 8, 21, 20);
        [mainView addSubview:title];
        
        ID = [UILabel new];
        ID.frame = CGRectMake(131, 8, 169, 20);
        ID.numberOfLines = 0;
        ID.lineBreakMode = UILineBreakModeWordWrap;
        ID.backgroundColor = [UIColor clearColor];
        ID.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        ID.textColor = [UIColor blackColor];
        ID.alpha = 0.0f;
        [mainView addSubview:ID];
        
        UIImage * backImage = [[UIImage imageNamed:@"button_backg"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        followed = [UIButton new];
        followed.frame = CGRectMake(95, 30, 86, 72);
        [followed setBackgroundImage:backImage forState:UIControlStateNormal];
        [followed addTarget:self action:@selector(goToFansViewWithFollowing) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:followed];
        
        follow = [UILabel new];
        follow.frame = CGRectMake(5, 12, 76, 20);
        follow.backgroundColor = [UIColor clearColor];
        follow.textAlignment = UITextAlignmentCenter;
        [follow setTextColor:[UIColor whiteColor]];
        follow.text = @"0";
        [followed addSubview:follow];
        
        UILabel *tmp1 = [UILabel new];
        tmp1.frame = CGRectMake(5, 40, 76, 20);
        tmp1.text = @"关注";
        tmp1.backgroundColor = [UIColor clearColor];
        tmp1.textAlignment = UITextAlignmentCenter;
        [tmp1 setTextColor:[UIColor whiteColor]];
        [followed addSubview:tmp1];
        
        following = [UIButton new];
        following.frame = CGRectMake(177, 30, 86, 72);
        [following setBackgroundImage:backImage forState:UIControlStateNormal];
        [following addTarget:self action:@selector(goToFansViewWithFollowBy) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:following];
        
        fans = [UILabel new];
        fans.frame = CGRectMake(5, 12, 76, 20);
        fans.backgroundColor = [UIColor clearColor];
        fans.textAlignment = UITextAlignmentCenter;
        [fans setTextColor:[UIColor whiteColor]];
        fans.text = @"0";
        [following addSubview:fans];
        
        UILabel *tmp2 = [UILabel new];
        tmp2.frame = CGRectMake(5, 40, 76, 20);
        tmp2.text = @"粉丝";
        tmp2.backgroundColor = [UIColor clearColor];
        tmp2.textAlignment = UITextAlignmentCenter;
        [tmp2 setTextColor:[UIColor whiteColor]];
        [following addSubview:tmp2];
        
        UIView *buttonBackg5 = [UIView new];
        buttonBackg5.frame = CGRectMake(265, 50, 44, 44);
        buttonBackg5.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
        [mainView addSubview:buttonBackg5];
        
        more = [UIButton new];
        more.frame = CGRectMake(270, 55, 35, 35);
        //more.frame = CGRectMake(110, 65, 150, 35);
        [more setImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
        [more setImage:[UIImage imageNamed:@"more_button_hl"] forState:UIControlStateHighlighted];
        [more addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:more];
        
        mainTable = [UITableView new];
        mainTable.frame = CGRectMake(0, 105, 310, 355);
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.scrollsToTop = YES;
        mainTable.separatorStyle = NO;
        [mainView addSubview:mainTable];
    }
    return self;
}

+(PersonViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[PersonViewController new];
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
    self.slidingViewController.underRightViewController = nil;
    self.slidingViewController.anchorLeftPeekAmount     = 0;
    self.slidingViewController.anchorLeftRevealAmount   = 0;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self makeListeners];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    if (statuses.count == 0){
        [manager getUserStatusUserID:userId sinceID:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
    }
    if (ID.text.length == 0){
        [manager getUserInfoWithUserID:[userId longLongValue]];
    }
}

- (void) makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(didGetUserWeibo:)    name:MMSinaGotUserStatus          object:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 320, 460);
    statuses = [NSMutableArray new];
    _addMessage = NO;
    shouldHave = 0;
    user = [User new];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    manager = [WeiBoMessageManager getInstance];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deleteListeners];
}

- (void) deleteListeners
{
    if (listener){
        listener = NO;
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotUserStatus          object:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self deleteListeners];
}

- (void)changeSetting
{
    [mainTable reloadData];
}

- (void)didGetUserInfo:(NSNotification *)sender
{
    user = sender.object;
    [ID setText:user.screenName];
    [UIView animateWithDuration:0.3 animations:^{
        ID.alpha = 1.0f;
        if (user.verified)
            v.alpha = 1.0;
    }];
    [self setAvast];
    follow.text = [[NSString alloc] initWithFormat:@"%d",user.friendsCount];
    fans.text = [[NSString alloc] initWithFormat:@"%d",user.followersCount];
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

- (void)addMoreMessage
{
    _addMessage = YES;
    Status *tmp = [statuses objectAtIndex:(statuses.count-1)];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    [manager getUserStatusUserID:userId sinceID:-1 maxID:(tmp.statusId-1) count:50 page:-1 baseApp:-1 feature:-1];
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
    MessageDetail *detail = [MessageDetail new];
    [self deleteListeners];
    self.slidingViewController.topCoverViewController = detail;
    Status *sts = [statuses objectAtIndex:indexPath.row];
    [detail setStatus:sts type:MessageFromTopView];
}

- (void)goToFansViewWithFollowBy
{
    FansDetailViewController *f = [FansDetailViewController new];
    [f setDetail:FollowedBy type:FansDetailFromTopView];
    [self deleteListeners];
    self.slidingViewController.topCoverViewController = f;
}

- (void)goToFansViewWithFollowing
{
    FansDetailViewController *f = [FansDetailViewController new];
    [f setDetail:Following type:FansDetailFromTopView];
    [self deleteListeners];
    self.slidingViewController.topCoverViewController = f;
}

- (void)More
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:nil];
    
    /*[sheet addButtonWithTitle:@"我的话题" block:^{
        //[self postStatusToMail];
        _showManu = NO;
    }];*/
    
    [sheet addButtonWithTitle:@"我的资料" block:^{
        [self showUserInfo];
        _showManu = NO;
    }];

    [sheet setCancelButtonWithTitle:@"取消" block:^{
            _showManu = NO;
    }];
    [sheet showInView:self.view];
    _showManu = YES;    
}

- (void)showUserInfo
{
    [self deleteListeners];
    UserInfoViewController *i = [UserInfoViewController new];
    self.slidingViewController.topCoverViewController = i;
    [i setUser:user type:UserInfoFromTopView];
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

- (void) openImage:(NSString *)imgURL
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [imageDetail setImageUrl:imgURL type:ImageFromTopView];
    imageDetail.view.frame = CGRectMake(0, 0, 320, 460);
    self.slidingViewController.topCoverViewController = imageDetail;
}

- (void) openTheURL:(NSString *)url
{
    WebViewController *web = [WebViewController new];
    [web setWeb:url type:WebFromTopView];
    self.slidingViewController.topCoverViewController = web;
}

- (void) openUserDetail:(NSString *)name
{
    [self deleteListeners];
    UserDetailViewController *userDetail = [UserDetailViewController new];
    [userDetail setUserName:name type:UserFromTopView];
    self.slidingViewController.topCoverViewController = userDetail;
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
