//
//  SettingViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "TableBackgView.h"
#import "StatusViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "HotViewController.h"
#import "PersonViewController.h"
#import "MBProgressHUD.h"
#import "MTInfoPanel.h"
#import "DocumentViewController.h"
#import "BlockAlertView.h"

static SettingViewController * instance=nil;

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.layer.shadowOpacity = 0.75f;
        self.view.layer.shadowRadius = 3.0f;
        
        mainPart = [UIScrollView new];
        mainPart.frame = CGRectMake(10, 0, 310, 460);
        mainPart.alwaysBounceVertical = YES;
        mainPart.scrollsToTop = YES;
        mainPart.backgroundColor = [UIColor colorWithRed:0.0862 green:0.0862 blue:0.0862 alpha:1.0];
        [self.view addSubview:mainPart];
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(0, 0, 310, 1050);
        UIImage * backImage = [[UIImage imageNamed:@"setting_backg"] stretchableImageWithLeftCapWidth:0 topCapHeight:50];
        UIImageView *image = [UIImageView new];
        image.image = backImage;
        image.frame = CGRectMake(0, -15, 310, 1010);
        mainView.backgroundColor = [UIColor clearColor];
        [mainView addSubview:image];
        [mainPart addSubview:mainView];
        
        mainPart.contentSize = mainView.bounds.size;
        
        UILabel *one = [UILabel new];
        [one setText:@"显示"];
        one.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        one.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        one.backgroundColor = [UIColor clearColor];
        one.frame = CGRectMake(35, 20, 40, 20);
        one.shadowColor = [UIColor blackColor];
        one.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:one];
        
        font = [UIButton new];
        font.frame = CGRectMake(25, 50, 260, 50);
        [font.layer setBorderWidth:1.25];
        [font.layer setBorderColor:[UIColor blackColor].CGColor];
        font.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        font.layer.cornerRadius = 4;
        font.layer.masksToBounds = YES;
        [font addTarget:self action:@selector(changeFont) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:font];
        
        UILabel *fontLabel = [UILabel new];
        [fontLabel setText:@"微博显示字体"];
        fontLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        fontLabel.textColor = [UIColor whiteColor];
        fontLabel.backgroundColor = [UIColor clearColor];
        fontLabel.frame = CGRectMake(15, 15, 200, 20);
        fontLabel.shadowColor = [UIColor blackColor];
        fontLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [font addSubview:fontLabel];
        
        UIImageView *fontImage= [UIImageView new];
        fontImage.image = [UIImage imageNamed:@"setting_list"];
        fontImage.frame = CGRectMake(229, 18, 16, 14);
        [font addSubview:fontImage];
        
        timeStamp = [UIButton new];
        timeStamp.frame = CGRectMake(25, 105, 260, 50);
        [timeStamp.layer setBorderWidth:1.25];
        [timeStamp.layer setBorderColor:[UIColor blackColor].CGColor];
        timeStamp.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        timeStamp.layer.cornerRadius = 4;
        timeStamp.layer.masksToBounds = YES;
        [mainView addSubview:timeStamp];
        
        UILabel *timeStampLabel = [UILabel new];
        [timeStampLabel setText:@"显示时间标"];
        timeStampLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        timeStampLabel.textColor = [UIColor whiteColor];
        timeStampLabel.backgroundColor = [UIColor clearColor];
        timeStampLabel.frame = CGRectMake(15, 15, 100, 20);
        timeStampLabel.shadowColor = [UIColor blackColor];
        timeStampLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [timeStamp addSubview:timeStampLabel];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(175, 12, 0, 0)];
        [switchView addTarget:self action:@selector(checkTimeStamp:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeStamp"] intValue] == 0){
            switchView.on = NO;
        }else {
            switchView.on = YES;
        }
        [timeStamp addSubview:switchView];
        
        userShow = [UIButton new];
        userShow.frame = CGRectMake(25, 160, 260, 50);
        [userShow.layer setBorderWidth:1.25];
        [userShow.layer setBorderColor:[UIColor blackColor].CGColor];
        userShow.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        userShow.layer.cornerRadius = 4;
        userShow.layer.masksToBounds = YES;
        [userShow addTarget:self action:@selector(changeFontUserShow) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:userShow];
        
        UILabel *userShowLabel = [UILabel new];
        [userShowLabel setText:@"用户名显示"];
        userShowLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        userShowLabel.textColor = [UIColor whiteColor];
        userShowLabel.backgroundColor = [UIColor clearColor];
        userShowLabel.frame = CGRectMake(15, 15, 100, 20);
        userShowLabel.shadowColor = [UIColor blackColor];
        userShowLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [userShow addSubview:userShowLabel];
        
        UIImageView *userShowImage= [UIImageView new];
        userShowImage.image = [UIImage imageNamed:@"setting_list"];
        userShowImage.frame = CGRectMake(229, 18, 16, 14);
        [userShow addSubview:userShowImage];
        
        showFace = [UIButton new];
        showFace.frame = CGRectMake(25, 215, 260, 50);
        [showFace.layer setBorderWidth:1.25];
        [showFace.layer setBorderColor:[UIColor blackColor].CGColor];
        showFace.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        showFace.layer.cornerRadius = 4;
        showFace.layer.masksToBounds = YES;
        [mainView addSubview:showFace];
        
        UILabel *showFaceLabel = [UILabel new];
        [showFaceLabel setText:@"显示微博表情"];
        showFaceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        showFaceLabel.textColor = [UIColor whiteColor];
        showFaceLabel.backgroundColor = [UIColor clearColor];
        showFaceLabel.frame = CGRectMake(15, 15, 200, 20);
        showFaceLabel.shadowColor = [UIColor blackColor];
        showFaceLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [showFace addSubview:showFaceLabel];
        
        UISwitch *showFaceSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(175, 12, 0, 0)];
        [showFaceSwitchView addTarget:self action:@selector(showStatusFace:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShowFace"] intValue] == 0){
            showFaceSwitchView.on = NO;
        }else {
            showFaceSwitchView.on = YES;
        }
        [showFace addSubview:showFaceSwitchView];
        
        UILabel *two = [UILabel new];
        [two setText:@"服务"];
        two.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        two.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        two.backgroundColor = [UIColor clearColor];
        two.frame = CGRectMake(35, 280, 40, 20);
        two.shadowColor = [UIColor blackColor];
        two.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:two];
        
        webType = [UIButton new];
        webType.frame = CGRectMake(25, 310, 260, 50);
        [webType.layer setBorderWidth:1.25];
        [webType.layer setBorderColor:[UIColor blackColor].CGColor];
        webType.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        webType.layer.cornerRadius = 4;
        webType.layer.masksToBounds = YES;
        [webType addTarget:self action:@selector(changeWebType) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:webType];
        
        UILabel *webTypeLabel = [UILabel new];
        [webTypeLabel setText:@"网页阅读模式"];
        webTypeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        webTypeLabel.textColor = [UIColor whiteColor];
        webTypeLabel.backgroundColor = [UIColor clearColor];
        webTypeLabel.frame = CGRectMake(15, 15, 120, 20);
        webTypeLabel.shadowColor = [UIColor blackColor];
        webTypeLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [webType addSubview:webTypeLabel];
        
        UIImageView *webTypeImage= [UIImageView new];
        webTypeImage.image = [UIImage imageNamed:@"setting_list"];
        webTypeImage.frame = CGRectMake(229, 18, 16, 14);
        [webType addSubview:webTypeImage];
        
        savePic = [UIButton new];
        savePic.frame = CGRectMake(25, 365, 260, 50);
        [savePic.layer setBorderWidth:1.25];
        [savePic.layer setBorderColor:[UIColor blackColor].CGColor];
        savePic.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        savePic.layer.cornerRadius = 4;
        savePic.layer.masksToBounds = YES;
        [mainView addSubview:savePic];
        
        UILabel *savePicLabel = [UILabel new];
        [savePicLabel setText:@"保存拍摄的照片"];
        savePicLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        savePicLabel.textColor = [UIColor whiteColor];
        savePicLabel.backgroundColor = [UIColor clearColor];
        savePicLabel.frame = CGRectMake(15, 15, 120, 20);
        savePicLabel.shadowColor = [UIColor blackColor];
        savePicLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [savePic addSubview:savePicLabel];
        
        UISwitch *switchView2 = [[UISwitch alloc] initWithFrame:CGRectMake(175, 12, 0, 0)];
        [switchView2 addTarget:self action:@selector(checkSavePic:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShowFace"] intValue] == 0){
            switchView2.on = NO;
        }else {
            switchView2.on = YES;
        }
        [savePic addSubview:switchView2];
        
        webShare = [UIButton new];
        webShare.frame = CGRectMake(25, 420, 260, 50);
        [webShare.layer setBorderWidth:1.25];
        [webShare.layer setBorderColor:[UIColor blackColor].CGColor];
        webShare.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        webShare.layer.cornerRadius = 4;
        webShare.layer.masksToBounds = YES;
        [mainView addSubview:webShare];
        
        UILabel *webShareLabel = [UILabel new];
        [webShareLabel setText:@"分享网页"];
        webShareLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        webShareLabel.textColor = [UIColor whiteColor];
        webShareLabel.backgroundColor = [UIColor clearColor];
        webShareLabel.frame = CGRectMake(15, 15, 120, 20);
        webShareLabel.shadowColor = [UIColor blackColor];
        webShareLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [webShare addSubview:webShareLabel];
        
        UISwitch *switchView3 = [[UISwitch alloc] initWithFrame:CGRectMake(175, 12, 0, 0)];
        [switchView3 addTarget:self action:@selector(checkWebShare:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShareWeb"] intValue] == 0){
            switchView3.on = NO;
        }else {
            switchView3.on = YES;
        }
        [webShare addSubview:switchView3];
        
        UILabel *three = [UILabel new];
        [three setText:@"附加"];
        three.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        three.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        three.backgroundColor = [UIColor clearColor];
        three.frame = CGRectMake(35, 485, 40, 20);
        three.shadowColor = [UIColor blackColor];
        three.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:three];
        
        sound = [UIButton new];
        sound.frame = CGRectMake(25, 510, 260, 50);
        [sound.layer setBorderWidth:1.25];
        [sound.layer setBorderColor:[UIColor blackColor].CGColor];
        sound.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        sound.layer.cornerRadius = 4;
        sound.layer.masksToBounds = YES;
        [mainView addSubview:sound];
        
        UILabel *soundLabel = [UILabel new];
        [soundLabel setText:@"开启提示音"];
        soundLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        soundLabel.textColor = [UIColor whiteColor];
        soundLabel.backgroundColor = [UIColor clearColor];
        soundLabel.frame = CGRectMake(15, 15, 200, 20);
        soundLabel.shadowColor = [UIColor blackColor];
        soundLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [sound addSubview:soundLabel];
        
        UISwitch *switchView4 = [[UISwitch alloc] initWithFrame:CGRectMake(175, 12, 0, 0)];
        [switchView4 addTarget:self action:@selector(changeSound:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NoticeSound"] intValue] == 0){
            switchView4.on = NO;
        }else {
            switchView4.on = YES;
        }
        [sound addSubview:switchView4];
        
        deleteCache = [UIButton new];
        deleteCache.frame = CGRectMake(25, 565, 260, 50);
        [deleteCache.layer setBorderWidth:1.25];
        [deleteCache.layer setBorderColor:[UIColor blackColor].CGColor];
        deleteCache.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        deleteCache.layer.cornerRadius = 4;
        deleteCache.layer.masksToBounds = YES;
        [deleteCache addTarget:self action:@selector(deleteCaching) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:deleteCache];
        
        UILabel *deleteCacheLabel = [UILabel new];
        [deleteCacheLabel setText:@"清空缓存"];
        deleteCacheLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        deleteCacheLabel.textColor = [UIColor whiteColor];
        deleteCacheLabel.backgroundColor = [UIColor clearColor];
        deleteCacheLabel.frame = CGRectMake(15, 15, 120, 20);
        deleteCacheLabel.shadowColor = [UIColor blackColor];
        deleteCacheLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [deleteCache addSubview:deleteCacheLabel];
        
        deleteAD = [UIButton new];
        deleteAD.frame = CGRectMake(25, 620, 260, 50);
        [deleteAD.layer setBorderWidth:1.25];
        [deleteAD.layer setBorderColor:[UIColor blackColor].CGColor];
        deleteAD.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        deleteAD.layer.cornerRadius = 4;
        deleteAD.layer.masksToBounds = YES;
        //[deleteAD addTarget:self action:@selector(deleteAdvert) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:deleteAD];
        
        UILabel *deleteADLabel = [UILabel new];
        [deleteADLabel setText:@"购买高级功能[敬请期待]"];
        deleteADLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        deleteADLabel.textColor = [UIColor whiteColor];
        deleteADLabel.backgroundColor = [UIColor clearColor];
        deleteADLabel.frame = CGRectMake(15, 15, 230, 20);
        deleteADLabel.shadowColor = [UIColor blackColor];
        deleteADLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [deleteAD addSubview:deleteADLabel];
        
        UILabel *four = [UILabel new];
        [four setText:@"关于"];
        four.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        four.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        four.backgroundColor = [UIColor clearColor];
        four.frame = CGRectMake(35, 685, 40, 20);
        four.shadowColor = [UIColor blackColor];
        four.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:four];
        
        atAuthor = [UIButton new];
        atAuthor.frame = CGRectMake(25, 715, 260, 50);
        [atAuthor.layer setBorderWidth:1.25];
        [atAuthor.layer setBorderColor:[UIColor blackColor].CGColor];
        atAuthor.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        atAuthor.layer.cornerRadius = 4;
        atAuthor.layer.masksToBounds = YES;
        [atAuthor addTarget:self action:@selector(catchAtAuthor) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:atAuthor];
        
        UILabel *atAuthorLabel = [UILabel new];
        [atAuthorLabel setText:@"关注作者 @so898"];
        atAuthorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        atAuthorLabel.textColor = [UIColor whiteColor];
        atAuthorLabel.backgroundColor = [UIColor clearColor];
        atAuthorLabel.frame = CGRectMake(15, 15, 200, 20);
        atAuthorLabel.shadowColor = [UIColor blackColor];
        atAuthorLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [atAuthor addSubview:atAuthorLabel];
        
        atWeibo = [UIButton new];
        atWeibo.frame = CGRectMake(25, 770, 260, 50);
        [atWeibo.layer setBorderWidth:1.25];
        [atWeibo.layer setBorderColor:[UIColor blackColor].CGColor];
        atWeibo.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        atWeibo.layer.cornerRadius = 4;
        atWeibo.layer.masksToBounds = YES;
        [atWeibo addTarget:self action:@selector(catchAtWeibo) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:atWeibo];
        
        UILabel *atWeiboLabel = [UILabel new];
        [atWeiboLabel setText:@"关注官方微博 @weipulse"];
        atWeiboLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        atWeiboLabel.textColor = [UIColor whiteColor];
        atWeiboLabel.backgroundColor = [UIColor clearColor];
        atWeiboLabel.frame = CGRectMake(15, 15, 200, 20);
        atWeiboLabel.shadowColor = [UIColor blackColor];
        atWeiboLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [atWeibo addSubview:atWeiboLabel];
        
        help = [UIButton new];
        help.frame = CGRectMake(25, 825, 260, 50);
        [help.layer setBorderWidth:1.25];
        [help.layer setBorderColor:[UIColor blackColor].CGColor];
        help.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        help.layer.cornerRadius = 4;
        help.layer.masksToBounds = YES;
        [help addTarget:self action:@selector(helpView) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:help];
        
        UILabel *helpLabel = [UILabel new];
        [helpLabel setText:@"帮助"];
        helpLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        helpLabel.textColor = [UIColor whiteColor];
        helpLabel.backgroundColor = [UIColor clearColor];
        helpLabel.frame = CGRectMake(15, 15, 200, 20);
        helpLabel.shadowColor = [UIColor blackColor];
        helpLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [help addSubview:helpLabel];
        
        feedback = [UIButton new];
        feedback.frame = CGRectMake(25, 880, 260, 50);
        [feedback.layer setBorderWidth:1.25];
        [feedback.layer setBorderColor:[UIColor blackColor].CGColor];
        feedback.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        feedback.layer.cornerRadius = 4;
        feedback.layer.masksToBounds = YES;
        [feedback addTarget:self action:@selector(feedbackView) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:feedback];
        
        UILabel *feedbackLabel = [UILabel new];
        [feedbackLabel setText:@"反馈"];
        feedbackLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        feedbackLabel.textColor = [UIColor whiteColor];
        feedbackLabel.backgroundColor = [UIColor clearColor];
        feedbackLabel.frame = CGRectMake(15, 15, 200, 20);
        feedbackLabel.shadowColor = [UIColor blackColor];
        feedbackLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [feedback addSubview:feedbackLabel];
        
        about = [UIButton new];
        about.frame = CGRectMake(25, 935, 260, 50);
        [about.layer setBorderWidth:1.25];
        [about.layer setBorderColor:[UIColor blackColor].CGColor];
        about.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        about.layer.cornerRadius = 4;
        about.layer.masksToBounds = YES;
        [about addTarget:self action:@selector(aboutView) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:about];
         
        UILabel *aboutLabel = [UILabel new];
        [aboutLabel setText:@"版权信息"];
        aboutLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        aboutLabel.textColor = [UIColor whiteColor];
        aboutLabel.backgroundColor = [UIColor clearColor];
        aboutLabel.frame = CGRectMake(15, 15, 200, 20);
        aboutLabel.shadowColor = [UIColor blackColor];
        aboutLabel.shadowOffset = CGSizeMake(0, -1.0f);
        [about addSubview:aboutLabel];
        
        UILabel *five = [UILabel new];
        [five setText:@"WeiPulse 新浪微博版\n1.0.0\nR³ Studio 荣誉出品"];
        five.textAlignment = UITextAlignmentCenter;
        five.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        five.numberOfLines = 0;
        five.lineBreakMode = UILineBreakModeWordWrap;
        five.frame = CGRectMake(0, 1000, 310, 45);
        five.textColor = [UIColor colorWithRed:0.7176 green:0.8314 blue:0.949 alpha:1.];
        five.backgroundColor = [UIColor clearColor];
        five.shadowColor = [UIColor blackColor];
        five.shadowOffset = CGSizeMake(0, -1.0f);
        [mainView addSubview:five];
        
        
        
    }
    return self;
}

