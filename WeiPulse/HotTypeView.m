//
//  HotTypeView.m
//  WeiPulse
//
//  Created by so898 on 12-8-9.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "HotTypeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HotTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 216);
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add_message_backg"]];
        notice = [UILabel new];
        [self addSubview:notice];
        table = [UITableView new];
        table.frame = CGRectMake(0, 0, 320, 216);
        table.delegate = self;
        table.dataSource = self;
        table.scrollsToTop = YES;
        table.separatorStyle = NO;
        table.backgroundColor = [UIColor clearColor];
        [self addSubview:table];
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (void)loadView
{
    trends = [NSMutableArray new];
    [defaultNotifCenter addObserver:self selector:@selector(gotHotTrends:)       name:MMSinaGotHotTrends  object:nil];
    manager = [WeiBoMessageManager getInstance];
    [manager getHotTrend];
    notice.text = @"载入中...";
    notice.frame = CGRectMake(0, 20, 320, 30);
    notice.textAlignment = UITextAlignmentCenter;
    notice.textColor = [UIColor grayColor];
    notice.backgroundColor = [UIColor clearColor];
    notice.shadowColor = [UIColor whiteColor];
    notice.shadowOffset = CGSizeMake(0, -1.0f);
}

- (void)deleteListeners
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotHotTrends         object:nil];
}

- (void)gotHotTrends:(NSNotification *)sender
{
    
    [self deleteListeners];
    trends = sender.object;
    if (trends.count != 0)
        notice.alpha = 0;
    else
        [notice setText:@"您的此列表为空"];
    [table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity;
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    NSDictionary *dic = [trends objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.contentView.layer setBorderWidth:1.0f];
    [cell.contentView.layer setBorderColor:[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:0.5].CGColor];
    cell.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [trends objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(returnHotTrend:)]){
        [self.delegate performSelector:@selector(returnHotTrend:) withObject:[dic objectForKey:@"query"]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
