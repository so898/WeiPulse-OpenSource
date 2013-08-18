//
//  MessageViewCell.m
//  WeiPulse
//
//  Created by so898 on 12-8-1.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageViewCell.h"
#import "MessageCellBackgView.h"
#import "ASIHTTPRequest.h"
#import "HtmlString.h"
#import "RegexKitLite.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "ImageProcess.h"

@implementation MessageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        
        avast = [UIImageView new];
        avast.frame = CGRectMake(5, 10, 50, 50);
        avast.backgroundColor = [UIColor blackColor];
        avast.layer.cornerRadius = 5.0f;
        avast.layer.masksToBounds = YES;
        avast.alpha = 0.0f;
        [self.contentView addSubview:avast];
        
        v = [UIImageView new];
        v.frame = CGRectMake(43, 48, 17, 17);
        v.backgroundColor = [UIColor clearColor];
        v.image = [UIImage imageNamed:@"avatar_vip"];
        v.alpha = 0.0f;
        [self.contentView addSubview:v];
        
        name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:14.0f];
        name.frame = CGRectMake(65, 2, 250, 20);
        [self.contentView addSubview:name];
        
        button = [UIButton new];
        button.frame = CGRectMake(274, 22, 32, 32);
        [button addTarget:self action:@selector(Go) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        text = [OHAttributedLabel new];
        text.backgroundColor = [UIColor clearColor];
        text.opaque = NO;
        text.delegate = self;
        text.userInteractionEnabled = YES;
        text.automaticallyAddLinksForType = 0;
        text.underlineLinks = NO;
        [self.contentView addSubview:text];
        
        oback = [UIView new];
        oback.alpha = 1.0;
        oback.backgroundColor = [UIColor clearColor];
        oback.layer.cornerRadius = 2.0f;
        oback.layer.masksToBounds = YES;
        [[oback layer] setBorderWidth:2];
        [[oback layer] setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.7].CGColor];
        [self.contentView addSubview:oback];
        
        via = [UILabel new];
        via.backgroundColor = [UIColor clearColor];
        via.font = [UIFont systemFontOfSize:10.0f];
        via.textColor = [UIColor grayColor];
        [self.contentView addSubview:via];
        
        time = [UILabel new];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:10.0f];
        time.textColor = [UIColor grayColor];
        [self.contentView addSubview:time];
        
        height = 25;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)Go
{
    if (sts == nil){
        if ([self.delegate respondsToSelector:@selector(replyComment:)])
            [self.delegate performSelector:@selector(replyComment:) withObject:com];
    } else if (com == nil){
        if ([self.delegate respondsToSelector:@selector(repostStatus:)])
            [self.delegate performSelector:@selector(repostStatus:) withObject:sts];
    }
}

- (float)returnHeight
{
    return height;
}

- (void) setStatus:(Status *)s
{
    sts = s;
    [self setName:sts.user.screenName other:sts.user.remark];
    [self setVerify:sts.user.verified type:sts.user.verifiedType];
    [self setAvast:sts.user.profileLargeImageUrl];
    [self setPost:sts.text];
    if (sts.retweetedStatus){
        [self setOriginPic:sts.retweetedStatus.thumbnailPic :sts.retweetedStatus.originalPic];
        [self setOriginPost:sts.retweetedStatus.user.screenName :sts.retweetedStatus.text];
    }
    [self setVia:sts.source];
    [self setTime:sts.createdAt];
    [self setType:2];
}

- (void) setComment:(Comment *)c
{
    com = c;
    [self setName:com.user.screenName other:sts.user.remark];
    [self setVerify:com.user.verified type:com.user.verifiedType];
    [self setAvast:com.user.profileLargeImageUrl];
    [self setPost:com.text];
    [self setVia:com.source];
    [self setTime:com.createdAt];
    [self setType:1];
}

- (void)ShowImage
{
    if ([self.delegate respondsToSelector:@selector(openImage:)]){
        [self.delegate performSelector:@selector(openImage:) withObject:sts.retweetedStatus.originalPic];
    }
}

- (void)ShowPeople
{
    if ([self.delegate respondsToSelector:@selector(openAvast:)]){
        if (com != nil)
            [self.delegate performSelector:@selector(openAvast:) withObject:com.user];
        else if (sts != nil)
            [self.delegate performSelector:@selector(openAvast:) withObject:sts.user];
    }
}

