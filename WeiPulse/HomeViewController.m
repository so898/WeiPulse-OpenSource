//
//  HomeViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "MTInfoPanel.h"
#import "LastCell.h"
#import "MessageDetail.h"
#import "TableBackgView.h"
#import "ImageDetailViewController.h"
#import "UserDetailViewController.h"
#import "WebViewController.h"
#import "MenuViewController.h"
#import "ReplyViewController.h"

static HomeViewController * instance=nil;

@interface HomeViewController (Private)

- (void)removeCachedOAuthDataForUsername:(NSString *) username;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(HomeViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[HomeViewController new];
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
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 5.0f;
    self.view.backgroundColor = [UIColor clearColor];
    MenuViewController *menu = [MenuViewController getInstance];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = menu;
    }
    right =[AddMessageViewController new];
    if (![self.slidingViewController.underRightViewController isKindOfClass:[AddMessageViewController class]]) {
        self.slidingViewController.underRightViewController = right;
    }
    StatusViewController *status = [StatusViewController getInstance];
    self.slidingViewController.coverViewController=status;
    [status setTimeLine:[NSNumber numberWithInt:1]];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [right setType:type];
    right.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    type = All;
    listener = NO;
    NoticeViewController *n = [NoticeViewController getInstance];
    self.slidingViewController.noticeViewController = n;
    statuses = [[NSMutableArray alloc] init];
    s_ori = [NSMutableArray new];
    s_pic = [NSMutableArray new];
    stsArr = [[NSMutableArray alloc] init];
    oriArr = [NSMutableArray new];
    picArr = [NSMutableArray new];
    userID = [NSString new];
    manager = [WeiBoMessageManager getInstance];
    manager.delegate = self;
    firstRefresh = YES;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    update = YES;
    tapCount = 0;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backg"]];
	// Do any additional setup after loading the view.
    mainView = [UIView new];
    mainView.frame = CGRectMake(10, 0, 310, 460);
    mainView.layer.cornerRadius = 6;
    mainView.layer.masksToBounds = YES;
    mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
    [self.view addSubview:mainView];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 310, 460) style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.scrollsToTop = YES;
    mainTable.separatorStyle = NO;
    [mainView addSubview:mainTable];
    PHRefreshGestureRecognizer *PHR = [[PHRefreshGestureRecognizer alloc] initWithTarget:self action:@selector(stateChanged:)];
    PHR.delegatex = (id)self;
    [mainTable addGestureRecognizer:PHR];
    [PHR refreshLastUpdatedDate];
    
    //reFresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //reFresh.frame = CGRectMake(265, 415, 40, 40);
    //[reFresh setBackgroundImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateNormal];
    //[reFresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    //reFresh.alpha = 0.5f;
    //[mainView addSubview:reFresh];
    
    
    [defaultNotifCenter addObserver:self selector:@selector(appWillClose)     name:UIApplicationWillResignActiveNotification             object:nil];
    startView = [StartScreenView new];
    [self.slidingViewController.noticeViewController.view addSubview:startView];
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)loginSucceed
{
    shouldLoad = YES;
    [manager getUserID];
    [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
    [right setType:All];
    type = All;
}

-(void)getDataFromCD
{
    if (!statuses || statuses.count == 0) {
        statuses = [[NSMutableArray alloc] initWithCapacity:70];
        NSArray *arr = [[CoreDataManager getInstance] readStatusesFromCD];
        if (arr && arr.count != 0) {
            for (int i = 0; i < arr.count; i++) 
            {
                StatusCDItem *s = [arr objectAtIndex:i];
                Status *sts = [Status new];
                sts = [sts updataStatusFromStatusCDItem:s];
                [statuses insertObject:sts atIndex:s.index.intValue];
            }
        }
    }
    [mainTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (update){
        update = NO;
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
        NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"will login");
        if (authToken == nil || [manager isNeedToRefreshTheToken]) 
        {
            webV = [OAuthWebView new];
            webV.delegate = self;
            webV.hidesBottomBarWhenPushed = YES;
            self.slidingViewController.topCoverViewController = webV;
        }
        else
        {
            [self getDataFromCD];
            if (!statuses || statuses.count == 0) {
                [manager getUserID];
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
                firstRefresh = YES;
            }else {
                firstRefresh = NO;
                updateUp = YES;
                Status *sts = [statuses objectAtIndex:0];
                [manager getUserID];
                [manager getHomeLine:(sts.statusId) maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
            }
            
        }
        
    }
}

- (void)RequestFailed:(NSString *)error
{
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    [startView disappear];
}

-(void)GetUserID:(NSString *)user;
{
    userID = user;
    if (userID != [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID]){
        [[CoreDataManager getInstance] cleanEntityRecords:@"StatusCDItem"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_AVAST];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_NAME];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [manager getUserInfoWithUserID:[userID longLongValue]];
}

- (void)NoReturn
{
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    [startView disappear];
    self.slidingViewController.noticeViewController = [NoticeViewController getInstance];
}

-(void)GetHomeLine:(NSArray *)statusArr
{
    if (type == All){
        if (firstRefresh){
            [statuses removeAllObjects];
            statuses = [NSMutableArray arrayWithArray:statusArr];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }else if (updateUp){
            NSMutableArray *tmp1 = [NSMutableArray arrayWithArray:statusArr];
            if (tmp1.count >= 50){
                [statuses removeAllObjects];
                statuses = [NSMutableArray arrayWithArray:statusArr];
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
            else{
                NSMutableArray *tmp2 = tmp1;
                [tmp2 addObjectsFromArray:statuses];
                [statuses removeAllObjects];
                statuses = tmp2;
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
        }else {
            NSArray *tmp = [NSMutableArray arrayWithArray:statusArr];
            [statuses addObjectsFromArray:tmp];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }
    } else if (type == Original){
        if (firstRefresh){
            [s_ori removeAllObjects];
            s_ori = [NSMutableArray arrayWithArray:statusArr];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }else if (updateUp){
            NSMutableArray *tmp1 = [NSMutableArray arrayWithArray:statusArr];
            if (tmp1.count >= 50){
                [s_ori removeAllObjects];
                s_ori = [NSMutableArray arrayWithArray:statusArr];
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
            else{
                NSMutableArray *tmp2 = tmp1;
                [tmp2 addObjectsFromArray:s_ori];
                [s_ori removeAllObjects];
                s_ori = tmp2;
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
        }else {
            NSArray *tmp = [NSMutableArray arrayWithArray:statusArr];
            [s_ori addObjectsFromArray:tmp];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }
    } else if (type == Image){
        if (firstRefresh){
            [s_pic removeAllObjects];
            s_pic = [NSMutableArray arrayWithArray:statusArr];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }else if (updateUp){
            NSMutableArray *tmp1 = [NSMutableArray arrayWithArray:statusArr];
            if (tmp1.count >= 50){
                [s_pic removeAllObjects];
                s_pic = [NSMutableArray arrayWithArray:statusArr];
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
            else{
                NSMutableArray *tmp2 = tmp1;
                [tmp2 addObjectsFromArray:s_pic];
                [s_pic removeAllObjects];
                s_pic = tmp2;
                [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
            }
        }else {
            NSArray *tmp = [NSMutableArray arrayWithArray:statusArr];
            [s_pic addObjectsFromArray:tmp];
            [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
        }
    }
}

- (void)changeSetting
{
    int i = 0;
    if (type == All){
        [stsArr removeAllObjects];
        for (Status *sts in statuses){
            [stsArr addObject:[self CreateCell:i]];
            i++;
        }
    } else if (type == Original){
        [oriArr removeAllObjects];
        for (Status *sts in s_ori){
            [oriArr addObject:[self CreateCell:i]];
            i++;
        }
    } else if (type == Image){
        [picArr removeAllObjects];
        for (Status *sts in s_pic){
            [picArr addObject:[self CreateCell:i]];
            i++;
        }
    }
    [self performSelectorOnMainThread:@selector(FinishLoadCell) withObject:nil waitUntilDone:NO];
}

- (void)FinishLoadCell
{
    [mainTable reloadData];
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    [startView disappear];
    self.slidingViewController.noticeViewController = [NoticeViewController getInstance];
    [[NoticeViewController getInstance] startTimer];
}

- (void)refreshAllStatues
{
    firstRefresh = YES;
    [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
}

- (void)appendTableWith
{
    [mainTable reloadData];
    timeScroller.hidden = NO;
}

-(void)GetUserInfo:(User *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user.profileLargeImageUrl forKey:USER_AVAST];
    [[NSUserDefaults standardUserDefaults] setObject:user.screenName forKey:USER_STORE_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[MenuViewController getInstance] reSetUser];
}

-(void)NeedRelogin
{
    webV = [OAuthWebView new];
    webV.hidesBottomBarWhenPushed = YES;
    webV.delegate = self;
    self.slidingViewController.topCoverViewController = webV;
}

-(void)appWillClose
{
    [[CoreDataManager getInstance] cleanEntityRecords:@"StatusCDItem"];
    for (int i = 0; i < ((statuses.count > 50) ? 50:statuses.count); i++) {
        NSLog(@"i = %d",i);
        [[CoreDataManager getInstance] insertStatusesToCD:[statuses objectAtIndex:i] index:i isHomeLine:YES];
    }
}

- (UITableViewCell*)CreateCell:(int)i
{
    if (type == All){
        static NSString *cellIdentity = @"StatusCell";
        MessageCell *cell = [MessageCell new];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        Status *sts = [statuses objectAtIndex:i];
        [cell setStatus:sts];
        cell.delegate = self;
        cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
        return cell;
    } else if (type == Original){
        static NSString *cellIdentity = @"StatusCell";
        MessageCell *cell = [MessageCell new];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        Status *sts = [s_ori objectAtIndex:i];
        [cell setStatus:sts];
        cell.delegate = self;
        cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
        return cell;
    } else if (type == Image){
        static NSString *cellIdentity = @"StatusCell";
        MessageCell *cell = [MessageCell new];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        Status *sts = [s_pic objectAtIndex:i];
        [cell setStatus:sts];
        cell.delegate = self;
        cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
        return cell;
    }
    return nil;
}

- (void)stateChanged:(UIGestureRecognizer *)gesture {
    [timeScroller scrollViewDidEndDecelerating];
    [self.slidingViewController resetTopView];
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        firstRefresh = NO;
        updateUp = YES;
        if (type == All){
            if (statuses.count != 0){
                Status *sts = [statuses objectAtIndex:0];
                [manager getHomeLine:(sts.statusId + 1) maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
            } else {
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
            }
        } else if (type == Original){
            if (s_ori.count != 0){
                Status *sts = [s_ori objectAtIndex:0];
                [manager getHomeLine:(sts.statusId + 1) maxID:-1 count:50 page:-1 baseApp:-1 feature:1];
            } else {
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:1];
            }
        } else if (type == Image){
            if (s_pic.count != 0){
                Status *sts = [s_pic objectAtIndex:0];
                [manager getHomeLine:(sts.statusId + 1) maxID:-1 count:50 page:-1 baseApp:-1 feature:2];
            } else {
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:2];
            }
        }
        
        
    }
}

- (void)resetRecognizer {
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addMoreMessage
{
    if (type == All){
        if (statuses.count != 0){
            firstRefresh = NO;
            updateUp = NO;
            Status *sts = [statuses objectAtIndex:(statuses.count - 1)];
            [manager getHomeLine:-1 maxID:(sts.statusId-1) count:50 page:-1 baseApp:-1 feature:-1];
        } else {
            firstRefresh = YES;
            [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:-1];
        }
    } else if (type == Original){
        if (s_ori.count != 0){
            firstRefresh = NO;
            updateUp = NO;
            Status *sts = [s_ori objectAtIndex:(s_ori.count - 1)];
            [manager getHomeLine:-1 maxID:(sts.statusId-1) count:50 page:-1 baseApp:-1 feature:1];
        } else {
            firstRefresh = YES;
            [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:1];
        }
    } else if (type == Image){
        if (s_pic.count != 0){
            firstRefresh = NO;
            updateUp = NO;
            Status *sts = [s_pic objectAtIndex:(s_pic.count - 1)];
            [manager getHomeLine:-1 maxID:(sts.statusId-1) count:50 page:-1 baseApp:-1 feature:2];
        } else {
            firstRefresh = YES;
            [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:2];
        }
    }
    
    
}

#pragma mark -
#pragma mark uitalbleviewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (type == All){
        if (statuses.count == 0)
            return 0;
        else
            return statuses.count + 1;
    } else if (type == Original){
        if (s_ori.count == 0)
            return 0;
        else
            return s_ori.count + 1;
    } else if (type == Image){
        if (s_pic.count == 0)
            return 0;
        else
            return s_pic.count + 1;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type == All){
        if (indexPath.row == statuses.count){
            return 50;
        } else {
            MessageCell *cell = [stsArr objectAtIndex:indexPath.row];
            return [cell returnHeight];
        }
    } else if (type == Original){
        if (indexPath.row == s_ori.count){
            return 50;
        } else {
            MessageCell *cell = [oriArr objectAtIndex:indexPath.row];
            return [cell returnHeight];
        }
    } else if (type == Image){
        if (indexPath.row == s_pic.count){
            return 50;
        } else {
            MessageCell *cell = [picArr objectAtIndex:indexPath.row];
            return [cell returnHeight];
        }
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.slidingViewController resetTopView];
    if (type == All){
        if (indexPath.row == statuses.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil){
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            }
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        } else {
            static NSString *cellIdentity = @"StatusCell";
            MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            cell = [stsArr objectAtIndex:indexPath.row];
            return cell;
        }
    } else if (type == Original){
        if (indexPath.row == s_ori.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil){
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            }
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        } else {
            static NSString *cellIdentity = @"StatusCell";
            MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            cell = [oriArr objectAtIndex:indexPath.row];
            return cell;
        }
    } else if (type == Image){
        if (indexPath.row == s_pic.count){
            static NSString *cellIdentity;
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil){
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            }
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        } else {
            static NSString *cellIdentity = @"StatusCell";
            MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            cell = [picArr objectAtIndex:indexPath.row];
            return cell;
        }
    } else {
        static NSString *cellIdentity;
        LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil){
            cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        }
        cell.frame = CGRectMake(0, 0, 320, 50);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.slidingViewController resetTopView];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == statuses.count){
        [self addMoreMessage];
        return;
    }
    if(tapCount == 1 && tapTimer != nil && tappedRow == indexPath.row){
        //double tap - Put your double tap code here
        [tapTimer invalidate];
        tapCount = 0;
        tapTimer = nil;
        
    }
    else if(tapCount == 0){
        //This is the first tap. If there is no tap till tapTimer is fired, it is a single tap
        tapCount = tapCount + 1;
        tappedRow = indexPath.row;
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tapTimerFired:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:tapTimer forMode:NSRunLoopCommonModes];
    }
    else if(tappedRow != indexPath.row){
        //tap on new row
        tapCount = 0;
        if(tapTimer != nil){
            [tapTimer invalidate];
            tapTimer = nil;
        }
    }
}

