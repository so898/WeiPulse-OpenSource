//
//  HtmlString.m
//  TEST_16
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  Amended by Bill Cheng on 17/08/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "HtmlString.h"
#import <Foundation/NSObjCRuntime.h>
#import "RegexKitLite.h"

@implementation HtmlString

+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;

    
    //解析表情
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShowFace"] intValue] == 1){
        NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情的正则表达式
        NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
        
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
        NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        //NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
        
        if ([array_emoji count]) {
            for (NSString *str in array_emoji) {
                NSRange range = [text rangeOfString:str];
                NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
                if (i_transCharacter) {
                    NSString *imageHtml = [NSString stringWithFormat:@"<img src=\"%@\">",  i_transCharacter];
                    text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
                }
            }
        }
    }
    
    
        
    //返回转义后的字符串
    return text;
}

+ (void)setURLForLabel:(NSString *)atext label:(OHAttributedLabel *)label
{
    //解析http://短链接
    NSString *regex_http = @"[http]+://[a-zA-Z].[a-zA-Z]*/[a-zA-Z0-9]*";//http://短链接正则表达式
    NSArray *array_http = [atext componentsMatchedByRegex:regex_http];
    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            [label addCustomLink:[NSURL URLWithString:str] inRange:[atext rangeOfString:str]];
        }
    }
    
    //解析@
    NSString *regex_at = @"@[\\u4e00-\\u9fa5\\w\\-]+";//@的正则表达式
    
    NSArray *array_at = [atext componentsMatchedByRegex:regex_at];
    
    if ([array_at count]) {
        NSRange rangeToSearchWithin = NSMakeRange(0, atext.length);
        for (NSString *str in array_at) {
            NSRange range = [atext rangeOfString:str options:NSLiteralSearch range:rangeToSearchWithin];
            [label addCustomLink:[NSURL URLWithString:[[NSString stringWithFormat:@"&cmd1&%@",str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] inRange:range];
            int newLocationToStartAt = range.location + range.length;
            rangeToSearchWithin = NSMakeRange(newLocationToStartAt, atext.length - newLocationToStartAt);
        }
    }
    
    //解析话题
    /*NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [atext componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
     NSRange rangeToSearchWithin = NSMakeRange(0, atext.length);
        for (NSString *str in array_pound) {
            NSRange range = [atext rangeOfString:str options:NSLiteralSearch range:rangeToSearchWithin];
            [label addCustomLink:[NSURL URLWithString:[[NSString stringWithFormat:@"&cmd2&%@",str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] inRange:range];
            int newLocationToStartAt = range.location + range.length;
            rangeToSearchWithin = NSMakeRange(newLocationToStartAt, atext.length - newLocationToStartAt);
        }
    }*/
}


@end