- (void)setVerify:(BOOL)is type:(int)t
{
    if (is){
        if (t == 0)
            v.alpha = 1;
        else {
            v.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            v.alpha = 1;
        }
    } else if (t == 220){
        v.image = [UIImage imageNamed:@"avatar_grassroot"];
        v.alpha = 1;
    }
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
    UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowPeople)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    avast.userInteractionEnabled = YES;
    [avast addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)setName:(NSString *)aname other:(NSString *)bname
{
    NSString *tmp = [NSString new];
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] intValue]) {
        case 0:
            tmp = aname;
            break;
        case 1:
            if (bname != nil && bname.length != 0)
                tmp = bname;
            else
                tmp = aname;
            break;
        case 2:
            if (bname != nil && bname.length != 0)
                tmp = [NSString stringWithFormat:@"%@(%@)",aname, bname];
            else
                tmp = aname;
            break;
        case 3:
            if (bname != nil && bname.length != 0)
                tmp = [NSString stringWithFormat:@"%@(%@)", bname, aname];
            else
                tmp = aname;
            break;
        default:
            tmp = aname;
            break;
    }
    [name setText:tmp];
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

- (void)setPost:(NSString *)atext
{
    NSString *transformStr = [HtmlString transformString:atext];
    MarkupParser* p = [MarkupParser new];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: transformStr];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:[self getFontSize]]];
    [text setAttString:attString withImages:p.images];
    [HtmlString setURLForLabel:attString.string label:text];
    text.frame = CGRectMake(65, 25, 205, 10);
    CGRect labelRect = text.frame;
    labelRect.size.width = [text sizeThatFits:CGSizeMake(205, CGFLOAT_MAX)].width;
    labelRect.size.height = [text sizeThatFits:CGSizeMake(205, CGFLOAT_MAX)].height;
    text.frame = labelRect;
    if (text.frame.size.height >35){
        height = 30 + text.frame.size.height;
    } else
        height += 45;
}

- (void)setOriginPic:(NSString *)aurl :(NSString *)burl
{
    if (aurl.length == 0)
        return;
    else {
        oimage = [UIImageView new];
        oimage.contentMode = UIViewContentModeScaleAspectFill;
        [oimage setClipsToBounds:YES];
        oimage.alpha = 0.0f;
        oimage.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:oimage];
        oimage.frame = CGRectMake(244, height + 4, 55, 55);
        //height = height + 60;
        bigImageUrl = burl;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *tmp_array = [aurl componentsSeparatedByString:@"/"];
        NSString *temp_name = [NSString stringWithFormat:@"%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
        path = [path stringByAppendingPathComponent:temp_name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            oimage.image = [ImageProcess OriginImage:[[UIImage alloc] initWithContentsOfFile: path] scaleToSize:oimage.bounds.size];
            oimage.alpha = 1.0f;
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
    otext = [OHAttributedLabel new];
    otext.backgroundColor = [UIColor clearColor];
    otext.opaque = NO;
    otext.delegate = self;
    otext.userInteractionEnabled = YES;
    otext.automaticallyAddLinksForType = 0;
    otext.underlineLinks = NO;
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
        otext.frame = CGRectMake(68, height + 4, 173, 60);
        oback.frame = CGRectMake(62, height , 243, 68);
        if (atext.length >50){
            CGRect labelRect = otext.frame;
            labelRect.size.width = [otext sizeThatFits:CGSizeMake(173, CGFLOAT_MAX)].width;
            labelRect.size.height = [otext sizeThatFits:CGSizeMake(173, CGFLOAT_MAX)].height;
            otext.frame = labelRect;
            oback.frame = CGRectMake(62, height , 243, otext.frame.size.height + 6);
            height = height + otext.frame.size.height + 6 + 5;
        }else {
            height = height + 68 + 5;
        }
    }
    else {
        otext.frame = CGRectMake(68, height + 4, 233, 60);
        CGRect labelRect = otext.frame;
        labelRect.size.width = [otext sizeThatFits:CGSizeMake(233, CGFLOAT_MAX)].width;
        labelRect.size.height = [otext sizeThatFits:CGSizeMake(233, CGFLOAT_MAX)].height;
        otext.frame = labelRect;
        //otext.frame = CGRectMake(63, height - 16, 233, h);
        oback.frame = CGRectMake(62, height, 243, otext.frame.size.height + 6);
        height = height + otext.frame.size.height + 6 + 5;
    }
    
    //NSLog(@"%d",atext.length);
    
}

- (void)setVia:(NSString *)source
{
    NSString *viaSource = [[NSString alloc] initWithFormat:@"来自%@",source];
    [via setText:viaSource];
    via.frame = CGRectMake(10, height, 120, 20);
}

- (void)setTime:(time_t)date
{
    NSString *str = @"%Y年%m月%d日 %H:%M:%S";
    NSString *stime = [self dateInFormat:date format:str];
    [time setText:stime];
    time.frame = CGRectMake(190, height, 140, 20);
    height += 20;
}

- (void)setType:(int)i
{
    if (i == 1){
        [button setBackgroundImage:[UIImage imageNamed:@"detail_reply"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_reply_hl"] forState:UIControlStateHighlighted];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"detail_retweet"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_retweet_hl"] forState:UIControlStateHighlighted];
    }
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
