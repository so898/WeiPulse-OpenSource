//
//  RefreshSpin.m
//  Refresh
//
//  Created by tianran DING on 12-3-5.
//  Copyright (c) 2012年 dingtr. All rights reserved.
//

#import "RefreshSpin.h"
#define DegreesToRadians(degrees) degrees * M_PI / 180
#define RadiansToDegrees(radians) radians * 180/M_PI

@implementation RefreshSpin
@dynamic progress;
@synthesize spinImage = _spinImage;
@synthesize containnerImage = _containnerImage;
@synthesize infinite = _infinite;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.containnerImage = [UIImage imageNamed:@"spin_bg.png"];
        self.spinImage = [UIImage imageNamed:@"spin_up.png"];
        
        _progress = 0.0;
        infiniteTimer = nil;
        self.infinite = NO;
        
    }
    return self;
}

- (void) dealloc {
    [infiniteTimer invalidate];
    infiniteTimer = nil;
    
}

- (void) startInfiniteAnimation {
    if ([infiniteTimer isValid]) {
        return;
    }
    self.infinite = YES;
    //schedule the timer in common mode will not get the animation blocked while scrolling.
    infiniteTimer = [NSTimer timerWithTimeInterval:0.04 target:self selector:@selector(infiniteTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:infiniteTimer forMode:NSRunLoopCommonModes];
    
}

- (void) stopInfiniteAnimation {
    if ([infiniteTimer isValid]) {
        [infiniteTimer invalidate];
        infiniteTimer = nil;
    }
    self.infinite = NO;
    
}

- (void) infiniteTimer:(NSTimer*)timer {
    _progress = _progress + 1.0;
    [self setNeedsDisplay];
    
}

UIImage *rotateImageByDegrees(UIImage *image, CGFloat degrees)
{
    // Create the bitmap context
    UIImage* self = image;
    CGSize size = CGSizeMake(self.size.width *self.scale, self.size.height *self.scale);
    UIGraphicsBeginImageContext(size);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, size.width/2, size.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

UIImage *rotateImageByRadians(UIImage *image, CGFloat radians)
{
    return rotateImageByDegrees(image, RadiansToDegrees(radians));
}

- (void) setProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
    
}

- (float) progress {
    return _progress;
}


-(void)addArcToContext:(CGContextRef)context angle:(CGFloat)angle {
    CGContextMoveToPoint(context, 16, 0);
    CGContextAddLineToPoint(context, 16, 16);
    CGFloat x = 16 * sinf((4.0 * M_PI + angle) / 5.0) + 16;
    CGFloat y = 16 * cosf((4.0 * M_PI + angle) / 5.0) + 16;
    CGContextAddLineToPoint(context, x, y);
    CGContextClosePath(context);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = CGSizeMake(32, 32);
    rect = CGRectMake(rect.origin.x+5, rect.origin.y+5, size.width, size.height);
    
    [self.containnerImage drawInRect:self.bounds];
    
    float finalProgress = (float)((int)_progress % 100);
    if (self.infinite == NO) {
        UIGraphicsBeginImageContext(size);
        CGContextRef maskContext = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(maskContext, CGRectGetWidth(rect) / 2.0f, CGRectGetHeight(rect) / 2.0f);
        CGContextAddArc(maskContext, CGRectGetWidth(rect) / 2.0f, CGRectGetHeight(rect) / 2.0f, CGRectGetWidth(rect) / 2.0f, (0.0f * M_PI / 180.0f) + (90 * M_PI / 180.0f),  ((360 * ((100 - finalProgress) / 100.0f)) * M_PI / 180.0f) + (90 * M_PI / 180.0f), 1) ;
        CGContextClosePath(maskContext);
        CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
        CGContextFillPath(maskContext);
        CGContextDrawPath(maskContext, kCGPathFillStroke);
        
        UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGContextClipToMask(context, rect, mask.CGImage);
    }
    
    [rotateImageByRadians(self.spinImage, ((finalProgress/100.0) *360) *(M_PI/180)) drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
}


@end
