//
//  WeiBoMessageManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"

static WeiBoMessageManager * instance=nil;

@implementation WeiBoMessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[WeiBoHttpManager alloc] initWithDelegate:self];
    }
    return self;
}

+(WeiBoMessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[WeiBoMessageManager alloc] init];
        }
    }
    return instance;
}

- (BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_EXPIRATION_DATE];
    if (expirationDate == nil)  return YES;
    
    BOOL boolValue1 = !(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    BOOL boolValue2 = (expirationDate != nil);
    
    return (boolValue1 && boolValue2);
}

#pragma mark - Http Methods
//留给webview用
-(NSURL*)getOauthCodeUrl
{
    return [httpManager getOauthCodeUrl];
}

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page
{
    [httpManager getPublicTimelineWithCount:count withPage:page];
}

//获取登陆用户的UID
-(void)getUserID
{
    [httpManager getUserID];
}

//登出用户
-(void)signOut
{
    [httpManager signOut];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid
{
    [httpManager getUserInfoWithUserID:uid];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserName:(NSString *)name
{
    [httpManager getUserInfoWithUserName:name];
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID since:(long long)since_id
{
    [httpManager getCommentListWithID:weiboID since:since_id];
}

//根据微博消息ID返回某条微博消息的转发列表
-(void)getRepostListWithID:(long long)weiboID since:(long long)since_id
{
    [httpManager getRepostListWithID:weiboID since:since_id];
}

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort
{
    [httpManager getBilateralIdListAll:uid sort:sort];
}

-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    [httpManager getBilateralIdList:uid count:count page:page sort:sort];
}

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    [httpManager getBilateralIdList:uid count:count page:page sort:sort];
}

-(void)getBilateralUserListAll:(long long)uid sort:(int)sort
{
    [httpManager getBilateralUserListAll:uid sort:sort];
}

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    [httpManager getFollowingUserList:uid count:count cursor:cursor];
}

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    [httpManager getFollowedUserList:uid count:count cursor:cursor];
}

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid
{
    [httpManager followByUserID:uid];
}

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName
{
    [httpManager followByUserName:userName];
}

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid
{
    [httpManager unfollowByUserID:uid];
}

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName
{
    [httpManager unfollowByUserName:userName];
}

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName
{
    [httpManager getTrendStatues:trendName];
}

//关注某话题
-(void)followTrend:(NSString*)trendName
{
    [httpManager followTrend:trendName];
}

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID
{
    [httpManager unfollowTrend:trendID];
}

//获取热门话题
-(void)getHotTrend
{
    [httpManager getHotTrend];
}

//发布文字微博
-(void)postWithText:(NSString*)text
{
    [httpManager postWithText:text];
}

//发布文字位置微博
-(void)postWithText:(NSString*)text:(float)po_lat:(float)po_long
{
    [httpManager postWithText:text:po_lat:po_long];
}

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image
{
    [httpManager postWithText:text image:image];
}

//发布文字图片位置微博
-(void)postWithText:(NSString *)text image:(UIImage*)image :(float)po_lat:(float)po_long
{
    [httpManager postWithText:text image:image :po_lat :po_long];
}

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getHomeLine:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getUserStatusUserID:uid sinceID:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}

//转发一条微博
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment
{
    [httpManager repost:weiboID content:content withComment:isComment];
}

//评论一条微博
-(void)comment:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment
{
    [httpManager comment:weiboID content:content commentOri:isComment];
}

//回复一条评论
-(void)commentOnComment:(NSString *)commentID weiboID:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment
{
    [httpManager commentOnComment:commentID weiboID:weiboID content:content commentOri:isComment];
}

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count
{
    [httpManager getHotRepostDaily:count];
}

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count
{
    [httpManager getHotCommnetDaily:count];
}

//返回推荐的热门信息
-(void)getHot:(int)type is_pic:(BOOL)is
{
    [httpManager getHot:type is_pic:is];
}

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid
{
    [httpManager getUnreadCount:uid];
}

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count
{
    [httpManager getMetionsStatuses:sinceID maxID:maxID count:count];
}

