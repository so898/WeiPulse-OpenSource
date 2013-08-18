//
//  MarkupParser.h
//  CoreTextDemo
//
//  Created by 海军 高 on 11-12-23.
//  Copyright (c) 2011年 北京微云即趣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface MarkupParser : NSObject
{
    NSString *font;
    UIColor *color;
    UIColor *strokeColor;
    float stokeWidth;
    
    NSMutableArray *images;
}

@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (retain, nonatomic) NSMutableArray* images;

-(NSMutableAttributedString*)attrStringFromMarkup:(NSString*)html;

@end
