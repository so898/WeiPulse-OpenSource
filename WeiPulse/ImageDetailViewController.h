//
//  ImageDetailViewController.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-12.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SCGIFImageView.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"

typedef enum {
    ImageFromTopView,
    ImageFromTopCoverView,
} ImageDetailViewType;

@interface ImageDetailViewController : UIViewController<UIScrollViewDelegate,ASIProgressDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>{
    UIImageView *imageView;
    UIScrollView *scrollView;
    UIImage *image;
    MBProgressHUD *HUD;
    ASIHTTPRequest *request;
    UIButton *saveImage;
    SCGIFImageView* gifImageView;
    ImageDetailViewType type;
}

- (void)setImage:(UIImage *)aimage;
- (void)setImageUrl:(NSString *)imageurl type:(ImageDetailViewType)t;
@end
