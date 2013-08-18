//
//  HtmlString.h
//  TEST_16
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHAttributedLabel.h"

@interface HtmlString : NSString

+ (NSString *)transformString:(NSString *)originalStr;
+ (void)setURLForLabel:(NSString *)atext label:(OHAttributedLabel *)label;

@end
