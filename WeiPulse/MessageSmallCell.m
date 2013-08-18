//
//  MessageSmallCell.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageSmallCell.h"
#import "MessageCellBackgView.h"
#import "ASIHTTPRequest.h"
#import "HtmlString.h"
#import "RegexKitLite.h"

@implementation MessageSmallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        pic = false;
        
        time = [UILabel new];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:9.0f];
        time.textColor = [UIColor grayColor];
        time.frame = CGRectMake(200, 2, 120, 20);
        [self.contentView addSubview:time];
        
        location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_pin_stroke"]];
        location.frame = CGRectMake(185, 5, 10, 16);
        
        image = [UIImageView new];
        image.frame = CGRectMake(245, 30, 55, 55);
        image.contentMode = UIViewContentModeScaleAspectFill;
        [image setClipsToBounds:YES];
        image.alpha = 0.0f;
        image.backgroundColor = [UIColor blackColor];
        
        oimage = [UIImageView new];
        oimage.contentMode = UIViewContentModeScaleAspectFill;
        [oimage setClipsToBounds:YES];
        oimage.alpha = 0.0f;
        oimage.backgroundColor = [UIColor blackColor];
        
        text = [OHAttributedLabel new];
        text.font = [UIFont systemFontOfSize:12.0f];
        text.backgroundColor = [UIColor clearColor];
        text.userInteractionEnabled = YES;
        text.delegate = self;
        text.automaticallyAddLinksForType = 0;
        text.underlineLinks = NO;
        [self.contentView addSubview:text];
        
        via = [UILabel new];
        via.backgroundColor = [UIColor clearColor];
        via.font = [UIFont systemFontOfSize:9.0f];
        via.textColor = [UIColor grayColor];
        [self.contentView addSubview:via];
        
        repost = [UILabel new];
        repost.font = [UIFont systemFontOfSize:9.0f];
        repost.textColor = [UIColor grayColor];
        repost.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:repost];
        
        reply = [UILabel new];
        reply.font = [UIFont systemFontOfSize:9.0f];
        reply.textColor = [UIColor grayColor];
        reply.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:reply];
        
        oback = [UIView new];
        oback.alpha = 1.0;
        oback.backgroundColor = [UIColor clearColor];
        [[oback layer] setBorderWidth:2];
        [[oback layer] setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.7].CGColor];
        oback.layer.cornerRadius = 2.0f;
        oback.layer.masksToBounds = YES;
        [self.contentView addSubview:oback];
        
        otext = [OHAttributedLabel new];
        otext.backgroundColor = [UIColor clearColor];
        otext.delegate = self;
        otext.userInteractionEnabled = YES;
        otext.automaticallyAddLinksForType = 0;
        otext.underlineLinks = NO;
        [self.contentView addSubview:otext];
        height = 115.0f;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setStatus:(Status*)s
{
    sts = s;
    if (sts.retweetedStatus){
        [self setTweetText:sts.text];
        Status *rests = sts.retweetedStatus;
        [self setOriginPic:rests.thumbnailPic :rests.originalPic];
        [self setOriginPost:rests.user.screenName :rests.text];
    } else {
        [self setPic:sts.thumbnailPic:sts.originalPic];
        [self setTweetText:sts.text];
    }
    [self setReply:sts.commentsCount];
    [self setRepost:sts.retweetsCount];
    [self setSource:sts.source];
    [self setTime:sts.createdAt];
    if (sts.latitude != 0 && sts.longitude != 0){
        [self setLocationSign];
    }
}

- (float)returnHeight
{
    return height;
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

- (void)setPic:(NSString *)aurl:(NSString *)burl
{
    if (aurl.length == 0)
        return;
    else {
        [self.contentView addSubview:image];
        bigImageUrl = burl;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            image.image = [[UIImage alloc] initWithContentsOfFile: path];
            image.alpha = 1.0f;
        }
        else {
            NSURL *url = [NSURL URLWithString:aurl];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                image.image = [[UIImage alloc] initWithContentsOfFile: path];
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
        text.frame = CGRectMake(10, 20, 235, 60);
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(235, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(235, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        if (text.frame.size.height >60){
            height = 45 + text.frame.size.height;
        }
    }
    else {
        text.frame = CGRectMake(10, 20, 290, 65);
        height = 90;
        CGRect labelRect = text.frame;
        labelRect.size.width = [text sizeThatFits:CGSizeMake(290, CGFLOAT_MAX)].width;
        labelRect.size.height = [text sizeThatFits:CGSizeMake(290, CGFLOAT_MAX)].height;
        text.frame = labelRect;
        height = 45 + text.frame.size.height;
    }
}

- (void)setOriginPic:(NSString *)aurl:(NSString *)burl
{
    if (aurl.length == 0)
        return;
    else {
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
            oimage.image = [[UIImage alloc] initWithContentsOfFile: path];
            oimage.alpha = 1.0f;
        }
        else {
            NSURL *url = [NSURL URLWithString:aurl];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDownloadDestinationPath:path];
            [request setCompletionBlock:^(void){
                oimage.image = [[UIImage alloc] initWithContentsOfFile: path];
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
    NSString *rtext = [[NSString alloc] initWithFormat:@"@%@:%@",aname,atext];
    NSString *transformStr = [HtmlString transformString:rtext];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [otext setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:otext];
    if (opic){
        otext.frame = CGRectMake(13, height - 16, 230, 60);
        oback.frame = CGRectMake(12, height - 20, 293, 68);
        if (atext.length >50){
            CGRect labelRect = otext.frame;
            labelRect.size.width = [otext sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].width;
            labelRect.size.height = [otext sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].height;
            otext.frame = labelRect;
            oback.frame = CGRectMake(12, height - 20, 293, otext.frame.size.height + 6);
            height = height + otext.frame.size.height + 6;
        }else {
            height = height + 68;
        }
    }
    else {
        otext.frame = CGRectMake(13, height - 16, 288, 60);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(288, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(288, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        oback.frame = CGRectMake(12, height - 20, 293, otext.frame.size.height + 6);
        height = height + otext.frame.size.height + 6;
    }
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
    [via setText:[[NSString alloc] initWithFormat:@"来自%@", s]];
    via.frame = CGRectMake(10, height - 20, reply.frame.origin.x - 55, 20);
}

- (void) setTime:(time_t)atime
{
    NSString *str = @"%Y年%m月%d日 %H:%M:%S";
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
    [self.contentView addSubview:location];
}

-(void)openUrlLink:(NSURL*)linkUrl
{
    NSString *requestString = [linkUrl  absoluteString];
    NSLog(@"%@",requestString);
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