+ (SettingViewController*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[SettingViewController new];
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
    MenuViewController *menu = [MenuViewController getInstance];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = menu;
    }
    self.slidingViewController.underRightViewController = nil;
    self.slidingViewController.anchorLeftPeekAmount     = 0;
    self.slidingViewController.anchorLeftRevealAmount   = 0;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [self makeListeners];
}

- (void)makeListeners
{
    if (!listener){
        listener = YES;
        [defaultNotifCenter addObserver:self selector:@selector(mmFollowUser:)   name:MMSinaFollowedByUserIDWithResult         object:nil];
    }
    
}

- (void)deleteListeners
{
    if (listener){
        listener = NO;
        [defaultNotifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult             object:nil];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deleteListeners];
}

- (void)mmFollowUser: (NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    if (1672691382 == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"关注 @so898 成功"];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"关注"
                            subtitle:title
                           hideAfter:3.0];
    } else if (2898134082 == [[dic objectForKey:@"uid"] longLongValue]){
        NSString *title = [[NSString alloc] initWithFormat:@"关注 @WeiPulse 成功"];
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"关注"
                            subtitle:title
                           hideAfter:3.0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    listener = NO;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    manager = [WeiBoMessageManager getInstance];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)changeFont
{
    [UIView animateWithDuration:0.3 animations:^{font.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        NSArray *_options = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"小号",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"中号",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"大号",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"超大号",@"text", nil],
                             nil];
        NSString *tmp = [NSString new];
        switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Font"] intValue]) {
            case 0:
                tmp = @"小号";
                break;
            case 1:
                tmp = @"中号";
                break;
            case 2:
                tmp = @"大号";
                break;
            case 3:
                tmp = @"超大号";
                break;
            default:
                break;
        }
        NSString *title = [[NSString alloc] initWithFormat:@"当前: %@",tmp];
        fontList = [[LeveyPopListView alloc] initWithTitle:title options:_options];
        fontList.delegate = self;
        [fontList showInView:self.view.window animated:YES];
        [UIView animateWithDuration:0.3 animations:^{font.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}]; }];
    
}

