//
//  WeiBoMessageManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import <Foundation/Foundation.h>
#import "WeiBoHttpManager.h"

//获取最新的公共微博
//返回成员为Status的NSArray
#define MMSinaGotPublicTimeLine @"MMSinaGotPublicTimeLine"

//获取登陆用户的UID
//返回userID(NSString)
#define MMSinaGotUserID @"MMSinaGotUserID"

//获取任意一个用户的信息
//返回一个User对象
#define MMSinaUserSignOut @"MMSinaUserSignOut"

//获取任意一个用户的信息
//返回一个User对象
#define MMSinaGotUserInfo @"MMSinaGotUserInfo"

//根据微博消息ID返回某条微博消息的评论列表
//返回成员为comment的NSArray.
#define MMSinaGotCommentList @"MMSinaGotCommentList"

//根据微博消息ID返回某条微博消息的转发列表
//返回成员为status的NSArray.
#define MMSinaGotRepostList @"MMSinaGotRepostList"

//获取用户双向关注的用户ID列表，即互粉UID列表
//返回成员为UID(NSNumber)的NSArray。
#define MMSinaGotBilateralIdList @"MMSinaGotBilateralIdList"

//获取用户的双向关注user列表，即互粉列表
//返回成员为User的NSArray。
#define MMSinaGotBilateralUserList @"MMSinaGotBilateralUserList"

//获取用户的关注列表
//返回成员为User的NSArray。
#define MMSinaGotFollowingUserList @"MMSinaGotFollowingUserList"

//获取用户的粉丝列表
//返回成员为User的NSArray。
#define MMSinaGotFollowedUserList @"MMSinaGotFollowedUserList"

//获取某话题下的微博消息
//返回成员为Status的NSArray
#define MMSinaGotTrendStatues @"MMSinaGotTrendStatues"

//关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaFollowedByUserIDWithResult @"MMSinaFollowedByUserIDWithResult"

//取消关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaUnfollowedByUserIDWithResult @"UnfollowedByUserIDWithResult"

//关注某话题
//返回long long(NSNumber)类型的 topic ID
#define MMSinaGotTrendIDAfterFollowed @"MMSinaGotTrendIDAfterFollowed"

//取消对某话题的关注
//返回一个BOOL(NSNumber)值
#define MMSinaGotTrendResultAfterUnfollowed @"MMSinaGotTrendResultAfterUnfollowed"

//发布微博
//返回一个Status对象
#define MMSinaGotPostResult @"MMSinaGotPostResult"

//获取当前登录用户及其所关注用户的最新微博
//返回成员为Status的NSArray
#define MMSinaGotHomeLine @"MMSinaGotHomeLine"

//没有获取到新的微博或者信息
//返回成员为空
#define MMSinaGotNothing @"MMSinaGotNothing"

//获取某个用户最新发表的微博列表
//返回成员为Status的NSArray
#define MMSinaGotUserStatus @"MMSinaGotUserStatus"

//转发一条微博
//返回一个Status对象
#define MMSinaGotRepost @"MMSinaGotRepost"

//评论一条微博
#define MMSinaGotComment @"MMSinaGotComment"

//按天返回热门微博转发榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotRepostDaily @"MMSinaGotHotRepostDaily"

//按天返回热门微博评论榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotCommentDaily @"MMSinaGotHotCommentDaily"

//获取推荐的热门内容
#define MMSinaGotHot @"MMSinaGotHot"

//获取某个用户的各种消息未读数
#define MMSinaGotUnreadCount @"MMSinaGotUnreadCount"

//获取最新的提到登录用户的微博列表，即@我的微博
#define MMSinaGotMetionsStatuses @"MMSinaGotMetionsStatuses"

//获取登录用户的评论
#define MMSinaGotCommentsStatuses @"MMSinaGotCommentsStatuses"

//获取两个用户之间的关系
#define MMSinaGotFriendShips @"MMSinaGotFriendShips"

//删除某条消息
#define MMSinaDeleteMessage @"MMSinaDeleteMessage"

//获取优质用户
#define MMSinaGotActiveUser @"MMSinaGotActiveUser"

//获取热门话题
#define MMSinaGotHotTrends @"MMSinaGotHotTrends"

