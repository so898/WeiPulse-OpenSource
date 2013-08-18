//
//  ImageProcess.m
//  WeiPulse
//
//  Created by so898 on 12-8-3.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "ImageProcess.h"

@implementation ImageProcess

+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    //CGRect rect_screen = [[UIScreen mainScreen] bounds];
    //CGSize size_screen = rect_screen.size;
    //CGFloat scale = [[UIScreen mainScreen] scale];
    //if (size_screen.width * scale == 640) {
    //    size = CGSizeMake(size.width * 2, size.height * 2);
    //}
    CGSize newSize;
    if (image.size.height / image.size.width > 1){
        newSize.height = size.width / image.size.width * image.size.height;
        newSize.width = size.width;
    } else if (image.size.height / image.size.width < 1){
        newSize.height = size.height;
        newSize.width = size.height / image.size.height * image.size.width;
    } else {
        newSize = size;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
