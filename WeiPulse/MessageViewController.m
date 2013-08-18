//
//  MessageViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageViewController.h"
#import "MenuViewController.h"
#import "LastCell.h"
#import "Status.h"
#import "Comment.h"
#import "MessageDetail.h"
#import "ImageDetailViewController.h"
#import "UserDetailViewController.h"
#import "WebViewController.h"
#import "AtViewController.h"
#import "ReplyViewController.h"

static MessageViewController * instance=nil;

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, 320, 460);
        
        listener = NO;
        mainView = [UIView new];
        mainView.frame = CGRectMake(10, 0, 310, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
        [self.view addSubview:mainView];
        
        notice = [UILabel new];
        notice.text = @"载入中...";
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
        [mainView addSubview:mainTable];
        
        PHRefreshGestureRecognizer *PHR = [[PHRefreshGestureRecognizer alloc] initWithTarget:self action:@selector(stateChanged:)];
        [mainTable addGestureRecognizer:PHR];
    }
    return self;
}

+(MessageViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[MessageViewController new];
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
    
    MessageRightViewController *rightView = [MessageRightViewController new];
    if (![self.slidingViewController.underRightViewController isKindOfClass:[MessageRightViewController class]]) {
        self.slidingViewController.underRightViewController  = rightView;
    }
    rightView.delegate = self;
    [rightView setType:type];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (type == AtMessage && rePost.count == 0){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        if (shouldRePost)
            [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    } else if (type == CommentMessage && comment.count == 0){
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshTriggered];
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshLoading];
        if (shouldComment)
            [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    }
}

