//
//  FansUserCell.m
//  WeiPulse
//
//  Created by so898 on 12-7-31.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "FansUserCell.h"
#import "MessageCellBackgView.h"
#import "ASIHTTPRequest.h"
#import "ImageProcess.h"

@implementation FansUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        two = NO;
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        
        avastBackg = [UIView new];
        avastBackg.backgroundColor = [UIColor blackColor];
        avastBackg.frame = CGRectMake(8, 8, 54, 54);
        
        avast = [UIImageView new];
        avast.frame = CGRectMake(2, 2, 50, 50);
        [self.contentView addSubview:avastBackg];
        
        
        v = [UIImageView new];
        v.frame = CGRectMake(48, 48, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        v.alpha = 0.0f;
        
        name = [UILabel new];
        name.frame = CGRectMake(67, 0, 235, 25);
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:name];
        
        sex = [UILabel new];
        sex.frame = CGRectMake(67, 26, 60, 20);
        sex.backgroundColor = [UIColor clearColor];
        sex.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:sex];
        
        location = [UILabel new];
        location.frame = CGRectMake(127, 26, 115, 20);
        location.backgroundColor = [UIColor clearColor];
        location.font = [UIFont systemFontOfSize:13];
        [location setTextColor:[UIColor brownColor]];
        [self.contentView addSubview:location];
        
        followBy = [UILabel new];
        followBy.frame = CGRectMake(67, 47, 180, 20);
        followBy.backgroundColor = [UIColor clearColor];
        followBy.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:followBy];
        
        fan = [UIButton new];
        fan.frame = CGRectMake(247, 35, 55, 30);
        fan.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_green"]];
        fan.layer.cornerRadius = 6;
        fan.layer.masksToBounds = YES;
        [self.contentView addSubview:fan];
        
        notice = [UILabel new];
        notice.frame = CGRectMake(5, 0, 45, 30);
        notice.backgroundColor = [UIColor clearColor];
        notice.font = [UIFont systemFontOfSize:10];
        notice.textAlignment = UITextAlignmentCenter;
        
        
    }
    [avast removeFromSuperview];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setType
{
    two = YES;
}

- (void)setUser:(User *)u
{
    user = u;
    avast.alpha = 0;
    [name setText:user.screenName];
    if (user.verified){
        [self.contentView addSubview:v];
        if (user.verifiedType == 0)
            v.alpha = 1;
        else {
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            v.alpha = 1;
        }
    } else if (user.verifiedType == 220){
        [self.contentView addSubview:v];
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
        v.alpha = 1;
    } else {
        [v removeFromSuperview];
    }
    [self setAvast:user.profileLargeImageUrl];
    [location setText:user.location];
    [followBy setText:[[NSString alloc] initWithFormat:@"粉丝数：%d", user.followersCount]];
    if (user.gender == GenderMale){
        [sex setText:@"男"];
        [sex setTextColor:[UIColor blueColor]];
    }
    else if (user.gender == GenderFemale){
        [sex setText:@"女"];
        [sex setTextColor:[UIColor redColor]];
    }
    else if (user.gender == GenderUnknow)
        [sex setText:@"未知"];
    if (!two){
        if (user.following){
            [fan addSubview:notice];
            notice.text = @"取消关注";
            notice.textColor = [UIColor redColor];
            [fan addTarget:self action:@selector(cancelFollow) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [fan addSubview:notice];
            notice.text = @"加关注";
            notice.textColor = [UIColor blueColor];
            [fan addTarget:self action:@selector(addFollow) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        [fan removeFromSuperview];
    }
}

- (void)cancelFollow
{
    if ([self.delegate respondsToSelector:@selector(removeUserFromFollow:)]) {
        [self.delegate removeUserFromFollow:user];
    }
}

- (void)addFollow
{
    if ([self.delegate respondsToSelector:@selector(addUserToFollow:)]) {
        [self.delegate addUserToFollow:user];
    }
}

- (void)setAvast:(NSString *)aurl
{
    [avastBackg addSubview:avast];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", name.text, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast.bounds.size];
        avast.alpha = 1.0f;
    }
    else {
        NSURL *url = [NSURL URLWithString:aurl];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            avast.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast.bounds.size];
            [UIView animateWithDuration:0.3 animations:^{avast.alpha = 1.0f;}];
        }];
        [request startAsynchronous];
    }
}

@end