- (void)checkTimeStamp:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"TimeStamp"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"TimeStamp"];
    }
}

- (void)changeFontUserShow
{
    [UIView animateWithDuration:0.3 animations:^{userShow.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        NSArray *_options = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"只显示用户名",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"优先显示昵称",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"用户名（昵称）",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"昵称（用户名）",@"text", nil],
                             nil];
        NSString *tmp = [NSString new];
        switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] intValue]) {
            case 0:
                tmp = @"只显示用户名";
                break;
            case 1:
                tmp = @"优先显示昵称";
                break;
            case 2:
                tmp = @"用户名（昵称）";
                break;
            case 3:
                tmp = @"昵称（用户名）";
                break;
            default:
                break;
        }
        NSString *title = [[NSString alloc] initWithFormat:@"当前: %@",tmp];
        userShowList = [[LeveyPopListView alloc] initWithTitle:title options:_options];
        userShowList.delegate = self;
        [userShowList showInView:self.view.window animated:YES];
        [UIView animateWithDuration:0.3 animations:^{userShow.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}]; }];
    
}

- (void)showStatusFace:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShowFace"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"ShowFace"];
    }
}

- (void)changeWebType
{
    [UIView animateWithDuration:0.3 animations:^{webType.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        NSArray *_options = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"原网页",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"移动版页面",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"新浪转码",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"百度转码",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"谷歌转码",@"text", nil],
                             nil];
        NSString *tmp = [NSString new];
        switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WebReader"] intValue]) {
            case 0:
                tmp = @"原网页";
                break;
            case 1:
                tmp = @"移动版页面";
                break;
            case 2:
                tmp = @"新浪转码";
                break;
            case 3:
                tmp = @"百度转码";
                break;
            case 4:
                tmp = @"谷歌转码";
                break;
            default:
                break;
        }
        NSString *title = [[NSString alloc] initWithFormat:@"当前: %@",tmp];
        webTypeList = [[LeveyPopListView alloc] initWithTitle:title options:_options];
        webTypeList.delegate = self;
        [webTypeList showInView:self.view.window animated:YES];
        [UIView animateWithDuration:0.3 animations:^{webType.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}]; }];
    
}

