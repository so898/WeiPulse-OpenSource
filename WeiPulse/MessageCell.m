//
//  MessageCell.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-7.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageCell.h"
#import "MessageCellBackgView.h"
#import "ASIHTTPRequest.h"
#import "HtmlString.h"
#import "RegexKitLite.h"
#import "ImageProcess.h"

@implementation MessageCell
                                                                                       
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.contentView.frame = CGRectMake(0, 0, 310, 120);
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        
        avast = [UIImageView new];
        avast.frame = CGRectMake(5, 10, 50, 50);
        avast.backgroundColor = [UIColor blackColor];
        avast.layer.cornerRadius = 5.0f;
        avast.layer.masksToBounds = YES;
        
        [self.contentView addSubview:avast];
        
        name = [UILabel new];
        name.frame = CGRectMake(60, 0, 150, 30);
        name.font = [UIFont boldSystemFontOfSize:15.0f];
        name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:name];
        
        oname = [UILabel new];
        oname.font = [UIFont systemFontOfSize:15.0f];
        oname.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:oname];
        
        time = [UILabel new];
        time.font = [UIFont systemFontOfSize:9.0f];
        time.frame = CGRectMake(230, 2, 100, 20);
        time.textColor = [UIColor grayColor];
        time.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:time];
        
        text = [OHAttributedLabel new];
        text.backgroundColor = [UIColor clearColor];
        text.opaque = NO;
        text.delegate = self;
        text.userInteractionEnabled = YES;
        text.automaticallyAddLinksForType = 0;
        text.underlineLinks = NO;
        [self.contentView addSubview:text];
        
        image = [UIImageView new];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [image setClipsToBounds:YES];
        image.backgroundColor = [UIColor blackColor];
        
        
        oback = [UIView new];
        oback.alpha = 1.0;
        oback.backgroundColor = [UIColor clearColor];
        [[oback layer] setBorderWidth:2];
        [[oback layer] setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.7].CGColor];
        oback.layer.cornerRadius = 2.0f;
        oback.layer.masksToBounds = YES;
        
        
        oimage = [UIImageView new];
        oimage.contentMode = UIViewContentModeScaleAspectFill;
        [oimage setClipsToBounds:YES];
        oimage.backgroundColor = [UIColor blackColor];
        
        
        otext = [OHAttributedLabel new];
        otext.backgroundColor = [UIColor clearColor];
        otext.opaque = NO;
        otext.delegate = self;
        otext.userInteractionEnabled = YES;
        otext.automaticallyAddLinksForType = 0;
        otext.underlineLinks = NO;
        
        
        source = [UILabel new];
        source.font = [UIFont systemFontOfSize:10.0f];
        source.textColor = [UIColor grayColor];
        source.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:source];
        
        repost = [UILabel new];
        repost.font = [UIFont systemFontOfSize:10.0f];
        //repost.frame = CGRectMake(210, 95, 45, 20);
        repost.textColor = [UIColor grayColor];
        repost.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:repost];
        
        reply = [UILabel new];
        reply.font = [UIFont systemFontOfSize:10.0f];
        //reply.frame = CGRectMake(260, 95, 45, 20);
        reply.textColor = [UIColor grayColor];
        reply.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:reply];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (float)returnHeight
{
    return height;
}

- (void)setStatus:(Status *)s
{
    sts = s;
    pic = false;
    opic = false;
    height = 115.0f;
    image.alpha = 0.0f;
    oimage.alpha = 0.0f;
    avast.alpha = 0.0f;
    [image removeFromSuperview];
    [oimage removeFromSuperview];
    [otext removeFromSuperview];
    [oback removeFromSuperview];
    [v removeFromSuperview];
    [location removeFromSuperview];
    [self setName];
    [self setVerify:sts.user.verified type:sts.user.verifiedType];
    if (sts.retweetedStatus){
        [self setTweetText:sts.text];
        Status *rests = sts.retweetedStatus;
        [self setOriginPic:rests.thumbnailPic :rests.originalPic];
        [self setOriginPost:rests.user.screenName :rests.text];
    } else {
        [self setPic:sts.thumbnailPic:sts.originalPic];
        [self setTweetText:sts.text];
    }
    [self setAvast:sts.user.profileLargeImageUrl];
    [self setReply:sts.commentsCount];
    [self setRepost:sts.retweetsCount];
    [self setSource:sts.source];
    [self setTime:sts.createdAt];
    if (sts.latitude != 0 && sts.longitude != 0){
        [self setLocationSign];
    } else {
        [location removeFromSuperview];
    }
}

