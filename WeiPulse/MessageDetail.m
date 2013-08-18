//
//  MessageDetail.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-7.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageDetail.h"
#import "ASIHTTPRequest.h"
#import "ImageDetailViewController.h"
#import "BlockActionSheet.h"
#import "MTInfoPanel.h"
#import "LastCell.h"
#import "Comment.h"
#import "TableBackgView.h"
#import "HtmlString.h"
#import "RegexKitLite.h"
#import "WebViewController.h"
#import "UserDetailViewController.h"
#import "MapView.h"
#import "ReplyViewController.h"
#import "AtViewController.h"
#import "AddMessage.h"
#import "UserInfoViewController.h"

@interface MessageDetail ()

@end

@implementation MessageDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listener = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 320, 460);
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.0f;
    
    mainView = [UIView new];
    mainView.frame = CGRectMake(320, 0, 320, 460);
    mainView.layer.cornerRadius = 6;
    mainView.layer.masksToBounds = YES;
    mainView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
    [self.view addSubview:mainView];
    
    UIView *titleBackg = [UIView new];
    titleBackg.frame = CGRectMake(0, 0, 320, 105);
    titleBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"detail_title"]];
    [mainView addSubview:titleBackg];
    
    avastBackg = [UIView new];
    avastBackg.frame = CGRectMake(15, 4, 86, 86);
    avastBackg.backgroundColor = [UIColor blackColor];
    avastBackg.layer.cornerRadius = 3;
    avastBackg.layer.masksToBounds = YES;
    [mainView addSubview:avastBackg];
    
    avast = [UIImageView new];
    avast.frame = CGRectMake(3, 3, 80, 80);
    avast.backgroundColor = [UIColor blackColor];
    avast.alpha = 0.0f;
    UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowUser)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    avast.userInteractionEnabled = YES;
    [avast addGestureRecognizer:singleTapGestureRecognizer];
    [avastBackg addSubview:avast];
    
    v = [UIImageView new];
    v.frame = CGRectMake(84, 73, 17, 17);
    v.backgroundColor = [UIColor clearColor];
    v.image = [UIImage imageNamed:@"avatar_vip"];
    v.alpha = 0.0f;
    [mainView addSubview:v];
    
    ID = [UILabel new];
    ID.frame = CGRectMake(110, 10, 150, 40);
    ID.numberOfLines = 0;
    ID.lineBreakMode = UILineBreakModeWordWrap;
    ID.backgroundColor = [UIColor clearColor];
    [mainView addSubview:ID];
    
    date = [UILabel new];
    date.frame = CGRectMake(110, 50, 150, 20);
    date.backgroundColor = [UIColor clearColor];
    date.font = [UIFont systemFontOfSize:12.0f];
    [mainView addSubview:date];
    
    position = [UIButton new];
    position.frame = CGRectMake(163.5, 74.5, 14, 21);
    [position setBackgroundImage:[UIImage imageNamed:@"detail_location"] forState:UIControlStateNormal];
    [position addTarget:self action:@selector(Postion) forControlEvents:UIControlEventTouchUpInside];
    
    replyTweet = [UIButton new];
    replyTweet.frame = CGRectMake(198, 76, 19, 18);
    [replyTweet setBackgroundImage:[UIImage imageNamed:@"detail_replies"] forState:UIControlStateNormal];
    [replyTweet addTarget:self action:@selector(ReplyStatus) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:replyTweet];
    
    repostTweet = [UIButton new];
    repostTweet.frame = CGRectMake(235, 78, 24, 15);
    [repostTweet setBackgroundImage:[UIImage imageNamed:@"detail_retweets"] forState:UIControlStateNormal];
    [repostTweet addTarget:self action:@selector(RepostStatus) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:repostTweet];
    
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
    
    UIView *buttonBackg2 = [UIView new];
    buttonBackg2.frame = CGRectMake(270, 50, 44, 44);
    buttonBackg2.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
    [mainView addSubview:buttonBackg2];
    
    more = [UIButton new];
    more.frame = CGRectMake(275, 55, 35, 35);
    //more.frame = CGRectMake(110, 65, 150, 35);
    [more setImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"more_button_hl"] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:more];
    
    height = 0.0f;
    
    secondView = [UIScrollView new];
    secondView.frame = CGRectMake(0, 105, 320, 355);
    secondView.backgroundColor = [UIColor colorWithRed:0.949 green:0.957 blue:0.965 alpha:1.];
    secondView.scrollsToTop = YES;
    [mainView addSubview:secondView];
    
    text = [OHAttributedLabel new];
    text.delegate = self;
    text.userInteractionEnabled = YES;
    text.backgroundColor = [UIColor clearColor];
    text.automaticallyAddLinksForType = 0;
    text.underlineLinks = NO;
    [secondView addSubview:text];
    
    imageBackg = [UIView new];
    imageBackg.backgroundColor = [UIColor grayColor];
    [secondView addSubview:imageBackg];
    
    image = [UIImageView new];
    image.backgroundColor = [UIColor blackColor];
    image.frame = CGRectMake(2, 2, 55, 55);
    image.alpha = 0.0f;
    image.contentMode = UIViewContentModeScaleAspectFill;
    [image setClipsToBounds:YES];
    [imageBackg addSubview:image];
    
    oback = [UIView new];
    oback.backgroundColor = [UIColor clearColor];
    [[oback layer] setBorderWidth:2];
    [[oback layer] setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.7].CGColor];
    oback.layer.cornerRadius = 2.0f;
    oback.layer.masksToBounds = YES;
    [secondView addSubview:oback];
    
    otext = [OHAttributedLabel new];
    otext.backgroundColor = [UIColor clearColor];
    otext.userInteractionEnabled = YES;
    otext.delegate = self;
    otext.automaticallyAddLinksForType = 0;
    otext.underlineLinks = NO;
    [secondView addSubview:otext];
    
    oimageBackg = [UIView new];
    oimageBackg.backgroundColor = [UIColor grayColor];
    [secondView addSubview:oimageBackg];
    
    oimage = [UIImageView new];
    oimage.backgroundColor = [UIColor blackColor];
    oimage.frame = CGRectMake(2, 2, 55, 55);
    oimage.alpha = 0.0f;
    oimage.contentMode = UIViewContentModeScaleAspectFill;
    [oimage setClipsToBounds:YES];
    [oimageBackg addSubview:oimage];
    
    via = [UILabel new];
    via.backgroundColor = [UIColor clearColor];
    via.font = [UIFont systemFontOfSize:9.0f];
    via.textColor = [UIColor grayColor];
    [secondView addSubview:via];
    
    border = [UIView new];
    border.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    border.alpha = 0.8f;
    
    [secondView addSubview:border];
    
    repostButton = [UIButton new];
    [repostButton setTitle:@"转发" forState:UIControlStateNormal];
    [repostButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    repostButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    repostButton.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    [repostButton addTarget:self action:@selector(showRepost) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:repostButton];
    
    replyButton = [UIButton new];
    [replyButton setTitle:@"评论" forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    replyButton.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    [secondView addSubview:replyButton];
    
    mainTable = [UITableView new];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.scrollsToTop = NO;
    mainTable.separatorStyle = NO;
    mainTable.scrollEnabled = NO;
    [secondView addSubview:mainTable];
    
    comments = [NSMutableArray new];
    reposts = [NSMutableArray new];
    _add = NO;
    shouldReposts = 0;
    shouldComments = 0;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    
    manager = [WeiBoMessageManager getInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self makeListeners];
}

- (void)makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(mmGotFriendShips:)   name:MMSinaGotFriendShips        object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmDeleteMessage:)   name:MMSinaDeleteMessage         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmFollowUser:)   name:MMSinaFollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmUnfollowUser:)   name:MMSinaUnfollowedByUserIDWithResult         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmGetComments:)   name:MMSinaGotCommentList         object:nil];
        [defaultNotifCenter addObserver:self selector:@selector(mmGetReposts:)   name:MMSinaGotRepostList         object:nil];
    }
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
        [defaultNotifCenter removeObserver:self name:MMSinaGotFriendShips            object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaDeleteMessage             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaUnfollowedByUserIDWithResult             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotCommentList             object:nil];
        [defaultNotifCenter removeObserver:self name:MMSinaGotRepostList             object:nil];
    }
}