- (void)checkSavePic:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"StorePhoto"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"StorePhoto"];
    }
}

- (void)changeSound:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"NoticeSound"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"NoticeSound"];
    }
}

- (void)checkWebShare:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShareWeb"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"ShareWeb"];
    }
}

- (void)deleteCaching
{
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [UIView animateWithDuration:0.3 animations:^{deleteCache.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        [UIView animateWithDuration:0.3 animations:^{deleteCache.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}]; }];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filename in fileArray)  {
        [fileMgr removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    
}

- (void)deleteAdvert
{
    [UIView animateWithDuration:0.3 animations:^{deleteAD.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        p = [Purchases new];
        p.delegate = self;
        [p buy];
        [UIView animateWithDuration:0.3 animations:^{deleteAD.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}];
    }];
}

- (void)catchAtAuthor
{
    [UIView animateWithDuration:0.3 animations:^{atAuthor.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        [manager followByUserName:@"so898"];
        [UIView animateWithDuration:0.3 animations:^{atAuthor.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}];
    }];
}

- (void)catchAtWeibo
{
    [UIView animateWithDuration:0.3 animations:^{atWeibo.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        [manager followByUserName:@"weipulse"];
        [UIView animateWithDuration:0.3 animations:^{atWeibo.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}];
    }];
}

- (void)helpView
{
    [UIView animateWithDuration:0.3 animations:^{help.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        DocumentViewController *d = [DocumentViewController new];
        self.slidingViewController.topCoverViewController = d;
        [d setLocalWeb:@"help" title:@"帮助"];
        [UIView animateWithDuration:0.3 animations:^{help.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}];
    }];
}

- (void)feedbackView
{
    [UIView animateWithDuration:0.3 animations:^{feedback.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){ [UIView animateWithDuration:0.3 animations:^{feedback.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];}];
        MFMailComposeViewController *controller = [MFMailComposeViewController new];
        if ([MFMailComposeViewController canSendMail]){
            NSString *title = @"WeiPulse 1.0的反馈信息";
            [controller setSubject:title];
            NSArray *toRecipients = [NSArray arrayWithObject: @"so89898@gmail.com"];
            [controller setToRecipients:toRecipients];
            controller.mailComposeDelegate = (id)self;
            [self presentModalViewController:controller animated:YES];
        }
    }];
}