@protocol WeiBoManagerDelegate;
@interface WeiBoMessageManager : NSObject <WeiBoHttpDelegate>
{
    WeiBoHttpManager *httpManager;
}
@property (nonatomic, copy)WeiBoHttpManager *httpManager;

+(WeiBoMessageManager*)getInstance;

@property (nonatomic ,assign)id <WeiBoManagerDelegate> delegate;

//查看Token是否过期
- (BOOL)isNeedToRefreshTheToken;

//留给webview用
-(NSURL*)getOauthCodeUrl;

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page;

//获取登陆用户的UID
-(void)getUserID;

//登出用户
-(void)signOut;

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid;

//获取任意一个用户的信息
-(void)getUserInfoWithUserName:(NSString *)name;

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID since:(long long)since_id;

//根据微博消息ID返回某条微博消息的转发列表
-(void)getRepostListWithID:(long long)weiboID since:(long long)since_id;

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort;
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort;

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort;
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort;

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid;

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName;

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid;

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName;

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName;

//关注某话题
-(void)followTrend:(NSString*)trendName;

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID;

//获取热门话题
-(void)getHotTrend;

//发布文字微博
-(void)postWithText:(NSString*)text;

//发布文字位置微博
-(void)postWithText:(NSString*)text:(float)po_lat:(float)po_long;

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image;

//发布文字图片位置微博
-(void)postWithText:(NSString *)text image:(UIImage*)image :(float)po_lat:(float)po_long;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//转发一条微博
//isComment(int):是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment;

//评论一条微博
-(void)comment:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment;

//回复一条评论
-(void)commentOnComment:(NSString *)commentID weiboID:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment;

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count;

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count;

//返回推荐的热门信息
-(void)getHot:(int)type is_pic:(BOOL)is;

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid;

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count;

//获取登录用户的评论
-(void)getCommentsStatuses:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count;

//获取两个用户之间的关系
-(void)getFriendShips:(int64_t)source_id sourceName:(NSString*)source_name targetId:(int64_t)target_id targetName:(NSString *)targetName;

//获取优质粉丝
-(void)getActiveFollower:(long long)uid count:(int)count;

//删除一条微博
-(void)deleteMessage:(int64_t)ID;

@end

@protocol WeiBoManagerDelegate <NSObject>

@optional
- (void) GetPublicTimelineWithStatues:(NSArray *)statusArr;
- (void) GetUserID:(NSString *)userID;
- (void) SignOut:(User*)user;
- (void) GetUserInfo:(User *)user;
- (void) GetCommentList:(NSDictionary *)commentInfo;
- (void) GetRepostList:(NSDictionary *)Reposts;
- (void) GetBilateralIdList:(NSArray *)arr;
- (void) GetBilateralUserList:(NSArray *)userArr;
- (void) GetFollowingUsersList:(NSDictionary *)userDic;
- (void) GetFollowedUsersList:(NSDictionary *)userDic;
- (void) GetTrendStatues:(NSArray *)statusArr;
- (void) FollowByUserIDWithResult:(NSDictionary *)resultDic;
- (void) UnfollowByUserIDWithResult:(NSDictionary *)resultDic;
- (void) GetTrendIDAfterFollowed:(NSNumber*)topicID;
- (void) GetTrendResultAfterUnfollowed:(NSNumber*)isTrue;
- (void) GetHotTrends:(NSArray *)trends;
- (void) GetPostResult:(Status *)sts;
- (void) GetHomeLine:(NSArray *)statusArr;
- (void) NoReturn;
- (void) GetUserStatus:(NSArray*)statusArr;
- (void) Repost:(Status *)sts;
- (void) Comment:(Comment *)com;
- (void) GetHotRepostDaily:(NSArray *)statusArr;
- (void) GetHotCommentDaily:(NSArray *)statusArr;
- (void) GetHot:(NSArray*)statusArr;
- (void) GetUnreadCount:(NSDictionary *)dic;
- (void) GetMetionsStatused:(NSArray *)statusArr;
- (void) GetCommentsStatused:(NSArray *)commentArray;
- (void) GetFriendShips:(NSDictionary*)result;
- (void) GetActiveFollower:(NSArray *)userArr;
- (void) Delete:(Status*)sts;
- (void) RequestFailed:(NSString *)error;
- (void) NeedRelogin;

@end