- (void)stateChanged :(UIGestureRecognizer *)gesture
{
    [self.slidingViewController resetTopView];
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (type == AtMessage){
            shouldRePost = NO;
            [manager getMetionsStatuses:-1 maxID:-1 count:50];
        } else if (type == CommentMessage){
            shouldComment = NO;
            [manager getCommentsStatuses:-1 maxID:-1 count:50];
        } else if (type == MailMessage){
            //[manager getBilateralUserListAll:user.userId sort:0];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 320, 460);
    self.view.backgroundColor = [UIColor clearColor];
    
    rePost = [NSMutableArray new];
    comment = [NSMutableArray new];
    repostArr = [NSMutableArray new];
    comArr = [NSMutableArray new];
    type = AtMessage;
    reCountRePost = 50;
    reCountComment = 50;
    shouldRePost = NO;
    shouldComment = NO;
    
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    
    manager = [WeiBoMessageManager getInstance];
    manager.delegate = self;
    
    [manager getMetionsStatuses:-1 maxID:-1 count:50];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (void)GetMetionsStatused:(NSArray *)statusArr
{
    if (!shouldRePost){
        [rePost removeAllObjects];
        rePost = [NSMutableArray arrayWithArray:statusArr];
        reCountRePost = rePost.count;
        shouldRePost = YES;
        [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:statusArr];
        reCountRePost = tmp.count;
        [rePost addObjectsFromArray:tmp];
        [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
    }
    
}

- (void)GetCommentsStatused:(NSArray *)commentArray
{
    if (!shouldComment){
        [comment removeAllObjects];
        comment = [NSMutableArray arrayWithArray:commentArray];
        reCountComment = comment.count;
        shouldComment = YES;
        [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:commentArray];
        reCountComment = tmp.count;
        [comment addObjectsFromArray:tmp];
        [self performSelectorInBackground:@selector(changeSetting) withObject:nil];
    }
    
}

- (void)changeSetting
{
    int i = 0;
    if (type == AtMessage){
        [repostArr removeAllObjects];
        for (Status *sts in rePost){
            MessageViewCell *cell = [MessageViewCell new];
            cell.delegate = self;
            [cell setStatus:sts];
            cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
            [repostArr addObject:cell];
            i++;
        }
    } else if (type == CommentMessage){
        [comArr removeAllObjects];
        for (Comment *sts in comment){
            MessageViewCell *cell = [MessageViewCell new];
            cell.delegate = self;
            [cell setComment:sts];
            cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
            [comArr addObject:cell];
            i++;
        }
    }
    [self performSelectorOnMainThread:@selector(FinishLoadCell) withObject:nil waitUntilDone:NO];
}

- (void)FinishLoadCell
{
    [mainTable reloadData];
    if (type == AtMessage){
        if (rePost.count == 0){
            notice.alpha = 1;
            notice.text = @"您的此列表为空";
        }
        else
            notice.alpha = 0;
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    }
    if (type == CommentMessage){
        if (comment.count == 0){
            notice.alpha = 1;
            notice.text = @"您的此列表为空";
        }
        else
            notice.alpha = 0;
        [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    }
    
    [[mainTable refreshGestureRecognizer] setRefreshState:PHRefreshIdle];
    [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
}

- (void)addMoreMessage
{
    if (type == AtMessage){
        Status *status = [rePost objectAtIndex:(rePost.count - 1)];
        [manager getMetionsStatuses:-1 maxID:(status.statusId - 1) count:50];
    } else if (type == CommentMessage){
        Comment *com = [comment objectAtIndex:(comment.count - 1)];
        [manager getCommentsStatuses:-1 maxID:(com.commentId - 1) count:50];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (type == AtMessage){
        if (reCountRePost != 0 && rePost.count != 0)
            return rePost.count + 1;
        else
            return rePost.count;
    } else if (type == CommentMessage){
        if (reCountComment != 0 && comment.count != 0)
            return comment.count + 1;
        else
            return comment.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type == AtMessage){
        if (indexPath.row == rePost.count)
            return 50;
        return [[repostArr objectAtIndex:indexPath.row] returnHeight];
    } else if (type == CommentMessage){
        if (indexPath.row == comment.count)
            return 50;
        return [[comArr objectAtIndex:indexPath.row] returnHeight];
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity;
    if (type == AtMessage){
        if (indexPath.row == rePost.count){
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
        static NSString *cellIdentity = @"StatusCell";
        MessageViewCell *cell = (MessageViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        cell = [repostArr objectAtIndex:indexPath.row];
        return cell;
    } else if (type == CommentMessage){
        if (indexPath.row == comment.count){
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
        static NSString *cellIdentity = @"CommentCell";
        MessageViewCell *cell = (MessageViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        cell = [comArr objectAtIndex:indexPath.row];
        return cell;
    } else {
        LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (cell == nil)
            cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.frame = CGRectMake(0, 0, 320, 50);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (type == AtMessage){
        if (indexPath.row == rePost.count){
            [self addMoreMessage];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        MessageDetail *detail = [MessageDetail new];
        self.slidingViewController.topCoverViewController = detail;
        Status *sts = [rePost objectAtIndex:indexPath.row];
        [detail setStatus:sts type:MessageFromTopView];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (type == CommentMessage){
        if (indexPath.row == comment.count){
            [self addMoreMessage];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        MessageDetail *detail = [MessageDetail new];
        self.slidingViewController.topCoverViewController = detail;
        Comment *com = [comment objectAtIndex:indexPath.row];
        [detail setStatus:com.status type:MessageFromTopView];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void) repostStatus:(Status *)s
{
    AtViewController *a = [AtViewController new];
    [a setStatus:s type:AtViewFromTopView];
    self.slidingViewController.topCoverViewController = a;
}

- (void) replyComment:(Comment *)c
{
    ReplyViewController *r = [ReplyViewController new];
    [r setComment:c type:ReplyViewFromTopView];
    self.slidingViewController.topCoverViewController = r;
}

- (void)changeTypeFromRight:(MessageViewType)t
{
    type = t;
    if (type == AtMessage){
        if (rePost.count == 0){
            notice.alpha = 1;
            notice.text = @"您的此列表为空";
        }
        else
            notice.alpha = 0;
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (rePost.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
    }
    if (type == CommentMessage){
        if (!shouldComment){
            [manager getCommentsStatuses:-1 maxID:-1 count:50];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;}];
        } else {
            if (comment.count == 0){
                notice.alpha = 1;
                notice.text = @"您的此列表为空";
            }
            else
                notice.alpha = 0;
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
                [mainTable reloadData];
                if (comment.count != 0)
                    [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
            }];
        }
    }
    if (type == MailMessage){
        [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 0;} completion:^(BOOL complete){
            [mainTable reloadData];
            if (mail.count != 0)
                [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView animateWithDuration:0.2f animations:^{mainTable.alpha = 1;}];
        }];
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