//获取登录用户的评论
-(void)getCommentsStatuses:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count
{
    [httpManager getCommentsStatuses:sinceID maxID:maxID count:count];
}

//获取两个用户之间的关系
-(void)getFriendShips:(int64_t)source_id sourceName:(NSString*)source_name targetId:(int64_t)target_id targetName:(NSString *)targetName
{
    [httpManager getFriendShips:source_id sourceName:source_name targetId:target_id targetName:targetName];
}

//获取优质粉丝
-(void)getActiveFollower:(long long)uid count:(int)count
{
    [httpManager getActiveFollower:uid count:count];
}

//删除一条微博
-(void)deleteMessage:(int64_t)ID
{
    [httpManager deleteMessage:ID];
}

#pragma mark - WeiBoHttpDelegate
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPublicTimeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetPublicTimelineWithStatues:)]){
        [self.delegate performSelector:@selector(GetPublicTimelineWithStatues:) withObject:statusArr];
    }
}

//获取登陆用户的UID
-(void)didGetUserID:(NSString *)userID
{
    NSLog(@"userID = %@",userID);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserID object:userID];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetUserID:)]){
        [self.delegate performSelector:@selector(GetUserID:) withObject:userID];
    }
}

-(void)didSignOut:(User*)user
{
    NSLog(@"userInfo = %@",user.screenName);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaUserSignOut object:user];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(SignOut:)]){
        [self.delegate performSelector:@selector(SignOut:) withObject:user];
    }
}

//获取任意一个用户的信息
-(void)didGetUserInfo:(User *)user
{
    NSLog(@"userInfo = %@",user.screenName);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserInfo object:user];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetUserInfo:)]){
        [self.delegate performSelector:@selector(GetUserInfo:) withObject:user];
    }
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSDictionary *)commentInfo
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotCommentList object:commentInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetCommentList:)]){
        [self.delegate performSelector:@selector(GetCommentList:) withObject:commentInfo];
    }
}

//根据微博消息ID返回某条微博消息的转发列表
-(void)didGetRepostList:(NSDictionary *)Reposts
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotRepostList object:Reposts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetRepostList:)]){
        [self.delegate performSelector:@selector(GetRepostList:) withObject:Reposts];
    }
}

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray *)arr
{
    NSLog(@"BilateralIdList = %@",arr);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralIdList object:arr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetBilateralIdList:)]){
        [self.delegate performSelector:@selector(GetBilateralIdList:) withObject:arr];
    }
}

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray *)userArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetBilateralUserList:)]){
        [self.delegate performSelector:@selector(GetBilateralUserList:) withObject:userArr];
    }
}

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSDictionary *)userDic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowingUserList object:userDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetFollowingUsersList:)]){
        [self.delegate performSelector:@selector(GetFollowingUsersList:) withObject:userDic];
    }
}

//获取用户的粉丝列表
-(void)didGetFollowedUsersList:(NSDictionary *)userDic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowedUserList object:userDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetFollowedUsersList:)]){
        [self.delegate performSelector:@selector(GetFollowedUsersList:) withObject:userDic];
    }
}

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendStatues object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetTrendStatues:)]){
        [self.delegate performSelector:@selector(GetTrendStatues:) withObject:statusArr];
    }
}

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaFollowedByUserIDWithResult object:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(FollowByUserIDWithResult:)]){
        [self.delegate performSelector:@selector(FollowByUserIDWithResult:) withObject:resultDic ];
    }
}

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaUnfollowedByUserIDWithResult object:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(UnfollowByUserIDWithResult:)]){
        [self.delegate performSelector:@selector(UnfollowByUserIDWithResult:) withObject:resultDic ];
    }
}

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID
{
    NSLog(@"topicID = %lld",topicID);
    NSNumber *number = [NSNumber numberWithLongLong:topicID];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendIDAfterFollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetTrendIDAfterFollowed:)]){
        [self.delegate performSelector:@selector(GetTrendIDAfterFollowed:) withObject:[NSNumber numberWithInt:topicID] ];
    }
}

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue
{
    NSLog(isTrue == YES?@"true":@"false");
    NSNumber *number = [NSNumber numberWithBool:isTrue];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendResultAfterUnfollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetTrendIDAfterFollowed:)]){
        [self.delegate performSelector:@selector(GetTrendIDAfterFollowed:) withObject:[NSNumber numberWithBool:isTrue] ];
    }
}

