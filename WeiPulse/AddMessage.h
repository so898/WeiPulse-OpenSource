//
//  AddMessage.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-6.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"
#import "ECSlidingViewController.h"
#import "Draft.h"
#import "WeiBoMessageManager.h"
#import "MBProgressHUD.h"
#import "AtUserView.h"
#import "HotTypeView.h"

typedef enum {
    AddMessageFromTopView,
    AddMessageFromTopCoverView,
}AddMessageType;

@interface AddMessage : UIViewController <EGORefreshTableHeaderDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, AtUserViewDelegate, HotTypeViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    //Draft *draft;
    UIScrollView *scrollview;
    UITextView *input;
    UIButton *closetype, *exit, *photo, *location, *showPhotoBack, *showLocation;
    UIView *mainView, *inputAccView, *buttonBackg;
    UILabel *dragText, *num, *num_s;
    UIImageView *dragIcon, *dragBackg, *showPhoto;
    CLLocationManager *locationManager;
    CLLocation *checkLocation;
    UIImage *_images;
    WeiBoMessageManager *manager;
    MBProgressHUD *HUD;
    BOOL _reloading, _allowed, _image, _location, atType, hotType;
    AddMessageType type;
}

- (void) setUser:(NSString *)name type:(AddMessageType)t;

@end