- (void)setName
{
    NSString *tmp = [NSString new];
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] intValue]) {
        case 0:
            tmp = sts.user.screenName;
            break;
        case 1:
            if (sts.user.remark != nil && sts.user.remark.length != 0)
                tmp = sts.user.remark;
            else
                tmp = sts.user.screenName;
            break;
        case 2:
            if (sts.user.remark != nil && sts.user.remark.length != 0)
                tmp = [NSString stringWithFormat:@"%@(%@)",sts.user.screenName, sts.user.remark];
            else
                tmp = sts.user.screenName;
            break;
        case 3:
            if (sts.user.remark != nil && sts.user.remark.length != 0)
                tmp = [NSString stringWithFormat:@"%@(%@)", sts.user.remark, sts.user.screenName];
            else
                tmp = sts.user.screenName;
            break;
        default:
            tmp = sts.user.screenName;
            break;
    }
    [name setText:tmp];
}

- (void)setVerify:(BOOL)is type:(int)t
{
    if (is){
        v = [UIImageView new];
        v.frame = CGRectMake(43, 48, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        [self.contentView addSubview:v];
        if (t != 0)
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
    } else if (t == 220){
        v = [UIImageView new];
        v.frame = CGRectMake(43, 48, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        [self.contentView addSubview:v];
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
    }
}

- (void)setPic:(NSString *)aurl:(NSString *)burl
{
    if (aurl.length == 0)
        return;
    else {
        [self.contentView addSubview:image];
        image.frame = CGRectMake(245, 30, 55, 55);
        bigImageUrl = burl;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            image.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:image.bounds.size];
            [UIView animateWithDuration:0.05 animations:^{image.alpha = 1.0f;}];
        }
        else {
            NSURL *url = [NSURL URLWithString:aurl];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                image.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:image.bounds.size];
                [UIView animateWithDuration:0.3 animations:^{image.alpha = 1.0f;}];
            }];
            [request startAsynchronous];
        }
        pic = true;
        UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowImage)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:singleTapGestureRecognizer];
        return;
    }
}

- (void)ShowImage
{
    if ([self.delegate respondsToSelector:@selector(openImage:)]){
        [self.delegate performSelector:@selector(openImage:) withObject:bigImageUrl];
    }
}

- (void)ShowPeople
{
    if ([self.delegate respondsToSelector:@selector(openAvast:)]){
        [self.delegate performSelector:@selector(openAvast:) withObject:sts.user];
    }
}

- (int)getFontSize
{
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Font"] intValue]) {
        case 0:
            return 12;
            break;
        case 1:
            return 14;
            break;
        case 2:
            return 16;
            break;
        case 3:
            return 18;
            break;
        default:
            break;
    }
    return 15;
}

- (void)setTweetText:(NSString *)atext
{
    NSString *transformStr = [HtmlString transformString:atext];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [text setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:text];
    if (pic){
        text.frame = CGRectMake(60, 30, 175, 60);
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(175, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(175, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        if (text.frame.size.height >60){
            height = 55 + text.frame.size.height;
        }
    }
    else {
        text.frame = CGRectMake(60, 30, 242, 65);
        height = 90;
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(242, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(242, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        if (text.frame.size.height >35){
            height = 55 + text.frame.size.height;
        }
    }
}

- (void)setOriginPic:(NSString *)aurl:(NSString *)burl
{
    if (aurl.length == 0)
        return;
    else {
        [self.contentView addSubview:oback];
        [self.contentView addSubview:oimage];
        oimage.frame = CGRectMake(244, height - 13, 55, 55);
        //height = height + 60;
        bigImageUrl = burl;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            oimage.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:oimage.bounds.size];
            [UIView animateWithDuration:0.05 animations:^{oimage.alpha = 1.0f;}];
        }
        else {
            NSURL *url = [NSURL URLWithString:aurl];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                oimage.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:oimage.bounds.size];
                [UIView animateWithDuration:0.3 animations:^{oimage.alpha = 1.0f;}];
            }];
            [request startAsynchronous];
        }
        opic = true;
        UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowImage)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        oimage.userInteractionEnabled = YES;
        [oimage addGestureRecognizer:singleTapGestureRecognizer];
        return;
    }
}

