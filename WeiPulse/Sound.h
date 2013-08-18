//
//  Sound.h
//  WeiPulse
//
//  Created by so898 on 12-8-21.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sound : NSObject

+ (void) RefreshSound;
+ (void) SendSound;
+ (void) NoticeSound;
+ (void) ClickSound;

@end
