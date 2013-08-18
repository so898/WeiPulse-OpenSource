//
//  CommentCell.m
//  WeiPulse
//
//  Created by Bill Cheng on 12-7-25.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "CommentCell.h"
#import "MessageCellBackgView.h"
#import "HtmlString.h"
#import "RegexKitLite.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        MessageCellBackgView *bgView = [[MessageCellBackgView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
        
        name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:14.0f];
        name.frame = CGRectMake(10, 2, 260, 20);
        [self.contentView addSubview:name];
        
        button = [UIButton new];
        button.frame = CGRectMake(274, 9, 32, 32);
        [button addTarget:self action:@selector(Go) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        text = [OHAttributedLabel new];
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
        
        time = [UILabel new];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:9.0f];
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
        if ([self.delegate respondsToSelector:@selector(openComment:)])
            [self.delegate performSelector:@selector(openComment:) withObject:com];
    } else if (com == nil){
        if ([self.delegate respondsToSelector:@selector(openStatus:)])
            [self.delegate performSelector:@selector(openStatus:) withObject:sts];
    }
}

- (void) setStatus:(Status *)s
{
    sts = s;
}

- (void) setComment:(Comment *)c
{
    com = c;
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

- (void)setName:(NSString *)aname
{
    [name setText:aname];
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
    text.frame = CGRectMake(10, 25, 260, 10);
    CGRect labelRect = text.frame;
    labelRect.size.width = [text sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].width;
    labelRect.size.height = [text sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].height;
    text.frame = labelRect;
    if (text.frame.size.height >20)
        height += text.frame.size.height;
    else
        height += 20;
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
    time.frame = CGRectMake(200, height, 140, 20);
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
        //NSLog(@"%@", str);
        
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
