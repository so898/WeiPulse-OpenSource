//
//  Sound.m
//  WeiPulse
//
//  Created by so898 on 12-8-21.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "Sound.h"

@implementation Sound

+ (void) RefreshSound
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NoticeSound"] intValue] == 0)
        return;
    NSURL *URLRef = [[NSBundle mainBundle] URLForResource:@"refresh"
                                                withExtension:@"aif"];
    SystemSoundID soundSSID = 0;
    
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(URLRef),&soundSSID);
    AudioServicesPlaySystemSound(soundSSID);
}

+ (void) SendSound
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NoticeSound"] intValue] == 0)
        return;
    NSURL *URLRef = [[NSBundle mainBundle] URLForResource:@"send"
                                            withExtension:@"aif"];
    SystemSoundID soundSSID = 0;
    
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(URLRef),&soundSSID);
    AudioServicesPlaySystemSound(soundSSID);
}

+ (void) NoticeSound
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NoticeSound"] intValue] == 0)
        return;
    NSURL *URLRef = [[NSBundle mainBundle] URLForResource:@"notice"
                                            withExtension:@"aif"];
    SystemSoundID soundSSID = 0;
    
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(URLRef),&soundSSID);
    AudioServicesPlaySystemSound(soundSSID);
    //AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

+ (void) ClickSound
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NoticeSound"] intValue] == 0)
        return;
    NSURL *URLRef = [[NSBundle mainBundle] URLForResource:@"click"
                                            withExtension:@"aif"];
    SystemSoundID soundSSID = 0;
    
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(URLRef),&soundSSID);
    AudioServicesPlaySystemSound(soundSSID);
}

@end