- (void) setOriginPost:(NSString *)aname :(NSString *)atext
{
    if (!opic)
        [self.contentView addSubview:oback];
    [self.contentView addSubview:otext];
    NSString *rtext = [[NSString alloc] initWithFormat:@"@%@:%@",aname,atext];
    NSString *transformStr = [HtmlString transformString:rtext];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [otext setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:otext];
    if (opic){
        otext.frame = CGRectMake(63, height - 16, 178, 60);
        oback.frame = CGRectMake(57, height - 20, 248, 68);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(178, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(178, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        if (otext.frame.size.height >62){
            oback.frame = CGRectMake(57, height - 20, 248, otext.frame.size.height + 6);
            height = height + otext.frame.size.height + 6 + 5;
        }else {
            height = height + 68 + 5;
        }
    }
    else {
        otext.frame = CGRectMake(63, height - 16, 236, 60);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(236, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(236, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        //otext.frame = CGRectMake(63, height - 16, 233, h);
        oback.frame = CGRectMake(57, height - 20, 248, otext.frame.size.height + 6);
        height = height + otext.frame.size.height + 6 + 5;
    }
    
    //NSLog(@"%d",atext.length);
    
}

- (void)setAvast:(NSString *)aurl
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@_avast_%@", name.text, [tmp_array objectAtIndex:([tmp_array count]-1)]]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        avast.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:avast.bounds.size];
        [UIView animateWithDuration:0.05 animations:^{avast.alpha = 1.0f;}];
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
    UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowPeople)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    avast.userInteractionEnabled = YES;
    [avast addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) setReply:(int)num
{
    [reply setText:[[NSString alloc] initWithFormat:@"回复: %d",num]];
    NSString *tmp = [[NSString alloc] initWithFormat:@"%d",num];
    int tmp_num = tmp.length;
    if (tmp.length > 3){
        tmp_num -= 3;
        reply.frame = CGRectMake(260 - tmp_num *5, height - 20, 45 + tmp_num *5, 20);
        return;
    }
    reply.frame = CGRectMake(260 , height - 20, 45 , 20);
}

- (void) setRepost:(int)num
{
    [repost setText:[[NSString alloc] initWithFormat:@"转发: %d",num]];
    NSString *tmp = [[NSString alloc] initWithFormat:@"%d",num];
    int tmp_num = tmp.length;
    if (tmp.length > 3){
        tmp_num -= 3;
        repost.frame = CGRectMake(reply.frame.origin.x - 50 - tmp_num *5, height - 20, 45 + tmp_num *5, 20);
        return;
    }
    repost.frame = CGRectMake(reply.frame.origin.x - 50 , height - 20, 45 , 20);
}

- (void)setSource:(NSString *)s
{
    [source setText:[[NSString alloc] initWithFormat:@"来自%@", s]];
    source.frame = CGRectMake(10, height - 20, reply.frame.origin.x - 55, 20);
}

- (void) setTime:(time_t)atime
{
    NSString *str = @"%m月%d日 %H:%M:%S";
    NSString *stime = [self dateInFormat:atime format:str];
    [time setText:stime];
}

- (NSString *)dateInFormat:(time_t)dateTime format:(NSString*) stringFormat
{
    char buffer[80];
    const char *format = [stringFormat UTF8String];
    struct tm *timeinfo;
    timeinfo = localtime(&dateTime);
    strftime(buffer, 80, format, timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (void) setLocationSign
{
    location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_pin_stroke"]];
    location.frame = CGRectMake(215, 5, 10, 16);
    [self.contentView addSubview:location];
}

-(void)openUrlLink:(NSURL*)linkUrl
{
    NSString *requestString = [linkUrl  absoluteString];
    NSArray *urlComps = [requestString componentsSeparatedByString:@"&"];
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd1"])//@方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *tmp_array = [str componentsSeparatedByString:@"@"];
        if ([self.delegate respondsToSelector:@selector(openUserDetail:)]){
            [self.delegate performSelector:@selector(openUserDetail:) withObject:[[NSString alloc] initWithFormat:@"%@", [tmp_array objectAtIndex:1]]];
        }
        return ;
    }
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd2"])//话题方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return ;
    }
    
    //以下是使用safri打开链接
    if ( ( [ [ linkUrl scheme ] isEqualToString: @"http" ] || [ [ linkUrl scheme ] isEqualToString: @"https" ] || [ [ linkUrl scheme ] isEqualToString: @"mailto" ])) {
        if ([self.delegate respondsToSelector:@selector(openTheURL:)]){
            [self.delegate performSelector:@selector(openTheURL:) withObject:[[NSString alloc] initWithFormat:@"%@", linkUrl]];
        }
        return;
    }
    return;
}

@end