- (void)didGetHotTrends:(NSArray *)trends
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotTrends object:trends];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetHotTrends:)]){
        [self.delegate performSelector:@selector(GetHotTrends:) withObject:trends ];
    }
}

//发布微博
-(void)didGetPostResult:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPostResult object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetPostResult:)]){
        [self.delegate performSelector:@selector(GetPostResult:) withObject:sts ];
    }
}

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray *)statusArr
{
    if (statusArr == nil || [statusArr count] == 0) {
        if ([self.delegate respondsToSelector:@selector(NoReturn)]){
            [self.delegate performSelector:@selector(NoReturn)];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(GetHomeLine:)]){
        [self.delegate performSelector:@selector(GetHomeLine:) withObject:statusArr ];
    }
}

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserStatus object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetUserStatus:)]){
        [self.delegate performSelector:@selector(GetUserStatus:) withObject:statusArr ];
    }
}

//转发一条微博
-(void)didRepost:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotRepost object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(Repost:)]){
        [self.delegate performSelector:@selector(Repost:) withObject:sts ];
    }
}

-(void)didComment:(Comment *)com
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotComment object:com];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(Comment:)]){
        [self.delegate performSelector:@selector(Comment:) withObject:com ];
    }
}

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotRepostDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetHotRepostDaily:)]){
        [self.delegate performSelector:@selector(GetHotRepostDaily:) withObject:statusArr ];
    }
}

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotCommentDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetHotCommentDaily:)]){
        [self.delegate performSelector:@selector(GetHotCommentDaily:) withObject:statusArr ];
    }
}

//获取推荐的热门信息
-(void)didGetHot:(NSArray*)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHot object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetHot:)]){
        [self.delegate performSelector:@selector(GetHot:) withObject:statusArr ];
    }
}

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary *)dic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUnreadCount object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetUnreadCount:)]){
        [self.delegate performSelector:@selector(GetUnreadCount:) withObject:dic ];
    }
}

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)didGetMetionsStatused:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotMetionsStatuses object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetMetionsStatused:)]){
        [self.delegate performSelector:@selector(GetMetionsStatused:) withObject:statusArr ];
    }
}

//获取登录用户的评论
-(void)didGetCommentsStatused:(NSArray *)commentArray
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotCommentsStatuses object:commentArray];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetCommentsStatused:)]){
        [self.delegate performSelector:@selector(GetCommentsStatused:) withObject:commentArray ];
    }
}

//获取两个用户之间的关系
-(void)didGetFriendShips:(NSDictionary*)result
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFriendShips object:result];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetFriendShips:)]){
        [self.delegate performSelector:@selector(GetFriendShips:) withObject:result ];
    }
}

//获取优质粉丝
- (void)didGetActiveFollower:(NSArray *)userArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotActiveUser object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(GetActiveFollower:)]){
        [self.delegate performSelector:@selector(GetActiveFollower:) withObject:userArr ];
    }
}

//删除一条微博
-(void)didDelete:(Status*)sts
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaDeleteMessage object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(Delete:)]){
        [self.delegate performSelector:@selector(Delete:) withObject:sts ];
    }
}

-(void)requestFailed:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(RequestFailed:)]){
        [self.delegate performSelector:@selector(RequestFailed:) withObject:[error localizedDescription]];
    }
}

-(void)NeedRelogin
{
    if ([self.delegate respondsToSelector:@selector(NeedRelogin)]){
        [self.delegate performSelector:@selector(NeedRelogin)];
    }
}

@end
