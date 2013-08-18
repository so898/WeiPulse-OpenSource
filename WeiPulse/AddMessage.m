//
//  AddMessage.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-6.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "AddMessage.h"
#import "BlockActionSheet.h"
#import "BlockAlertView.h"
#import "Status.h"
#import "MTInfoPanel.h"
#import "ImageDetailViewController.h"
#import "MapView.h"
#import "Sound.h"

@interface AddMessage ()

@end

@implementation AddMessage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        manager = [WeiBoMessageManager getInstance];
        type = AddMessageFromTopView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:input];
    //draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
    _images = [UIImage new];
    _image = NO;
    _location = NO;
    atType = NO;
    hotType = NO;
    
    
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
    
    //UIView *dragBackg = [[UIView alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
    //dragBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"drag_sign"]];
    //[mainView addSubview:dragBackg];
    //UIView *leftDrag = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 20, 360)];
    //leftDrag.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"drag_sign"]];
    //[mainView addSubview:leftDrag];
    
    //UIView *rightDrag = [[UIView alloc] initWithFrame:CGRectMake(300, 100, 20, 360)];
    //rightDrag.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"drag_sign"]];
    //[mainView addSubview:rightDrag];
    
    
    
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
    
    
    
    
    
    //add staff
    buttonBackg = [UIView new];
    buttonBackg.frame = CGRectMake(260, 4, 44, 44);
    buttonBackg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"button_backg"]];
    [mainView addSubview:buttonBackg];
    
    exit = [UIButton new];
    exit.frame = CGRectMake(265, 9, 35, 35);
    //[exit setTitle:@"X" forState:UIControlStateNormal];
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
    [num setText:[[NSString alloc] initWithFormat:@"微博字数：%d",input.text.length]];
    num.frame = CGRectMake(8, 210, 304, 30);
    num.layer.cornerRadius = 5;
    num.layer.masksToBounds = YES;
    num.backgroundColor = [UIColor grayColor];
    num.textColor = [UIColor blackColor];
    
    UIImage * backImage = [[UIImage imageNamed:@"action_black_button"] stretchableImageWithLeftCapWidth:15 topCapHeight:7];
    photo = [UIButton new];
    photo.frame = CGRectMake( 20, 260, 280, 85);
    [photo setTitle:@"照 片" forState:UIControlStateNormal];
    [photo setBackgroundImage:backImage forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:photo];
    
    
    location = [UIButton new];
    location.frame = CGRectMake( 20, 355, 280, 85);
    [location setTitle:@"定 位" forState:UIControlStateNormal];
    [location setBackgroundImage:backImage forState:UIControlStateNormal];
    [location addTarget:self action:@selector(setupLocationManager) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:location];
    
    
    
    //input staff
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    //build view and animation
    self.view.frame = CGRectMake(0, 0, 320, 460);
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;} completion:^(BOOL iscomplete){
        [UIView animateWithDuration:0.2 animations:^{
            scrollview.frame = CGRectMake(0, 0, 320, 460);
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed        object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotPostResult object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaRequestFailed object:nil];
}

- (void) setUser:(NSString *)name type:(AddMessageType)t
{
    type = t;
    input.text = [NSString stringWithFormat:@"@%@",name];
    [num setText:[[NSString alloc] initWithFormat:@"微博字数：%d",input.text.length]];
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
    [num setText:[[NSString alloc] initWithFormat:@"微博字数：%d",input.text.length]];
    if (num_s){
        [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
    }
	//draft.text = input.text;
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
    
        // Loading the AccessoryView nib file sets the accessoryView outlet.
    //NSLog(@"Here");
      
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        //self.inputAccView = nil;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /*if ([text isEqualToString:@"@"]){
        NSLog(@"Here");
        return NO;
    }
    else if ([text isEqualToString:@"#"]){
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
    if (type == AddMessageFromTopCoverView)
        [self dismissModalViewControllerAnimated:YES];
    else if (type == AddMessageFromTopView){
        [UIView animateWithDuration:0.3 animations:^{self.view.frame = CGRectMake(0, 560, 320, 460);} completion:^(BOOL complete){
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
    NSLog(@"sadasda");
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
    [num_s setText:[[NSString alloc] initWithFormat:@"%d",(140 - input.text.length)]];
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

- (void)addPic
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"导入图片"];
    [sheet addButtonWithTitle:@"从相册导入照片" block:^{
        [self addPicFromGallery];
    }];
    [sheet addButtonWithTitle:@"拍照" block:^{
        [self addPicFromCamare];
    }];
    [sheet setCancelButtonWithTitle:@"取消" block:^{}];
    [sheet showInView:self.view];
}

- (void)addAndDelPic
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"更换或删除图片"];
    [sheet setDestructiveButtonWithTitle:@"删除照片" block:^{
        [self deleteImage];
    }];
    [sheet addButtonWithTitle:@"从相册导入照片" block:^{
        [self addPicFromGallery];
    }];
    [sheet addButtonWithTitle:@"拍照" block:^{
        [self addPicFromCamare];
    }];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    [sheet showInView:self.view];
}

- (void)addAndDelLocation
{
    NSString *showString = [[NSString alloc]initWithFormat:@"更改或删除地理位置\n经度：%f\n纬度：%f",checkLocation.coordinate.latitude, checkLocation.coordinate.longitude];
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:showString];
    [sheet setDestructiveButtonWithTitle:@"删除地理位置" block:^{
        [self deleteLocation];
    }];
    [sheet addButtonWithTitle:@"重新获取地理位置" block:^{
        [self setupLocationManager];
    }];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    [sheet showInView:self.view];
}

- (void)deleteLocation
{
    [UIView animateWithDuration:0.5 animations:^{
        showLocation.alpha =0;
        }
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:0.5 animations:^{location.frame = CGRectMake( 20, 355, 280, 85);
                         }];}
     ];
    [location removeTarget:self action:@selector(addAndDelLocation) forControlEvents:UIControlEventTouchUpInside];
    [location addTarget:self action:@selector(setupLocationManager) forControlEvents:UIControlEventTouchUpInside];
    _location = NO;
    [showLocation removeTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchUpInside];
    [showLocation removeFromSuperview];
}