- (void)aboutView
{
    [UIView animateWithDuration:0.3 animations:^{about.backgroundColor = [UIColor colorWithRed:0.2824 green:0.5412 blue:0.7843 alpha:0.5];} completion:^(BOOL complete){
        DocumentViewController *d = [DocumentViewController new];
        self.slidingViewController.topCoverViewController = d;
        [d setLocalWeb:@"Lisence" title:@"关于"];
        [UIView animateWithDuration:0.3 animations:^{about.backgroundColor = [UIColor colorWithRed:0.3098 green:0.3176 blue:0.3216 alpha:0.5];
        }];
    }];
}

#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if (popListView == fontList){
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        int oldValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Font"] intValue];
        if (anIndex != oldValue){
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:anIndex] forKey:@"Font"];
            [[HomeViewController getInstance] changeSetting];
            if ([MessageViewController returnInstance])
                [[MessageViewController getInstance] changeSetting];
            if ([HotViewController returnInstance])
                [[HotViewController getInstance] changeSetting];
            if ([PersonViewController returnInstance])
                [[PersonViewController getInstance] changeSetting];
            
        }
        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    } else if (popListView == userShowList){
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        int oldValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] intValue];
        if (anIndex != oldValue){
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:anIndex] forKey:@"UserName"];
            [[HomeViewController getInstance] changeSetting];
            if ([MessageViewController returnInstance])
                [[MessageViewController getInstance] changeSetting];
            if ([HotViewController returnInstance])
                [[HotViewController getInstance] changeSetting];
        }
        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    } else if (popListView == webTypeList){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:anIndex] forKey:@"WebReader"];
    }
}

