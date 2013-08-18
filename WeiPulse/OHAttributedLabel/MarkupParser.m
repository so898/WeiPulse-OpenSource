//
//  MarkupParser.m
//  CoreTextDemo
//
//  Created by 海军 高 on 11-12-23.
//  Copyright (c) 2011年 北京微云即趣. All rights reserved.
//

#import "MarkupParser.h"

#define kHTML @"These are <font color=\"red\">red<font color=\"black\"> and\
<font color=\"blue\">blue <font color=\"black\">words."

@implementation MarkupParser
@synthesize font, color, strokeColor, strokeWidth;
@synthesize images;

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.font = @"Helvetica-Bold";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray arrayWithCapacity:100];
    }
    
    return self;
}

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return 16;
}
static CGFloat descentCallback( void *ref ){
    return 4;
}
static CGFloat widthCallback( void* ref ){
    return 20;
}

-(NSMutableAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    //NSLog(@"markup %@",markup);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:markup options:0
                                       range:NSMakeRange(0, [markup length])];
    [regex release];
    
    for (NSTextCheckingResult* b in chunks)
    {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        //NSLog(@"11111");
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 20.0f, NULL);
        
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)fontRef, kCTFontAttributeName,
                               nil];

        [string appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        
        __block NSString* fileName = @"";
        
        if ([parts count]>1) 
        {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            
            if ([tag hasPrefix:@"img"])
            {
                //image
                NSRegularExpression* srcRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL] autorelease];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                    //NSLog(@"fileName %@",fileName);
                    
                    //add the image for drawing
                    [self.images addObject:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      fileName, @"fileName",
                      [NSNumber numberWithInt: [string length]], @"location",
                      nil]
                     ];
                    
                    //render empty space for drawing the image in the text //1
                    CTRunDelegateCallbacks callbacks;
                    callbacks.version = kCTRunDelegateVersion1;
                    callbacks.getAscent = ascentCallback;
                    callbacks.getDescent = descentCallback;
                    callbacks.getWidth = widthCallback;
                    callbacks.dealloc = deallocCallback;
                    
                    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, NULL); //3
                    NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            //set the delegate
                                                            (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                            [UIColor clearColor].CGColor,(NSString*)kCTForegroundColorAttributeName,
                                                            nil];
                    
                    //add a space to the text so that it can call the delegate
                    [string appendAttributedString:[[[NSAttributedString alloc] initWithString:@"." attributes:attrDictionaryDelegate] autorelease]];
                }];
                

            }
        }
        
    }
    //NSLog(@"string %@",string.string);
    return (NSMutableAttributedString*)string;
}


-(void)dealloc
{
    //[font release];
    self.font = nil;
    //[color release];
    self.color = nil;
    //[strokeColor release];
    self.strokeColor = nil;
    //[images release];
    self.images = nil;
    
    [super dealloc];
}

@end
