//
//  AtTypeViewCell.m
//  WeiPulse
//
//  Created by so898 on 12-8-8.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AtTypeViewCell.h"
#import "ImageProcess.h"
#import "ASIHTTPRequest.h"

@implementation AtTypeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame = CGRectMake(0, 0, 320, 54);
        
        backg1 = [UIView new];
        backg1.frame = CGRectMake(0, 0, 160, 54);
        backg1.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
        [backg1.layer setBorderWidth:1.0f];
        [backg1.layer setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.5].CGColor];
        [self.contentView addSubview:backg1];
        
        UITapGestureRecognizer *singleTapGestureRecognizer1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnOne)];
        singleTapGestureRecognizer1.numberOfTapsRequired = 1;
        backg1.userInteractionEnabled = YES;
        [backg1 addGestureRecognizer:singleTapGestureRecognizer1];
        
        backg2 = [UIView new];
        backg2.frame = CGRectMake(160, 0, 160, 54);
        backg2.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
        [backg2.layer setBorderWidth:1.0f];
        [backg2.layer setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.5].CGColor];
        [self.contentView addSubview:backg2];
        
        UITapGestureRecognizer *singleTapGestureRecognizer2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTwo)];
        singleTapGestureRecognizer2.numberOfTapsRequired = 1;
        backg2.userInteractionEnabled = YES;
        [backg2 addGestureRecognizer:singleTapGestureRecognizer2];
        
        avast1 = [UIImageView new];
        avast1.frame = CGRectMake(5, 5, 44, 44);
        avast1.alpha = 0;
        [backg1 addSubview:avast1];
        
        avast2 = [UIImageView new];
        avast2.frame = CGRectMake(5, 5, 44, 44);
        avast2.alpha = 0;
        [backg2 addSubview:avast2];
        
        name1 = [UILabel new];
        name1.backgroundColor = [UIColor clearColor];
        name1.textColor = [UIColor whiteColor];
        name1.font = [UIFont systemFontOfSize:14];
        name1.numberOfLines = 0;
        name1.lineBreakMode = UILineBreakModeWordWrap;
        name1.frame = CGRectMake(55, 5, 100, 44);
        [backg1 addSubview:name1];
        
        name2 = [UILabel new];
        name2.backgroundColor = [UIColor clearColor];
        name2.textColor = [UIColor whiteColor];
        name2.font = [UIFont systemFontOfSize:14];
        name2.numberOfLines = 0;
        name2.lineBreakMode = UILineBreakModeWordWrap;
        name2.frame = CGRectMake(55, 5, 100, 44);
        [backg2 addSubview:name2];
        
    }
    return self;
}

- (void)returnOne
{
    if ([self.delegate respondsToSelector:@selector(returnUser:)]){
        [self.delegate performSelector:@selector(returnUser:) withObject:user1];
    }
}

- (void)returnTwo
{
    if ([self.delegate respondsToSelector:@selector(returnUser:)]){
        [self.delegate performSelector:@selector(returnUser:) withObject:user2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    if (selected)
        [UIView animateWithDuration:0.2 animations:^{self.backgroundColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];} completion:^(BOOL complete){self.backgroundColor = [UIColor whiteColor];}];
    // Configure the view for the selected state
}

- (void)setUser:(User *)u1 another:(User *)u2
{
    user1 = u1;
    user2 = u2;
    [name1 setText:u1.screenName];
    [name2 setText:u2.screenName];
    [self setAvast1:u1.profileLargeImageUrl];
    [self setAvast2:u2.profileLargeImageUrl];
    
}

- (void)setAvast1:(NSString *)aurl
{
    //NSLog(@"%@",[[NSString alloc] initWithFormat:@"%@,%@", name.text, @"_avast.jpg "]);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", name1.text, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast1.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast1.bounds.size];
        avast1.alpha = 1.0f;
    }
    else {
        NSURL *url = [NSURL URLWithString:aurl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast1.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast1.bounds.size];
            [UIView animateWithDuration:0.3 animations:^{avast1.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}

- (void)setAvast2:(NSString *)aurl
{
    //NSLog(@"%@",[[NSString alloc] initWithFormat:@"%@,%@", name.text, @"_avast.jpg "]);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", name2.text, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast2.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast2.bounds.size];
        avast2.alpha = 1.0f;
    }
    else {
        NSURL *url = [NSURL URLWithString:aurl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast2.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast2.bounds.size];
            [UIView animateWithDuration:0.3 animations:^{avast2.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}


@end