- (void)mmFollowUser: (NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (sts.user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"关注%@成功", sts.user.screenName];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"关注" 
                            subtitle:title 
                           hideAfter:3.0];
    }
    _followed = YES;
}

- (void)mmUnfollowUser:(NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (sts.user.userId == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"已取消关注%@", sts.user.screenName];
        [UIView animateWithDuration:0.5 
                         animations:^{
                             if (type == MessageFromTopView){
                                 self.view.frame = CGRectMake(320, 0, 320, 460);
                                 self.view.alpha = 0.0f;
                             } else {
                                 [self dismissModalViewControllerAnimated:YES];
                             }
                         }completion:^(BOOL complete){
                             if (type == MessageFromTopView){
                                 if ([self.slidingViewController.topViewController respondsToSelector:@selector(refreshAllStatues)]) {
                                     [self.slidingViewController.topViewController performSelector:@selector(refreshAllStatues)];
                                 }
                                 if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                     [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                                 }
                                 UIViewController *tmp = [UIViewController new];
                                 tmp.view.userInteractionEnabled = NO;
                                 self.slidingViewController.topCoverViewController=tmp;
                             } else if (type == MessageFromTopCoverView){
                                 if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
                                     [self.parentViewController performSelector:@selector(makeListeners)];
                                 }
                                 
                             }
                             [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                                                    title:@"取消关注" 
                                                 subtitle:title 
                                                hideAfter:3.0];
                         }];
        _followed = NO;
    }
}