- (void)deleteImage
{
    [UIView animateWithDuration:0.5 animations:^{
        showPhotoBack.alpha =0;}
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:0.5 animations:^{photo.frame = CGRectMake( 20, 260, 280, 85);
                         }];}];
    _images = nil;
    _image = NO;
    [photo removeTarget:self action:@selector(addAndDelPic) forControlEvents:UIControlEventTouchUpInside];
    [photo addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    [showPhotoBack removeFromSuperview];
}

-(void) addPicFromGallery
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    //picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

- (void) addPicFromCamare
{
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}   
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    //picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

- (void) addImage:(UIImage *)image
{
    [HUD hide:YES];
    if (_image){
        _images = image;
        [UIView animateWithDuration:0.5 animations:^{
            showPhotoBack.alpha =0;
        } completion:^(BOOL complete){
            showPhoto.image = image;
            [UIView animateWithDuration:0.5 animations:^{
                showPhotoBack.alpha =1;
                }];
        }];
    }
    _images = image;
    _image = YES;
    
    showPhoto = [[UIImageView alloc] initWithImage:image];
    showPhoto.frame = CGRectMake(2, 2, 65, 65);
    showPhotoBack = [UIButton new];
    showPhotoBack.frame = CGRectMake(228, 268, 69, 69);
    showPhotoBack.backgroundColor = [UIColor grayColor];
    [showPhotoBack addTarget:self action:@selector(showImageDetail) forControlEvents:UIControlEventTouchUpInside];
    [showPhotoBack addSubview:showPhoto];
    [mainView addSubview:showPhotoBack];
    showPhotoBack.alpha = 0.0f;
    [showPhoto setClipsToBounds:YES];
    showPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [UIView animateWithDuration:0.5 animations:^{
    photo.frame = CGRectMake( 20, 260, 200, 85);}
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:0.5 animations:^{showPhotoBack.alpha =1;
                         }];
                     }];
    [photo removeTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    [photo addTarget:self action:@selector(addAndDelPic) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showImageDetail
{
    ImageDetailViewController *imageDetail = [ImageDetailViewController new];
    [self presentModalViewController:imageDetail animated:YES];
    [imageDetail setImage:showPhoto.image];
}

- (void) setupLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]){
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    else {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"定位服务不可用" message:@"建议开启定位服务（设置 > 定位服务 > 开启WeiPulse定位服务）"];
        [alert setCancelButtonWithTitle:@"确定" block:nil];
        [alert show];
    }
}

