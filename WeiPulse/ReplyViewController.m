//
//  ReplyViewController.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-24.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "ReplyViewController.h"
#import "MTInfoPanel.h"
#import "ImageDetailViewController.h"
#import "HtmlString.h"
#import "Sound.h"
#import "BlockAlertView.h"

@interface ReplyViewController ()

@end

@implementation ReplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        manager = [WeiBoMessageManager getInstance];
        self.view.frame = CGRectMake(0, 0, 320, 460);
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0;
        // Do any additional setup after loading the view.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:input];
        //draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
        atType = NO;
        hotType = NO;
        commentOrigin = 0;
        
        //main scroll view
        scrollview = [UIScrollView new];
        scrollview.frame = CGRectMake(0, 460, 320, 460);
        scrollview.contentMode = UIViewContentModeCenter;
        scrollview.delegate = (id)self;
        [scrollview setShowsVerticalScrollIndicator:NO];
        [scrollview setShowsHorizontalScrollIndicator:NO];
        [scrollview setPagingEnabled:NO];
        scrollview.alwaysBounceVertical=YES;
        scrollview.layer.cornerRadius = 6;
        scrollview.layer.masksToBounds = YES;
        [self.view addSubview:scrollview];
        scrollview.scrollEnabled = NO;
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - scrollview.bounds.size.height, 320, scrollview.bounds.size.height)];
        view.delegate = self;
        [scrollview addSubview:view];
        _refreshHeaderView = view;
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _refreshHeaderView.userInteractionEnabled = NO;
        
        mainView = [UIView new];
        mainView.frame = CGRectMake(0, 0, 320, 460);
        mainView.layer.cornerRadius = 6;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add_message_backg"]];
        [scrollview addSubview:mainView];
        
        input = [[UITextView alloc] initWithFrame:CGRectMake(8,50,304,150)];
        //文字显示位置，这里居左对齐
        input.textAlignment = UITextAlignmentLeft;
        //默认显示文字颜色
        input.textColor = [UIColor whiteColor];
        //设置输入的字体
        input.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:0] size:18];
        input.delegate = self;
        [input setKeyboardType:UIKeyboardTypeTwitter];
        input.returnKeyType = UIReturnKeyDefault;
        input.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
        input.layer.cornerRadius = 5;
        input.layer.masksToBounds = YES;
        [mainView addSubview:input];
        [self createInoutAccessoryView];
        input.inputAccessoryView = inputAccView;
        
        dragBackg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"drag_backg"] stretchableImageWithLeftCapWidth:15 topCapHeight:7]];
        dragBackg.frame = CGRectMake(15, 4, 150, 44);
        [mainView addSubview:dragBackg];
        
        dragText = [UILabel new];
        [dragText setText:@"下拉发送"];
        dragText.frame = CGRectMake(70, 9, 100, 35);
        dragText.backgroundColor = [UIColor clearColor];
        dragText.textColor = [UIColor whiteColor];
        [mainView addSubview:dragText];
        
        dragIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drag_icon.png"]];
        dragIcon.frame = CGRectMake(20, 4, 44, 44);
        [mainView addSubview:dragIcon];
        
        buttonBackg = [UIView new];
        buttonBackg.frame = CGRectMake(260, 4, 44, 44);
        buttonBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
        [mainView addSubview:buttonBackg];
        
        exit = [UIButton new];
        exit.frame = CGRectMake(265, 9, 35, 35);
        [exit setImage:[UIImage imageNamed:@"exit_button"] forState:UIControlStateNormal];
        [exit setImage:[UIImage imageNamed:@"exit_button_hl"] forState:UIControlStateHighlighted];
        [exit addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:exit];
        
        UIView *backg = [UIView new];
        backg.backgroundColor = [UIColor grayColor];
        backg.alpha = 0.5f;
        backg.frame = CGRectMake(8, 210, 304, 240);
        backg.layer.cornerRadius = 5;
        backg.layer.masksToBounds = YES;
        [mainView addSubview:backg];
        
        num = [UILabel new];
        num.textAlignment = UITextAlignmentCenter;
        [mainView addSubview:num];
        [num setText:[[NSString alloc] initWithFormat:@"评论字数：%d",input.text.length]];
        num.frame = CGRectMake(8, 210, 304, 30);
        num.layer.cornerRadius = 5;
        num.layer.masksToBounds = YES;
        num.backgroundColor = [UIColor grayColor];
        num.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //input staff
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComment:) name:MMSinaGotComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed        object:nil];
    //build view and animation
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    input = nil;
    inputAccView = nil;
    mainView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotComment object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaRequestFailed object:nil];
}