- (void)tapTimerFired:(NSTimer *)aTimer{
    //timer fired, there was a single tap on indexPath.row = tappedRow
    if(tapTimer != nil){
        MessageDetail *detail = [MessageDetail new];
        self.slidingViewController.topCoverViewController = detail;
        if (type ==All){
            Status *sts = [statuses objectAtIndex:tappedRow];
            [detail setStatus:sts type:MessageFromTopView];
        } else if (type ==Original){
            Status *sts = [s_ori objectAtIndex:tappedRow];
            [detail setStatus:sts type:MessageFromTopView];
        } else if (type ==Image){
            Status *sts = [s_pic objectAtIndex:tappedRow];
            [detail setStatus:sts type:MessageFromTopView];
        }
        
        tapCount = 0;
        tappedRow = -1;
    }
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

#pragma mark TimeScrollerDelegate Methods

//You should return your UITableView here
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    
    return mainTable;
    
}

//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (NSDate *)dateForCell:(UITableViewCell *)cell 
{
    NSIndexPath *indexPath = [mainTable indexPathForCell:cell];
    if (indexPath.row == 0){
        return [NSDate date];
    }
    if (indexPath.row == statuses.count){
        Status *sts = [statuses objectAtIndex:indexPath.row-1];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sts.createdAt];
        return date;
    }
    Status *sts = [statuses objectAtIndex:indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sts.createdAt];
    return date;
}

#pragma mark UIScrollViewDelegateMethods


//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    [self.slidingViewController resetTopView];
    [timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    if (!decelerate) {
        [timeScroller scrollViewDidEndDecelerating];
    }
}

- (NSDate*)PHRefreshDataSourceLastUpdated:(PHRefreshGestureRecognizer*)object{
	return [NSDate date]; // should return date data source was last changed
}

- (void)changeTypeFromRight:(AddMessageType)t
{
    type = t;
    if (type == All){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (statuses.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
    if (type == Original){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (s_ori.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            else {
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:1];
                [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
                [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
            }
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
    if (type == Image){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (s_pic.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            else {
                [manager getHomeLine:-1 maxID:-1 count:50 page:-1 baseApp:-1 feature:2];
                [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
                [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
            }
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
}


@end