- (void)leveyPopListViewDidCancel
{
    //NSLog(@"Here");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slidingViewController resetTopView];
}

#pragma PurchaseDelegate

- (void)Done
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"购买成功" message:@"感谢您购买WeiPulse高级版，现在您可以使用高级版的功能了。"];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

- (void)Restore
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"恢复成功" message:@"您的购买记录已经恢复，现在您可以使用高级版的功能了。"];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

- (void)Fail
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"购买失败" message:@"感谢您对WeiPulse的支持，不过很遗憾，您的此次购买失败了。\n请尝试更换您的网络环境后重新购买。"];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

- (void)Stop
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"购买失败" message:@"感谢您对WeiPulse的支持，不过很遗憾，您的此次购买失败了。\n请您手动在设置选项中开启IAP购买功能，之后再次尝试购买WeiPulse高级版。"];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

- (void)Info
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"确认购买" message:@"感谢您对WeiPulse的支持，在您点击确定之后，软件便会开始购买流程。\nWeiPulse高级版：6元"];
    [alert setDestructiveButtonWithTitle:@"确定" block:^{[p confirm:YES];}];
    [alert setCancelButtonWithTitle:@"取消" block:^{[p confirm:NO];}];
    [alert show];
}

- (void)Error:(NSString *)type
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"购买失败" message:[NSString stringWithFormat:@"感谢您对WeiPulse的支持，不过很遗憾，您的此次购买失败了。\n%@", type]];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

@end