- (void)setStatus:(Status *)s type:(ReplyViewType)t
{
    sts = s;
    type = t;
    toComment = NO;
    if (sts.retweetedStatus){
        UIImage * backImage = [[UIImage imageNamed:@"blue_button"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        UIImage * backImage2 = [[UIImage imageNamed:@"blue_button_hl"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        commentOri = [UIButton new];
        commentOri.frame = CGRectMake( 15, 245, 290, 40);
        [commentOri setTitle:@"同时评论到原微博" forState:UIControlStateNormal];
        [commentOri setBackgroundImage:backImage forState:UIControlStateNormal];
        [commentOri setBackgroundImage:backImage2 forState:UIControlStateHighlighted];
        [commentOri addTarget:self action:@selector(commentOnOri) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:commentOri];
        
        textBackg = [UIScrollView new];
        textBackg.frame = CGRectMake( 15, 290, 290, 155);
        textBackg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        textBackg.alwaysBounceVertical=YES;
        [mainView addSubview:textBackg];
    } else {
        textBackg = [UIScrollView new];
        textBackg.frame = CGRectMake( 15, 245, 290, 200);
        textBackg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        textBackg.alwaysBounceVertical=YES;
        [mainView addSubview:textBackg];
    }
    
    text = [OHAttributedLabel new];
    text.backgroundColor = [UIColor clearColor];
    text.userInteractionEnabled = YES;
    text.automaticallyAddLinksForType = 0;
    text.underlineLinks = NO;
    text.textColor = [UIColor whiteColor];
    [textBackg addSubview:text];
    
    NSString *transformStr = [HtmlString transformString:sts.text];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [attString setTextColor:[UIColor whiteColor]];
    [text setAttString:attString withImages:p.images];
    text.frame = CGRectMake(10, 10, 280, 60);
    CGRect labelRect = text.frame;
    labelRect.size.width = [text sizeThatFits:CGSizeMake(280, CGFLOAT_MAX)].width;
    labelRect.size.height = [text sizeThatFits:CGSizeMake(280, CGFLOAT_MAX)].height;
    text.frame = labelRect;
    textBackg.contentSize = CGSizeMake(290, text.frame.size.height + 10);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;} completion:^(BOOL iscomplete){
            [UIView animateWithDuration:0.2 animations:^{
                scrollview.frame = CGRectMake(0, 0, 320, 460);
            }];
        }];
}

- (void)setComment:(Comment *)c type:(ReplyViewType)t
{
    com = c;
    type = t;
    toComment = YES;
    if (sts.retweetedStatus){
        UIImage * backImage = [[UIImage imageNamed:@"blue_button"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        UIImage * backImage2 = [[UIImage imageNamed:@"blue_button_hl"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        commentOri = [UIButton new];
        commentOri.frame = CGRectMake( 15, 245, 290, 40);
        [commentOri setTitle:@"同时评论到原微博" forState:UIControlStateNormal];
        [commentOri setBackgroundImage:backImage forState:UIControlStateNormal];
        [commentOri setBackgroundImage:backImage2 forState:UIControlStateHighlighted];
        [commentOri addTarget:self action:@selector(commentOnOri) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:commentOri];
        
        textBackg = [UIScrollView new];
        textBackg.frame = CGRectMake( 15, 290, 290, 155);
        textBackg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        textBackg.alwaysBounceVertical=YES;
        [mainView addSubview:textBackg];
    } else {
        textBackg = [UIScrollView new];
        textBackg.frame = CGRectMake( 15, 245, 290, 200);
        textBackg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        textBackg.alwaysBounceVertical=YES;
        [mainView addSubview:textBackg];
    }
    
    text = [OHAttributedLabel new];
    text.backgroundColor = [UIColor clearColor];
    text.userInteractionEnabled = YES;
    text.automaticallyAddLinksForType = 0;
    text.underlineLinks = NO;
    text.textColor = [UIColor whiteColor];
    [textBackg addSubview:text];
    
    NSString *transformStr = [HtmlString transformString:com.text];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [attString setTextColor:[UIColor whiteColor]];
    [text setAttString:attString withImages:p.images];
    text.frame = CGRectMake(10, 10, 280, 60);
    CGRect labelRect = text.frame;
    labelRect.size.width = [text sizeThatFits:CGSizeMake(280, CGFLOAT_MAX)].width;
    labelRect.size.height = [text sizeThatFits:CGSizeMake(280, CGFLOAT_MAX)].height;
    text.frame = labelRect;
    textBackg.contentSize = CGSizeMake(290, text.frame.size.height + 10);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;} completion:^(BOOL iscomplete){
            [UIView animateWithDuration:0.2 animations:^{
                scrollview.frame = CGRectMake(0, 0, 320, 460);
            }];
        }];
}

- (void)commentOnOri
{
    if (commentOrigin == 0){
        commentOrigin = 1;
        UIImage * backImage = [[UIImage imageNamed:@"blue_button_choice"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        [commentOri setBackgroundImage:backImage forState:UIControlStateNormal];
    } else {
        commentOrigin = 0;
        UIImage * backImage = [[UIImage imageNamed:@"blue_button"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        [commentOri setBackgroundImage:backImage forState:UIControlStateNormal];
    }
        
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textChanged:(NSNotification *)notification{
	_allowed = input.text.length > 0;
	if (input.text.length == 0){
        scrollview.scrollEnabled = NO;
    }
    else {
        scrollview.scrollEnabled = YES;
    }
    [num setText:[[NSString alloc] initWithFormat:@"评论字数：%d",input.text.length]];
    if (num_s){
        [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
    }
}

- (void)changeToAtType
{
    if (atType){
        [input resignFirstResponder];
        if ([input.inputView respondsToSelector:@selector(deleteListeners)]){
            [input.inputView performSelector:@selector(deleteListeners)];
        }
        input.inputView = nil;
        [input reloadInputViews];
        [input becomeFirstResponder];
        atType = NO;
    } else {
        AtUserView *tmp = [AtUserView new];
        tmp.frame = CGRectMake(0, 0, 320, 216);
        tmp.delegate = self;
        [tmp loadView];
        input.inputView = tmp;
        [input reloadInputViews];
        atType = YES;
    }
}

- (void) returnUserName:(NSString *)name
{
    [input setText:[[NSString alloc] initWithFormat:@"%@@%@ ",input.text,name]];
    [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
    [input resignFirstResponder];
    if ([input.inputView respondsToSelector:@selector(deleteListeners)]){
        [input.inputView performSelector:@selector(deleteListeners)];
    }
    input.inputView = nil;
    [input reloadInputViews];
    [input becomeFirstResponder];
    atType = NO;
}

- (void) changeToHotType
{
    if (hotType){
        [input resignFirstResponder];
        if ([input.inputView respondsToSelector:@selector(deleteListeners)]){
            [input.inputView performSelector:@selector(deleteListeners)];
        }
        input.inputView = nil;
        [input reloadInputViews];
        [input becomeFirstResponder];
        hotType = NO;
    } else {
        HotTypeView *tmp = [HotTypeView new];
        tmp.frame = CGRectMake(0, 0, 320, 216);
        tmp.delegate = self;
        [tmp loadView];
        input.inputView = tmp;
        [input reloadInputViews];
        hotType = YES;
    }
}

- (void)returnHotTrend:(NSString *)trend
{
    [input setText:[[NSString alloc] initWithFormat:@"%@#%@#",input.text,trend]];
    [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
    [input resignFirstResponder];
    if ([input.inputView respondsToSelector:@selector(deleteListeners)]){
        [input.inputView performSelector:@selector(deleteListeners)];
    }
    input.inputView = nil;
    [input reloadInputViews];
    [input becomeFirstResponder];
    hotType = NO;
}

- (void)autoDelete
{
    if (input.text.length > 140)
        input.text = [input.text substringToIndex:140];
}

- (void)createInoutAccessoryView
{
    inputAccView = [UIView new];
    inputAccView.frame = CGRectMake(0, 0, 320, 40);
    inputAccView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add_message_backg"]];
    
    
    UIButton *at_s = [UIButton new];
    at_s.frame = CGRectMake(10, 5, 30, 30);
    [inputAccView addSubview:at_s];
    UIImageView *at_i = [UIImageView new];
    at_i.image = [UIImage imageNamed:@"at_s"];
    at_i.frame = CGRectMake(3.5, 5.5, 23, 19);
    [at_s addSubview:at_i];
    [at_s addTarget:self action:@selector(changeToAtType) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *topic_s = [UIButton new];
    topic_s.frame = CGRectMake(50, 5, 30, 30);
    [inputAccView addSubview:topic_s];
    UIImageView *topic_i = [UIImageView new];
    topic_i.image = [UIImage imageNamed:@"topic_s"];
    topic_i.frame = CGRectMake(3.5, 5.5, 23, 19);
    [topic_s addSubview:topic_i];
    [topic_s addTarget:self action:@selector(changeToHotType) forControlEvents:UIControlEventTouchUpInside];
    
    /*UIButton *face_s = [UIButton new];
     face_s.frame = CGRectMake(90, 5, 30, 30);
     [inputAccView addSubview:face_s];
     UIImageView *face_i = [UIImageView new];
     face_i.image = [UIImage imageNamed:@"face"];
     face_i.frame = CGRectMake(3.5, 5.5, 23, 19);
     [face_s addSubview:face_i];*/
    
    num_s = [UILabel new];
    [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
    num_s.textAlignment = UITextAlignmentCenter;
    num_s.frame = CGRectMake(130, 5, 110, 30);
    num_s.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
    num_s.backgroundColor = [UIColor clearColor];
    [inputAccView addSubview:num_s];
    
    UIButton *autodel_s = [UIButton new];
    autodel_s.frame = CGRectMake(240, 5, 30, 30);
    [inputAccView addSubview:autodel_s];
    UIImageView *autodel_i = [UIImageView new];
    autodel_i.image = [UIImage imageNamed:@"autodel_s"];
    autodel_i.frame = CGRectMake(7, 7, 16, 16);
    [autodel_s addSubview:autodel_i];
    [autodel_s addTarget:self action:@selector(autoDelete) forControlEvents:UIControlEventTouchUpInside];
    
    closetype = [UIButton new];
    closetype.frame = CGRectMake(280, 5, 30, 30);
    [closetype addTarget:self action:@selector(doneEditing) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:closetype];
    UIImageView *closetype_i = [UIImageView new];
    closetype_i.image = [UIImage imageNamed:@"closetype"];
    closetype_i.frame = CGRectMake(3.5, 5.5, 23, 19);
    [closetype addSubview:closetype_i];
    
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
	if (input.text.length >= 140)
    {
        //input.text = [input.text substringToIndex:140];
        scrollview.scrollEnabled = NO;
    }
    [UIView animateWithDuration:0.2 animations:^{
        dragText.alpha =0;
        dragIcon.alpha=0;
        buttonBackg.alpha =0;
        exit.alpha =0;
        dragBackg.alpha = 0;} ];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext
{
    /*if ([atext isEqualToString:@"@"]){
        NSLog(@"Here");
        return NO;
    }
    else if ([atext isEqualToString:@"#"]){
        NSLog(@"Here");
        return NO;
    }*/
    return YES;
}

- (void)doneEditing
{
    [input resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        dragText.alpha =1;
        dragIcon.alpha=1;
        buttonBackg.alpha =1;
        exit.alpha =1;
        dragBackg.alpha =1;} ];
    closetype = nil;
    
}

- (void)mmRequestFailed:(NSNotification *)sender
{
    NSString *note = sender.object;
    NSString *notic = [[NSString alloc] initWithFormat:@"网络连接失败\n%@",note];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"发送失败" message:notic];
    [alert setCancelButtonWithTitle:@"重新发送" block:^{
        [self reloadTableViewDataSource];
    }];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
}

- (void) Exit
{
    if (type == ReplyViewFromTopCoverView)
        [self dismissModalViewControllerAnimated:YES];
    else if (type == ReplyViewFromTopView){
        [UIView animateWithDuration:0.3 animations:^{self.view.frame = CGRectMake(0, 460, 320, 460);} completion:^(BOOL complete){
            UIViewController *tmp = [UIViewController new];
            tmp.view.userInteractionEnabled = NO;
            self.slidingViewController.topCoverViewController=tmp;
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //[inputAccView moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    CGRect newTextViewFrame = CGRectMake(0, 0, 320, 460 - keyboardRect.size.height);
    [UIView animateWithDuration:animationDuration animations:^{input.frame = newTextViewFrame;}];
    
    scrollview.alwaysBounceVertical=NO;
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    input.frame = CGRectMake(8,50,304,150);
    scrollview.alwaysBounceVertical=YES;
    [UIView commitAnimations];
}

- (void)showImageDetail
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [self presentModalViewController:imageDetail animated:YES];
    //[imageDetail setImage:showPhoto.image];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    [input setEditable:NO];
	_reloading = YES;
    if (!toComment)
        [manager comment:[NSString stringWithFormat:@"%lld", sts.statusId] content:input.text commentOri:commentOrigin];
    else
        [manager commentOnComment:[NSString stringWithFormat:@"%lld", com.commentId] weiboID:[NSString stringWithFormat:@"%lld", com.status.statusId] content:input.text commentOri:commentOrigin];
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollview];
	[UIView animateWithDuration:0.2
                     animations:^{
                         if (type == ReplyViewFromTopCoverView)
                             [self dismissModalViewControllerAnimated:YES];
                         else if (type == ReplyViewFromTopView){
                             self.view.frame = CGRectMake(0, 460, 320, 460);
                         }
                         [Sound SendSound];
                     }
                     completion:^(BOOL finished)
     {if (finished){
        if (type == ReplyViewFromTopView){
            UIViewController *tmp = [UIViewController new];
            tmp.view.userInteractionEnabled = NO;
            self.slidingViewController.topCoverViewController=tmp;
        }
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"发送评论"
                            subtitle:@"评论已成功发送"
                           hideAfter:3.0];
    }
     }];
}

-(void)didComment:(NSNotification*)sender
{
    Comment *acom = sender.object;
	if (acom.text != nil && [acom.text length] != 0) {
        [self doneLoadingTableViewData];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