- (void)showLocation
{
    MapView *m = [MapView new];
    [m setMap:checkLocation];
    [self.view addSubview:m];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    [input setEditable:NO];
	_reloading = YES;
    if (_location && _image){
        [manager postWithText:input.text image:_images :checkLocation.coordinate.latitude :checkLocation.coordinate.longitude];
    } else if (_location){
        [manager postWithText:input.text :checkLocation.coordinate.latitude :checkLocation.coordinate.longitude];
    } else if (_image){
        [manager postWithText:input.text image:_images];
    }
    else {
        //[self postNewStatus];
        [manager postWithText:input.text];
    }
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollview];
	[UIView animateWithDuration:0.2 
                     animations:^{
                         if (type == AddMessageFromTopCoverView)
                             [self dismissModalViewControllerAnimated:YES];
                         else if (type == AddMessageFromTopView){
                             self.view.frame = CGRectMake(0, -540, 320, 460);
                         }
                         [Sound SendSound];
                     }
                     completion:^(BOOL finished)
     {if (finished){
        if (type == AddMessageFromTopView){
            UIViewController *tmp = [UIViewController new];
            tmp.view.userInteractionEnabled = NO;
            self.slidingViewController.topCoverViewController=tmp;
        }
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"发送微博" 
                            subtitle:@"微博已成功发送" 
                           hideAfter:3.0];
    }
     }];
}

-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
	if (sts.text != nil && [sts.text length] != 0) {
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

#pragma mark -
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = (id)self;
	HUD.labelText = @"导入照片...";
    [HUD show:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != NULL)
    {
        [self performSelector:@selector(addImage:) withObject:image afterDelay:0.5];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"StorePhoto"] intValue] == 1 && [info objectForKey:@"UIImagePickerControllerMediaMetadata"] != nil)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != nil){
        //If error
    }else{
        [MTInfoPanel showPanelInWindow:self.view.window type:MTInfoPanelTypeSuccess
                               title:@"保存图片"
                            subtitle:@"图片保存成功"
                           hideAfter:3.0];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!_location){
        showLocation = [UIButton new];
        showLocation.frame = CGRectMake(246, 381, 32, 32);
        [showLocation setBackgroundImage:[UIImage imageNamed:@"add_location"] forState:UIControlStateNormal];
        showLocation.alpha =0;
        [showLocation addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:showLocation];
        [UIView animateWithDuration:0.5 animations:^{
            location.frame = CGRectMake( 20, 355, 200, 85);}
                         completion:^(BOOL complete){
                             [UIView animateWithDuration:0.5 animations:^{showLocation.alpha =1;
                             }];
                         }];
        [location removeTarget:self action:@selector(setupLocationManager) forControlEvents:UIControlEventTouchUpInside];
        [location addTarget:self action:@selector(addAndDelLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.ISOcountryCode;
            //返回城市名
            NSString *city = placemark.locality;
            NSLog(@"%@ - %@", country, city);
        }
    }];
    _location = true;
    checkLocation = newLocation;
}

@end
