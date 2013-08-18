//
//  AddMessageViewController.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-27.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "AddMessage.h"

typedef enum {
    All,          //全部
    Original,     //原创
    Image,        //图片
    Music,        //音乐
    Video,        //视频
}AddMessageViewType;

@protocol AddMessageViewDelegate;
@interface AddMessageViewController : UIViewController{
    UIButton *addMessage, *all, *original, *image, *video, *music;
    UIView *border, *backg;
    AddMessageViewType type;
}

@property(nonatomic,assign) id <AddMessageViewDelegate> delegate;

- (void)setType:(AddMessageViewType)t;

@end

@protocol AddMessageViewDelegate <NSObject>
- (void)changeTypeFromRight:(AddMessageType)t;
@end