- (void)mmGotFriendShips :(NSNotification *)sender
{
    NSDictionary *result = sender.object;
    NSString *followed = [result objectForKey:@"followed_by"];
    if ([followed intValue] == 1)
        _followed = YES;
    else
        _followed = NO;
    NSString *following = [result objectForKey:@"following"];
    if ([following intValue] == 1)
        _following = YES;
    else
        _following = NO;
}

- (void)mmDeleteMessage:(NSNotification *)sender
{
    Status *s = sender.object;
    if (s.statusId == sts.statusId){
        [UIView animateWithDuration:0.5 
                         animations:^{
                             if (type == MessageFromTopView){
                                 self.view.frame = CGRectMake(320, 0, 320, 460);
                                 self.view.alpha = 0.0f;
                             } else {
                                 [self dismissModalViewControllerAnimated:YES];
                             }
                         }completion:^(BOOL complete){
                             if (type == MessageFromTopView){
                                 if ([self.slidingViewController.topViewController respondsToSelector:@selector(refreshAllStatues)]) {
                                     [self.slidingViewController.topViewController performSelector:@selector(refreshAllStatues)];
                                 }
                                 if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                     [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                                 }
                                 UIViewController *tmp = [UIViewController new];
                                 tmp.view.userInteractionEnabled = NO;
                                 self.slidingViewController.topCoverViewController=tmp;
                             } else if (type == MessageFromTopCoverView){
                                 if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
                                     [self.parentViewController performSelector:@selector(makeListeners)];
                                 }
                                 
                             }
                             [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                                                    title:@"删除微博" 
                                                 subtitle:@"微博已成功删除" 
                                                hideAfter:3.0];
                         }];
    }
}

