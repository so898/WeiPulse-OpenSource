//
//  AtUserView.m
//  WeiPulse
//
//  Created by so898 on 12-8-5.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "AtUserView.h"

@implementation AtUserView

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
    users = [NSMutableArray new];
    [defaultNotifCenter addObserver:self selector:@selector(gotActiveUser:)       name:MMSinaGotActiveUser  object:nil];
    manager = [WeiBoMessageManager getInstance];
    [manager getActiveFollower:[[[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID] longLongValue] count:50];
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
    [defaultNotifCenter removeObserver:self name:MMSinaGotActiveUser         object:nil];
}

- (void)gotActiveUser:(NSNotification *)sender
{
    
    [self deleteListeners];
    users = sender.object;
    if (users.count != 0)
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
    return users.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity;
    AtTypeViewCell *cell = (AtTypeViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil){
        cell = [[AtTypeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    User *one = [users objectAtIndex:(indexPath.row * 2)];
    User *two = [users objectAtIndex:(indexPath.row * 2 +1)];
    [cell setUser:one another:two];
    cell.delegate = self;
    return cell;
}

- (void)returnUser:(User *)u
{
    if ([self.delegate respondsToSelector:@selector(returnUserName:)]){
        [self.delegate performSelector:@selector(returnUserName:) withObject:u.screenName];
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
