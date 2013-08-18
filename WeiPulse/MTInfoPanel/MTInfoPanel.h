//
//  MTInfoPanel.h
//  MTInfoPanel
//
//  Created by Tretter Matthias on 14.12.11.
//  Copyright (c) @myell0w. All rights reserved.
//
//  Based on MTInfoPanel by Mugunth on 25/04/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8e on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {    
    MTInfoPanelTypeInfo,        // blue
    MTInfoPanelTypeNotice,      // gray
    MTInfoPanelTypeSuccess,     // green
    MTInfoPanelTypeWarning,     // yellow
    MTInfoPanelTypeError        // red
} MTInfoPanelType;

@interface MTInfoPanel : UIView

@property (nonatomic, assign) SEL onTouched;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, assign) SEL onFinished;

+ (MTInfoPanel *)showPanelInView:(UIView *)view
                            type:(MTInfoPanelType)type 
                           title:(NSString *)title 
                        subtitle:(NSString *)subtitle;

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                            type:(MTInfoPanelType)type 
                           title:(NSString *)title 
                        subtitle:(NSString *)subtitle
                       hideAfter:(NSTimeInterval)interval;

+ (MTInfoPanel *)showPanelInView:(UIView *)view
                            type:(MTInfoPanelType)type 
                           title:(NSString *)title 
                        subtitle:(NSString *)subtitle
                           image:(UIImage *)image;

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                            type:(MTInfoPanelType)type
                           title:(NSString *)title 
                        subtitle:(NSString *)subtitle
                           image:(UIImage *)image 
                       hideAfter:(NSTimeInterval)interval;

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle 
                           image:(UIImage *)image
                      startColor:(UIColor *)startColor
                        endColor:(UIColor *)endColor
                      titleColor:(UIColor *)titleColor
                 detailTextColor:(UIColor *)detailColor
                       titleFont:(UIFont *)titleFont
                  detailTextFont:(UIFont *)detailFont
                       hideAfter:(NSTimeInterval)interval;

+ (MTInfoPanel *)showPanelInWindow:(UIWindow *)window 
                              type:(MTInfoPanelType)type
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle;

+ (MTInfoPanel *)showPanelInWindow:(UIWindow *)window 
                              type:(MTInfoPanelType)type
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle
                         hideAfter:(NSTimeInterval)interval;

+ (MTInfoPanel *)showPanelInWindow:(UIWindow *)window
                              type:(MTInfoPanelType)type
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle 
                             image:(UIImage *)image;

+ (MTInfoPanel *)showPanelInWindow:(UIWindow *)window 
                              type:(MTInfoPanelType)type 
                             title:(NSString *)title 
                          subtitle:(NSString *)subtitle
                             image:(UIImage *)image
                         hideAfter:(NSTimeInterval)interval;


- (void)hidePanel;

@end