- (void)mmGetComments:(NSNotification *)sender
{
    shouldComments ++;
    NSDictionary *dic = sender.object;
    if (_add){
        NSMutableArray *tmp = [dic objectForKey:@"repostArrary"];
        [comments addObjectsFromArray:tmp];
        [mainTable reloadData];
        mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
        [backgView removeFromSuperview];
        [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
    }else {
        comments = [dic objectForKey:@"commentArrary"];
        if (_comment){
            [mainTable reloadData];
            mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
            [backgView removeFromSuperview];
            [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
        }
    }
    if ([[dic objectForKey:@"count"] intValue] > 99){
        NSString *title = [[NSString alloc] initWithFormat:@"评论(99+)"];
        [replyButton setTitle:title forState:UIControlStateNormal];
    } else {
        NSString *title = [[NSString alloc] initWithFormat:@"评论(%@)", [dic objectForKey:@"count"]];
        [replyButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)mmGetReposts:(NSNotification *)sender
{
    shouldReposts ++;
    NSDictionary *dic = sender.object;
    if (_add){
        NSMutableArray *tmp = [dic objectForKey:@"repostArrary"];
        [reposts addObjectsFromArray:tmp];
        [mainTable reloadData];
        mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
        [backgView removeFromSuperview];
        [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
    }else {
        reposts = [dic objectForKey:@"repostArrary"];
        if (!_comment){
            [mainTable reloadData];
            mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
            [backgView removeFromSuperview];
            [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
        }
    }
    if ([[dic objectForKey:@"count"] intValue] > 99){
        NSString *title = [[NSString alloc] initWithFormat:@"转发(99+)"];
        [repostButton setTitle:title forState:UIControlStateNormal];
    } else {
        NSString *title = [[NSString alloc] initWithFormat:@"转发(%@)", [dic objectForKey:@"count"]];
        [repostButton setTitle:title forState:UIControlStateNormal];
    }
    
}

- (void) Exit
{
    [UIView animateWithDuration:0.5 
                     animations:^{
                         if (type == MessageFromTopView){
                             self.view.frame = CGRectMake(320, 0, 320, 460);
                             self.view.alpha = 0.0f;
                         } else {
                             [self dismissModalViewControllerAnimated:YES];
                         }
                     }completion:^(BOOL complete){
                         if (type == MessageFromTopView){
                             if ([self.slidingViewController.topViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.slidingViewController.topViewController performSelector:@selector(makeListeners)];
                             }
                             UIViewController *tmp = [UIViewController new];
                             tmp.view.userInteractionEnabled = NO;
                             self.slidingViewController.topCoverViewController=tmp;
                         } else if (type == MessageFromTopCoverView){
                             if ([self.parentViewController respondsToSelector:@selector(makeListeners)]) {
                                 [self.parentViewController performSelector:@selector(makeListeners)];
                             }
                             
                         }
                     }];
    
}

- (void)More
{
    if (!_showManu){
        NSString *showString = nil;
        if (!_self){
            if (_following)
                showString = [[NSString alloc]initWithFormat:@"%@\n关注了你", sts.user.screenName];
            else
                showString = [[NSString alloc]initWithFormat:@"%@\n没有关注你", sts.user.screenName];
        } else
            showString = nil;
        BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:showString];
        if (_self){
            [sheet setDestructiveButtonWithTitle:@"删除微博" block:^{
                [self deleteMessage];
                _showManu = NO;
            }];
        }
        else {
            if (_followed){
                [sheet setDestructiveButtonWithTitle:@"取消关注用户" block:^{
                    [manager unfollowByUserID:sts.user.userId];
                    _showManu = NO;
                }];
            } else {
                [sheet addButtonWithTitle:@"关注用户" block:^{
                    [manager followByUserID:sts.user.userId];
                    _showManu = NO;
                }];
            }
            if (sts.user.gender == GenderMale){
                [sheet addButtonWithTitle:@"@他" block:^{
                    [self AtSomeone];
                    _showManu = NO;
                }];
                [sheet addButtonWithTitle:@"他的资料" block:^{
                    [self showUserInfo];
                    _showManu = NO;
                }];
                
            } else if (sts.user.gender == GenderFemale) {
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
            
            /*[sheet addButtonWithTitle:@"私信他" block:^{
                //[self addPicFromCamare];
                _showManu = NO;
            }];*/
        }
        
        if ([MFMessageComposeViewController canSendText]){
            [sheet addButtonWithTitle:@"短信转发" block:^{
                [self postStatusToSMS];
                _showManu = NO;
            }];
        }
        
        if ([MFMailComposeViewController canSendMail]){
            [sheet addButtonWithTitle:@"邮件转发" block:^{
                [self postStatusToMail];
                _showManu = NO;
            }];
        }
        
        [sheet setCancelButtonWithTitle:@"取消" block:^{
            _showManu = NO;
        }];
        [sheet showInView:self.view];
        _showManu = YES;
    }
}

- (void) AtSomeone
{
    AddMessage *a = [AddMessage new];
    [a setUser:sts.user.screenName type:AddMessageFromTopCoverView];
    [self presentModalViewController:a animated:YES];
}

- (void)ReplyStatus
{
    ReplyViewController *r = [ReplyViewController new];
    [r setStatus:sts type:ReplyViewFromTopCoverView];
    [self presentModalViewController:r animated:NO];
}

- (void)RepostStatus
{
    AtViewController *a = [AtViewController new];
    [a setStatus:sts type:AtViewFromTopCoverView];
    [self presentModalViewController:a animated:NO];
}

- (void)deleteMessage
{
    [manager deleteMessage:sts.statusId];
}

- (void)showUserInfo
{
    [self deleteListeners];
    UserInfoViewController *userInfo = [UserInfoViewController new];
    [userInfo setUser:sts.user type:UserInfoFromTopCoverView];
    [self presentModalViewController:userInfo animated:YES];
}

- (void)postStatusToSMS
{
    MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
    if ([MFMessageComposeViewController canSendText]){
        controller.body = sts.text;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)postStatusToMail
{
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    if ([MFMailComposeViewController canSendMail]){
        [controller setMessageBody:sts.text isHTML:NO];
        NSString *title = [[NSString alloc] initWithFormat:@"%@的微博", sts.user.screenName];
        [controller setSubject:title];
        controller.mailComposeDelegate = (id)self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)showRepost
{
    [repostButton removeTarget:self action:@selector(showRepost) forControlEvents:UIControlEventTouchUpInside];
    [replyButton addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.2 animations:^{
        repostButton.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        replyButton.backgroundColor = [UIColor clearColor];
        mainTable.alpha = 0.0f;
    } completion:^(BOOL complete){
        _comment = NO;
        [mainTable reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            mainTable.alpha =1.0f;
            mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
            //[backgView removeFromSuperview];
            [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
        }];
    }];
}

- (void)showComment
{
    [replyButton removeTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    [repostButton addTarget:self action:@selector(showRepost) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.2 animations:^{
        replyButton.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        repostButton.backgroundColor = [UIColor clearColor];
        mainTable.alpha = 0.0f;
    } completion:^(BOOL complete){
        _comment = YES;
        [mainTable reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            mainTable.alpha =1.0f;
            mainTable.frame = CGRectMake(0, height, 320, mainTable.contentSize.height);
            //[backgView removeFromSuperview];
            [secondView setContentSize:CGSizeMake(320, height + mainTable.contentSize.height)];
        }];
    }];
}

- (void)addMoreMessage
{
    _add = YES;
    if (_comment){
        Comment *c = [comments objectAtIndex:(comments.count-1)]; 
        [manager getCommentListWithID:sts.statusId since:(c.commentId-1)];
    }else {
        Status *s = [reposts objectAtIndex:(reposts.count - 1)];
        [manager getRepostListWithID:sts.statusId since:(s.statusId-1)];
    }
}

- (void)Postion
{
    MapView *m = [MapView new];
    [m setMap:sts.longitude latitude:sts.latitude];
    [self.view addSubview:m];
}

- (void)setStatus:(Status *)status type:(MessageDetailViewType)t
{
    type = t;
    _showManu = NO;
    sts = status;
    ID.text = sts.user.screenName;
    if (status.user.verified){
        if (status.user.verifiedType == 0)
            v.alpha = 1;
        else {
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            v.alpha = 1;
        }
    } else if (status.user.verifiedType == 220){
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
        v.alpha = 1;
    }
    [self setAvast];
    [self setTime];
    if (sts.retweetedStatus){
        [self setText:NO];
        BOOL pic = [self setOriginPic];
        [self setOriginPost:pic];
    }else{
        BOOL pic = [self setImage];
        [self setText:pic];
    }
    if (sts.latitude != 0 && sts.longitude != 0){
        [mainView addSubview:position];
    }
    [self setVia];
    border.frame = CGRectMake(0, height - 2, 320, 2);
    [self setButton];
    [self setTableView];
    //long long [[NSUserDefaults standardUserDefaults] getKey:USER_STORE_USER_ID];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    [manager getFriendShips:[userId longLongValue] sourceName:nil targetId:sts.user.userId targetName:nil];
    [manager getCommentListWithID:sts.statusId since:-1];
    [manager getRepostListWithID:sts.statusId since:-1];
    if ([userId longLongValue] == sts.user.userId)
        _self = YES;
    else
        _self = NO;
    if (type == MessageFromTopView){
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 1.0f;
            mainView.frame = CGRectMake(0, 0, 320, 460);
        }];
    } else if (type == MessageFromTopCoverView){
        self.view.alpha = 1.0f;
        mainView.frame = CGRectMake(0, 0, 320, 460);
        avastBackg.frame = CGRectMake(05, 4, 86, 86);
        v.frame = CGRectMake(74, 73, 17, 17);
    }
    
    
    [secondView setContentSize:CGSizeMake(320, height)];
}

- (void)setAvast
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [sts.user.profileLargeImageUrl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", sts.user.screenName, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast.image = [[UIImage alloc] initWithContentsOfFile: path];
        [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
    }
    else {
        NSURL *url = [NSURL URLWithString:sts.user.profileLargeImageUrl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast.image = [[UIImage alloc] initWithContentsOfFile: path];
            [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}

- (void)setTime
{
    NSString *str = @"%Y年%m月%d日 %H:%M:%S";
    NSString *stime = [self dateInFormat:sts.createdAt format:str];
    [date setText:stime];
}

- (BOOL)setImage
{
    if (sts.thumbnailPic.length == 0)
        return NO;
    else {
        imageBackg.frame = CGRectMake(246, 20, 59, 59);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [sts.thumbnailPic componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            image.image = [[UIImage alloc] initWithContentsOfFile: path];
            [UIView animateWithDuration:0.3 animations:^{image.alpha = 1.0f;}];
        }
        else {
            NSURL *url = [NSURL URLWithString:sts.thumbnailPic];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                image.image = [[UIImage alloc] initWithContentsOfFile: path];
                [UIView animateWithDuration:0.3 animations:^{image.alpha = 1.0f;}];
            }];
            [request startAsynchronous];
        }
        UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowImage)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:singleTapGestureRecognizer];
        return YES;
    }
}

- (void)ShowImage
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [self presentModalViewController:imageDetail animated:YES];
    [imageDetail setImageUrl:sts.originalPic type:ImageFromTopCoverView];
}

- (void)ShowUser
{
    UserDetailViewController *userDetail = [UserDetailViewController new];
    [userDetail setUser:sts.user type:UserFromTopCoverView];
    [self presentModalViewController:userDetail animated:YES];
}

- (int)getFontSize
{
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Font"] intValue]) {
        case 0:
            return 12;
            break;
        case 1:
            return 14;
            break;
        case 2:
            return 16;
            break;
        case 3:
            return 18;
            break;
        default:
            break;
    }
    return 15;
}

- (void)setText: (BOOL)pic
{
    NSString *transformStr = [HtmlString transformString:sts.text];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [text setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:text];
    if (pic){
        text.frame = CGRectMake(15, 10, 225, 60);
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(225, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(225, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        if (text.frame.size.height >80){
            height = 15 + text.frame.size.height;
        } else {
            height += 95;
        }
    }
    else {
        text.frame = CGRectMake(15, 10, 290, 65);
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(290, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(290, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        height += text.frame.size.height + 5;
    }
}

- (BOOL)setOriginPic
{
    if (sts.retweetedStatus.thumbnailPic.length == 0)
        return NO;
    else {
        oimageBackg.frame = CGRectMake(236, height + 20 , 59, 59);
        //height = height + 60;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [sts.retweetedStatus.thumbnailPic componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            oimage.image = [[UIImage alloc] initWithContentsOfFile: path];
            [UIView animateWithDuration:0.3 animations:^{oimage.alpha = 1.0f;}];
        }
        else {
            NSURL *url = [NSURL URLWithString:sts.retweetedStatus.thumbnailPic];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                oimage.image = [[UIImage alloc] initWithContentsOfFile: path];
                [UIView animateWithDuration:0.3 animations:^{oimage.alpha = 1.0f;}];
            }];
            [request startAsynchronous];
        }
        UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowOriginImage)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        oimage.userInteractionEnabled = YES;
        [oimage addGestureRecognizer:singleTapGestureRecognizer];
        return YES;
    }
}

- (void)ShowOriginImage
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [self presentModalViewController:imageDetail animated:YES];
    [imageDetail setImageUrl:sts.retweetedStatus.originalPic type:ImageFromTopCoverView];
}

- (void) setOriginPost:(BOOL)pic
{
    NSString *rtext = [[NSString alloc] initWithFormat:@"@%@:%@",sts.retweetedStatus.user.screenName,sts.retweetedStatus.text];
    NSString *transformStr = [HtmlString transformString:rtext];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [otext setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:otext];
    if (pic){
        otext.frame = CGRectMake(18, height + 18, 215, 80);
        oback.frame = CGRectMake(15, height + 15, 290, 80);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(215, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(215, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        if (otext.bounds.size.height >80){
            oback.frame = CGRectMake(15, height + 15, 290, otext.frame.size.height + 6);
            height = height + otext.frame.size.height + 26 + 5;
        }else {
            height = height + 88 + 5;
        }
    }
    else {
        otext.frame = CGRectMake(18, height + 18, 284, 60);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(284, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(284, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        oback.frame = CGRectMake(15, height + 15, 290, otext.frame.size.height + 6);
        height = height + otext.frame.size.height + 26 + 5;
    }
}

- (void)setVia
{
    height += 2;
    via.frame = CGRectMake(15, height + 5, 140, 20);
    NSString *viaSource = [[NSString alloc] initWithFormat:@"来自%@",sts.source];
    [via setText:viaSource];
    height += 30;
}

- (void)setButton
{
    repostButton.frame = CGRectMake(180, height - 25, 60, 25);
    repostButton.backgroundColor = [UIColor clearColor];
    replyButton.frame = CGRectMake(240, height - 25, 60, 25);
    _comment = YES;
}

- (void)setTableView
{
    mainTable.frame = CGRectMake(0, height, 320, 460);
}

- (NSString *)dateInFormat:(time_t)dateTime format:(NSString*) stringFormat
{
    char buffer[80];
    const char *format = [stringFormat UTF8String];
    struct tm *timeinfo;
    timeinfo = localtime(&dateTime);
    strftime(buffer, 80, format, timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_comment){
        if (comments.count == 50 * shouldComments)
            return comments.count + 1;
        else
            return comments.count;
    } else {
        if (reposts.count == 50 * shouldReposts)
            return reposts.count + 1;
        else
            return reposts.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell = (UITableView *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity;
    if (_comment){
        if (indexPath.row == comments.count){
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
    } else {
        if (indexPath.row == reposts.count){
            LastCell *cell = (LastCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell == nil)
                cell = [[LastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            cell.frame = CGRectMake(0, 0, 320, 50);
            return cell;
        }
    }
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    if (_comment){
        Comment *com = [comments objectAtIndex:indexPath.row];
        [cell setComment:com];
        [cell setName:com.user.screenName];
        [cell setPost:com.text];
        [cell setVia:com.source];
        [cell setTime:com.createdAt];
        [cell setType:1];
        cell.delegate = self;
    } else {
        Status *status = [reposts objectAtIndex:indexPath.row];
        [cell setStatus:status];
        [cell setName:status.user.screenName];
        [cell setPost:status.text];
        [cell setVia:status.source];
        [cell setTime:status.createdAt];
        [cell setType:2];
        cell.delegate = self;
    }
    cell.frame = CGRectMake(0, 0, 320, [cell returnHeight]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == reposts.count && !_comment){
        [self addMoreMessage];
    }
    if (indexPath.row == comments.count && _comment){
        [self addMoreMessage];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess 
                                   title:@"短信" 
                                subtitle:@"短信发送成功" 
                               hideAfter:3.0];
            break;
        case MessageComposeResultFailed:
            [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeError
                                   title:@"短信" 
                                subtitle:@"短信发送失败" 
                               hideAfter:3.0];
            break;
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess 
                                   title:@"邮件" 
                                subtitle:@"邮件发送成功" 
                               hideAfter:3.0];
            break;
        case MFMailComposeResultFailed:
            [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeError 
                                   title:@"邮件" 
                                subtitle:@"邮件发送失败" 
                               hideAfter:3.0];
            break;
        case MFMailComposeResultSaved:
            [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess 
                                   title:@"邮件" 
                                subtitle:@"邮件已保存" 
                               hideAfter:3.0];
            break;
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)openUrlLink:(NSURL*)linkUrl
{
    NSString *requestString = [linkUrl  absoluteString];
    NSLog(@"%@",requestString);
    NSArray *urlComps = [requestString componentsSeparatedByString:@"&"];
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd1"])//@方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *tmp_array = [str componentsSeparatedByString:@"@"];
        [self openUserDetail:[[NSString alloc] initWithFormat:@"%@", [tmp_array objectAtIndex:1]]];
        return ;
    }
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd2"])//话题方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return ;
    }
    
    //以下是使用safri打开链接
    if ( ( [ [ linkUrl scheme ] isEqualToString: @"http" ] || [ [ linkUrl scheme ] isEqualToString: @"https" ] || [ [ linkUrl scheme ] isEqualToString: @"mailto" ])) {
        [self openTheURL:[[NSString alloc] initWithFormat:@"%@", linkUrl]];
        return;
    }
    return;
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

- (void) openStatus:(Status *)s
{
    AtViewController *a = [AtViewController new];
    [a setStatus:s type:AtViewFromTopCoverView];
    [self presentModalViewController:a animated:NO];
}

- (void) openComment:(Comment *)c
{
    ReplyViewController *r = [ReplyViewController new];
    [r setComment:c type:ReplyViewFromTopCoverView];
    [self presentModalViewController:r animated:NO];
}

@end
