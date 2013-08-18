//
//  WeiBoHttpManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//
//  Amended by Bill Cheng on 07/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.

#import "WeiBoHttpManager.h"
#import "Status.h"
#import "Comment.h"

@implementation WeiBoHttpManager
@synthesize delegate;
@synthesize authCode;
@synthesize authToken;
@synthesize userId;

#pragma mark - Init


//初始化
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        self.delegate = theDelegate;
    }
    return self;
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			//NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
			//																			  NULL, /* allocator */
			//																			  (__bridge_retained CFStringRef)value,
			//																			  NULL, /* charactersToLeaveUnescaped */
			//																			  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
			//																			  kCFStringEncodingUTF8);

            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

//提取用户ID
- (NSString *) extractUsernameFromHTTPBody: (NSString *) body {
	if (!body) {
        return nil;
    }
	
	NSArray	*tuples = [body componentsSeparatedByString: @"&"];
	if (tuples.count < 1) {
        return nil;
    }
	
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		
		if (keyValueArray.count == 2) {
			NSString    *key = [keyValueArray objectAtIndex: 0];
			NSString    *value = [keyValueArray objectAtIndex: 1];
			
			if ([key isEqualToString:@"screen_name"]) return value;
			if ([key isEqualToString:@"user_id"]) return value;
		}
	}
	return nil;
}

#pragma mark - Http Operate
//获取auth_code or access_token
-(NSURL*)getOauthCodeUrl //留给webview用
{
    //https://api.weibo.com/oauth2/authorize
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   SINA_APP_KEY,                    @"client_id",       //申请的appkey
								   @"token",                        @"response_type",   //access_token
								   REDIRECT_URL,                    @"redirect_uri",    //申请时的重定向地址
								   @"mobile",                       @"display",         //web页面的显示方式
                                   nil];
	
	NSURL *url = [self generateURL:SINA_API_AUTHORIZE params:params];
	NSLog(@"url= %@",url);
    return url;
}

-(void)getPublicTimelineWithCount:(int)count withPage:(int)page
{
    //https://api.weibo.com/2/statuses/public_timeline.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSString                *pageString = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       countString, @"count",
                                       pageString,  @"page",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/public_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetPublicTimeline];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取登陆用户的UID
-(void)getUserID
{
    //https://api.weibo.com/2/account/get_uid.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    client.parameterEncoding = AFJSONParameterEncoding;
    [client getPath:@"account/get_uid.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetUserID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取热门话题
-(void)getHotTrend
{
    //https://api.weibo.com/2/trends/daily.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"trends/daily.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetHotTrend];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取登陆用户的UID
-(void)signOut
{
    //https://api.weibo.com/2/account/end_session.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"account/end_session.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaSignOut];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid
{
    //https://api.weibo.com/2/users/show.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetUserInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserName:(NSString *)name
{
    //https://api.weibo.com/2/users/show.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       name,     @"screen_name",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetUserInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID since:(long long)since_id
{
    //https://api.weibo.com/2/comments/show.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                       @"access_token",
                                       [NSString stringWithFormat:@"%lld",weiboID],     @"id",
                                       nil];
    if (since_id >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",since_id];
        [params setObject:tempString forKey:@"max_id"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"comments/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetComment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//根据微博消息ID返回某条微博消息的转发列表
-(void)getRepostListWithID:(long long)weiboID since:(long long)since_id
{
    //https://api.weibo.com/2/statuses/repost_timeline.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                       @"access_token",
                                       [NSString stringWithFormat:@"%lld",weiboID],     @"id",
                                       nil];
    if (since_id >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",since_id];
        [params setObject:tempString forKey:@"max_id"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/repost_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetRepost];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",page],      @"page",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/friends/bilateral/ids.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetBilateralIdList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户双向关注的用户ID列表，即互粉UID列表 不分页
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/friends/bilateral/ids.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetBilateralIdListAll];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",page],      @"page",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/friends/bilateral.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetBilateralUserList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户双向关注的用户user列表，即互粉user列表 不分页
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/friends/bilateral.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetBilateralUserListAll];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    //https://api.weibo.com/2/friendships/friends.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",cursor],      @"cursor",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/friends.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetFollowingUserList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    //https://api.weibo.com/2/friendships/followers.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",cursor],    @"cursor",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/followers.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetFollowedUserList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid
{
    //https://api.weibo.com/2/friendships/create.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"friendships/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaFollowByUserID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName
{
    //https://api.weibo.com/2/friendships/create.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       userName,     @"screen_name",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"friendships/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaFollowByUserName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid
{
    //https://api.weibo.com/2/friendships/destroy.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"friendships/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaUnfollowByUserID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName
{
    //https://api.weibo.com/2/friendships/destroy.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       userName,     @"screen_name",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"friendships/destroy.jso" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaUnfollowByUserName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName
{   
    //http://api.t.sina.com.cn/trends/statuses.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       SINA_APP_KEY,@"source",
                                       [trendName encodeAsURIComponent],@"trend_name",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:@"http://api.t.sina.com.cn"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"trends/statuses.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetTrendStatues];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//关注某话题
-(void)followTrend:(NSString*)trendName
{
    //https://api.weibo.com/2/trends/follow.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       trendName,     @"trend_name",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"trends/follow.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaFollowTrend];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID
{
    //https://api.weibo.com/2/trends/destroy.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",trendID],     @"trend_id",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"trends/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaUnfollowTrend];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}


//发布文字微博
-(void)postWithText:(NSString*)text
{
    //https://api.weibo.com/2/statuses/update.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       text,     @"status",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaPostText];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//发布文字位置微博
-(void)postWithText:(NSString*)text:(float)po_lat:(float)po_long
{
    //https://api.weibo.com/2/statuses/update.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       text,     @"status",
                                       [[NSNumber alloc] initWithFloat:po_lat], @"lat",
                                       [[NSNumber alloc] initWithFloat:po_long]       ,@"long",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaPostText];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image
{
    //https://api.weibo.com/2/statuses/upload.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       text,     @"status",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"statuses/upload.json" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData: UIImagePNGRepresentation(image) name:@"pic" fileName:@"abc.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //老子完全不能理解这个地方为什么会出现412错误，尼玛，新浪的死服务器问题么！
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaPostTextAndImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
        
    }];
    
    [operation start];
}

//发布文字图片位置微博
-(void)postWithText:(NSString *)text image:(UIImage*)image:(float)po_lat:(float)po_long
{
    //https://api.weibo.com/2/statuses/upload.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       text,     @"status",
                                       [[NSNumber alloc] initWithFloat:po_lat], @"lat",
                                       [[NSNumber alloc] initWithFloat:po_long]       ,@"long",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"statuses/upload.json" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData: UIImagePNGRepresentation(image) name:@"pic" fileName:@"abc.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaPostTextAndImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
        
    }];
    
    [operation start];
}


//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    //https://api.weibo.com/2/statuses/home_timeline.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,@"access_token",nil];
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    if (page >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",page];
        [params setObject:tempString forKey:@"page"];
    }
    if (baseApp >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
        [params setObject:tempString forKey:@"baseApp"];
    }
    if (feature >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
        [params setObject:tempString forKey:@"feature"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetHomeLine];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    //https://api.weibo.com/2/statuses/user_timeline.json
    
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,@"access_token",nil];
    [params setObject:uid forKey:@"uid"];
    NSLog(@"uid = %@",uid);
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    if (page >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",page];
        [params setObject:tempString forKey:@"page"];
    }
    if (baseApp >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
        [params setObject:tempString forKey:@"baseApp"];
    }
    if (feature >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
        [params setObject:tempString forKey:@"feature"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetUserStatus];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//转发一条微博
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment
{
    //https://api.weibo.com/2/statuses/repost.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       content,     @"status",
                                       weiboID,     @"id",
                                       [NSString stringWithFormat:@"%d",isComment],     @"is_comment",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"statuses/repost.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaRepost];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//评论一条微博
-(void)comment:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment
{
    //https://api.weibo.com/2/comments/create.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       content,     @"comment",
                                       weiboID,     @"id",
                                       [NSString stringWithFormat:@"%d",isComment],     @"comment_ori",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"comments/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaComment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//回复一条评论
-(void)commentOnComment:(NSString *)commentID weiboID:(NSString*)weiboID content:(NSString*)content commentOri:(int)isComment
{
    //https://api.weibo.com/2/comments/reply.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];

    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       content,     @"comment",
                                       weiboID,     @"id",
                                       [NSString stringWithFormat:@"%d",isComment],     @"comment_ori",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"comments/reply.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaCommentOnComment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count
{
    //https://api.weibo.com/2/statuses/hot/repost_daily.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       countString, @"count",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/hot/repost_daily.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetHotRepostDaily];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.request.URL);
        [self requestFailed:error];
    }];
}

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count
{
    //https://api.weibo.com/2/statuses/hot/comments_daily.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       countString, @"count",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/hot/comments_daily.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetHotCommentDaily];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//返回推荐的热门信息
-(void)getHot:(int)type is_pic:(BOOL)is
{
    //https://api.weibo.com/2/suggestions/statuses/hot.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSString                *countString = [NSString stringWithFormat:@"%d",type];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       countString, @"type",
                                       [NSString stringWithFormat:@"%d",is], @"is_pic",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"suggestions/statuses/hot.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetHot];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid
{
    //http://rm.api.weibo.com/2/remind/unread_count.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       uid,         @"uid",
                                       nil];
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetUnreadCount];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses :(int64_t)sinceID maxID:(int64_t)maxID count:(int)count 
{
    //https://api.weibo.com/2/statuses/mentions.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"statuses/mentions.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SINAGetMetionsStatuses];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取登录用户的评论列表
-(void)getCommentsStatuses :(int64_t)sinceID maxID:(int64_t)maxID count:(int)count
{
    //https://api.weibo.com/2/comments/to_me.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"comments/to_me.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SINAGetCommentsStatuses];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取两个用户之间的关系
-(void)getFriendShips:(int64_t)source_id sourceName:(NSString*)source_name targetId:(int64_t)target_id targetName:(NSString *)targetName
{
    //https://api.weibo.com/2/friendships/show.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,   @"access_token",nil];
    
    if (source_id >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",source_id];
        [params setObject:tempString forKey:@"source_id"];
    }
    if (source_name){
        [params setObject:source_name forKey:@"source_screen_name"];
    }
    if (target_id >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",target_id];
        [params setObject:tempString forKey:@"target_id"];
    }
    if (targetName){
        [params setObject:targetName forKey:@"target_screen_name"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaFriendShips];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//获取优质粉丝
-(void)getActiveFollower:(long long)uid count:(int)count
{
    //https://api.weibo.com/2/friendships/followers/active.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,   @"access_token",nil];
    NSString *tempString = [NSString stringWithFormat:@"%lld",uid];
    [params setObject:tempString forKey:@"uid"];
    if (count){
        [params setObject:[NSNumber numberWithInt:count] forKey:@"count"];
    }
    NSURL                   *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"friendships/followers/active.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaGetActiveFollower];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

//删除一条微博
-(void)deleteMessage:(int64_t)ID
{
    //https://api.weibo.com/2/statuses/destroy.json
    NSURL *url = [NSURL URLWithString:SINA_V2_DOMAIN];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",ID],     @"id",
                                       nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:@"statuses/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:operation type:SinaDeleteMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:error];
    }];
}

#pragma mark - ASINetworkQueueDelegate
//失败
- (void)requestFailed:(NSError *)error{
    NSLog(@"requestFailed:%@",[error localizedDescription]);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaRequestFailed object:[error localizedDescription]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(requestFailed:)]){
        [self.delegate performSelector:@selector(requestFailed:) withObject:error];
    }
}

//成功
- (void)requestFinished:(AFHTTPRequestOperation *)request type:(RequestType)type{
    RequestType requestType = type;
    NSString * responseString = [request responseString];
    //NSLog(@"responseString = %@",responseString);
    
    //认证失败
    //{"error":"auth faild!","error_code":21301,"request":"/2/statuses/home_timeline.json"}   
    id  returnObject = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        NSString *errorString = [returnObject  objectForKey:@"error"];
        if (errorString != nil && ([errorString isEqualToString:@"auth faild!"] || 
                                   [errorString isEqualToString:@"expired_token"] || 
                                   [errorString isEqualToString:@"invalid_access_token"])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NeedToReLogin object:nil];
            if ([self.delegate respondsToSelector:@selector(NeedRelogin)]){
                [self.delegate performSelector:@selector(NeedRelogin)];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
            NSLog(@"detected auth faild!");
        }
    }
    
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    else {
        return;
    }
    
    
    //获取最新的公共微博
    if (requestType == SinaGetPublicTimeline) {
        NSLog(@"获取最新的公共微博");
        NSArray         *arr        = [userInfo objectForKey:@"statuses"];
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetPublicTimelineWithStatues:)]) {
            [delegate didGetPublicTimelineWithStatues:statuesArr];
        }
    }
    
    //获取登陆用户ID
    if (requestType == SinaGetUserID) {
        NSLog(@"获取登陆用户ID");
        NSNumber *userID = [userInfo objectForKey:@"uid"];
        self.userId = [NSString stringWithFormat:@"%@",userID];
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
        if ([delegate respondsToSelector:@selector(didGetUserID:)]) {
            [delegate didGetUserID:userId];
        }
    }
    
    //用户登出
    if (requestType == SinaSignOut) {
        NSLog(@"用户登出");
        User *user = [[User alloc]initWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didSignOut:)]) {
            [delegate didSignOut:user];
        }
    }
    
    //获取任意一个用户的信息
    if (requestType == SinaGetUserInfo) {
        NSLog(@"获取任意一个用户的信息");
        User *user = [[User alloc]initWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didGetUserInfo:)]) {
            [delegate didGetUserInfo:user];
        }
    }
    
    //根据微博消息ID返回某条微博消息的评论列表
    if (requestType == SinaGetComment) {  
        NSLog(@"根据微博消息ID返回某条微博消息的评论列表");
        NSArray         *arr        = [userInfo objectForKey:@"comments"];
        NSNumber        *count      = [userInfo objectForKey:@"total_number"];
        if (arr == nil || [arr isEqual:[NSNull null]]) {
            return;
        }
        
        NSMutableArray  *commentArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Comment *comm = [Comment commentWithJsonDictionary:item];
            [commentArr addObject:comm];
        }
        
        if ([delegate respondsToSelector:@selector(didGetCommentList:)]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:commentArr,@"commentArrary",count,@"count", nil];
            [delegate didGetCommentList:dic];
        }
    }
    
    //获取用户双向关注的用户ID列表，即互粉UID列表
    if (requestType == SinaGetBilateralIdList || requestType == SinaGetBilateralIdListAll) {
        NSLog(@"获取用户双向关注的用户ID列表，即互粉UID列表");
        NSArray *arr = [userInfo objectForKey:@"ids"];
        if ([delegate respondsToSelector:@selector(didGetBilateralIdList:)]) {
            [delegate didGetBilateralIdList:arr];
        }
    }
    
    //获取用户的双向关注user列表，即互粉列表
    if (requestType == SinaGetBilateralUserList || requestType == SinaGetBilateralUserListAll) {
        NSLog(@"获取用户的双向关注user列表，即互粉列表");
        NSArray *arr = [userInfo objectForKey:@"users"];
        NSMutableArray *userArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            User *user = [[User alloc]initWithJsonDictionary:item];
            [userArr addObject:user];
        }
        if ([delegate respondsToSelector:@selector(didGetBilateralUserList:)]) {
            [delegate didGetBilateralUserList:userArr];
        }
    }
    
    //获取用户的关注列表
    if (requestType == SinaGetFollowingUserList) {   
        NSLog(@"获取用户的关注列表");
        NSArray *arr = [userInfo objectForKey:@"users"];
        NSNumber *next = [userInfo objectForKey:@"next_cursor"];
        NSMutableArray *userArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            User *user = [[User alloc]initWithJsonDictionary:item];
            [userArr addObject:user];
        }
        if ([delegate respondsToSelector:@selector(didGetFollowingUsersList:)]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userArr,@"userArrary",next,@"nextcursor", nil];
            [delegate didGetFollowingUsersList:dic];
        }
    }
        
    //获取用户粉丝列表
    if (requestType == SinaGetFollowedUserList) {   
        NSLog(@"获取用户粉丝列表");
        NSArray *arr = [userInfo objectForKey:@"users"];
        NSNumber *next = [userInfo objectForKey:@"next_cursor"];
        NSMutableArray *userArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            User *user = [[User alloc]initWithJsonDictionary:item];
            [userArr addObject:user];
        }
        if ([delegate respondsToSelector:@selector(didGetFollowedUsersList:)]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userArr,@"userArrary",next,@"nextcursor", nil];
            [delegate didGetFollowedUsersList:dic];
        }
    }
    
    //关注一个用户 by User ID or Name
    if (requestType == SinaFollowByUserID || requestType == SinaFollowByUserName) {
        NSLog(@"关注一个用户 by User ID or Name");
        int result = 1;
        id ID = [userInfo objectForKey:@"id"];
        
        if (ID != nil && ID != [NSNull null]) {
            result = 0; //succeed
        }
        else
        {
            result = 1; //failed
        }
        
        //NSString *uid = [userInformation objectForKey:@"uid"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];    
        [dic setObject:[NSNumber numberWithInt:result] forKey:@"result"];
        //if (uid != nil) {
        //    [dic setObject:uid forKey:@"uid"];
        //}
        
        if ([delegate respondsToSelector:@selector(didFollowByUserIDWithResult:)]) {
            [delegate didFollowByUserIDWithResult:dic];
        }
    }
    
    //取消关注一个用户 by User ID or Name
    if (requestType == SinaUnfollowByUserID || requestType == SinaUnfollowByUserName) {
        NSLog(@"取消关注一个用户 by User ID or Name");
        int result = 1;
        id ID = [userInfo objectForKey:@"id"];
        
        if (ID != nil && ID != [NSNull null]) {
            result = 0; //succeed
        }
        else
        {
            result = 1; //failed
        }
        
        //NSString *uid = [userInformation objectForKey:@"uid"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];    
        [dic setObject:[NSNumber numberWithInt:result] forKey:@"result"];
        //if (uid != nil) {
        //    [dic setObject:uid forKey:@"uid"];
        //}
        if ([delegate respondsToSelector:@selector(didUnfollowByUserIDWithResult:)]) {
            [delegate didUnfollowByUserIDWithResult:dic];
        }
    }
    
    //
    if (requestType == SinaGetTrendStatues) {
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in userArr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetTrendStatues:)]) {
            [delegate didGetTrendStatues:statuesArr];
        }
    }
    
    //关注某话题
    if (requestType == SinaFollowTrend) {
        NSLog(@"关注某话题");
        int64_t topicID = [[userInfo objectForKey:@"topicid"] longLongValue];
        if ([delegate respondsToSelector:@selector(didGetTrendIDAfterFollowed:)]) {
            [delegate didGetTrendIDAfterFollowed:topicID];
        }
    }
    
    //取消对某话题的关注
    if (requestType == SinaUnfollowTrend) {
        NSLog(@"取消对某话题的关注");
        BOOL isTrue = [[userInfo objectForKey:@"result"] boolValue];
        if ([delegate respondsToSelector:@selector(didGetTrendResultAfterUnfollowed:)]) {
            [delegate didGetTrendResultAfterUnfollowed:isTrue];
        }
    }
    
    //获取热门话题
    if (requestType == SinaGetHotTrend){
        NSLog(@"获取热门话题");
        NSArray *arr = [userInfo objectForKey:@"trends"];
        id f;
        for (id x in arr){
            f = x;
        }
        NSDictionary *dic = (NSDictionary *)arr;
        NSArray *xarr = [dic objectForKey:f];
        if ([delegate respondsToSelector:@selector(didGetHotTrends:)]) {
            [delegate didGetHotTrends:xarr];
        }
    }
    
    //发布文字微博 & 图文微博
    if (requestType ==SinaPostText || requestType == SinaPostTextAndImage) {
        NSLog(@"发布文字微博 & 图文微博");
        Status* sts = [Status statusWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didGetPostResult:)]) {
            [delegate didGetPostResult:sts];
        }
    }
    
    //获取当前登录用户及其所关注用户的最新微博
    if (requestType == SinaGetHomeLine) {
        NSLog(@"获取当前登录用户及其所关注用户的最新微博");
        NSArray *arr = [userInfo objectForKey:@"statuses"];
        
        if (arr == nil || [arr isEqual:[NSNull null]]) 
        {
            if ([delegate respondsToSelector:@selector(didGetHomeLine:)]) {
                [delegate didGetHomeLine:nil];
            }
            return;
        }
        
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetHomeLine:)]) {
            [delegate didGetHomeLine:statuesArr];
        }
    }
    
    //获取某个用户最新发表的微博列表
    if (requestType == SinaGetUserStatus) {
        NSLog(@"获取某个用户最新发表的微博列表");
        NSArray *arr = [userInfo objectForKey:@"statuses"];
        
        if (arr == nil || [arr isEqual:[NSNull null]]) 
        {
            return;
        }
        
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetUserStatus:)]) {
            [delegate didGetUserStatus:statuesArr];
        }
    }
    
    //转发一条微博
    if (requestType == SinaRepost) {
        NSLog(@"转发一条微博");
        Status* sts = [Status statusWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didRepost:)]) {
            [delegate didRepost:sts];
        }
    }
    
    //评论一条微博
    if (requestType == SinaComment) {
        NSLog(@"评论一条微博");
        Comment* com = [Comment commentWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didComment:)]) {
            [delegate didComment:com];
        }
    }
    
    //回复一条评论
    if (requestType == SinaCommentOnComment) {
        NSLog(@"回复一条评论");
        Comment* com = [Comment commentWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didComment:)]) {
            [delegate didComment:com];
        }
    }
    
    //按天返回热门微博转发榜的微博列表
    if (requestType == SinaGetHotRepostDaily) {
        NSLog(@"按天返回热门微博转发榜的微博列表");
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in userArr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetHotRepostDaily:)]) {
            [delegate didGetHotRepostDaily:statuesArr];
        }
    }
    
    //按天返回热门微博评论榜的微博列表
    if (requestType == SinaGetHotCommentDaily) {
        NSLog(@"按天返回热门微博评论榜的微博列表");
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in userArr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetHotCommentDaily:)]) {
            [delegate didGetHotCommentDaily:statuesArr];
        }
    }
    
    //获取推荐的热门消息
    if (requestType == SinaGetHot) {
        NSLog(@"获取推荐的热门消息");
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in userArr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetHot:)]) {
            [delegate didGetHot:statuesArr];
        }
    }
    
    //获取某个用户的各种消息未读数
    if (requestType == SinaGetUnreadCount) {
        NSLog(@"获取某个用户的各种消息未读数");
        if ([delegate respondsToSelector:@selector(didGetUnreadCount:)]) {
            [delegate didGetUnreadCount:userInfo];
        }
    }
    
    //获取最新的提到登录用户的微博列表，即@我的微博
    if (requestType == SINAGetMetionsStatuses) {
        NSLog(@"获取最新的提到登录用户的微博列表，即@我的微博");
        NSArray *arr = [userInfo objectForKey:@"statuses"];
        
        if (arr == nil || [arr isEqual:[NSNull null]]) 
        {
            return;
        }
        
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Status* sts = [Status statusWithJsonDictionary:item];
            if (sts.user)
                [statuesArr addObject:sts];
        }
        if ([delegate respondsToSelector:@selector(didGetMetionsStatused:)]) {
            [delegate didGetMetionsStatused:statuesArr];
        }
    }
    
    //获取登录用户的评论
    if (requestType == SINAGetCommentsStatuses) {
        NSLog(@"获取登录用户的评论");
        NSArray *arr = [userInfo objectForKey:@"comments"];
        
        if (arr == nil || [arr isEqual:[NSNull null]])
        {
            return;
        }
        
        NSMutableArray  *commentArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Comment* com = [Comment commentWithJsonDictionary:item];
            if (com.user)
                [commentArr addObject:com];
        }
        if ([delegate respondsToSelector:@selector(didGetCommentsStatused:)]) {
            [delegate didGetCommentsStatused:commentArr];
        }
    }
    
    //获取两个用户之间的关系
    if (requestType == SinaFriendShips) {
        NSLog(@"获取两个用户之间的关系");
        NSDictionary *dic = [userInfo objectForKey:@"target"];
        if ([delegate respondsToSelector:@selector(didGetFriendShips:)]) {
            [delegate didGetFriendShips:dic];
        }
    }
    
    //获取优质用户粉丝
    if (requestType == SinaGetActiveFollower) {
        NSLog(@"获取优质用户粉丝");
        NSArray *arr = [userInfo objectForKey:@"users"];
        NSMutableArray *userArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            User *user = [[User alloc]initWithJsonDictionary:item];
            [userArr addObject:user];
        }
        if ([delegate respondsToSelector:@selector(didGetActiveFollower:)]) {
            [delegate didGetActiveFollower:userArr];
        }
    }
    
    //删除一条微博
    if (requestType == SinaDeleteMessage) {
        NSLog(@"删除一条微博");
        Status* sts = [Status statusWithJsonDictionary:userInfo];
        if ([delegate respondsToSelector:@selector(didDelete:)]) {
            [delegate didDelete:sts];
        }
    }
    
    //根据微博消息ID返回某条微博消息的转发列表
    if (requestType == SinaGetRepost) {  
        NSLog(@"根据微博消息ID返回某条微博消息的转发列表");
        NSArray         *arr        = [userInfo objectForKey:@"reposts"];
        NSNumber        *count      = [userInfo objectForKey:@"total_number"];
        if (arr == nil || [arr isEqual:[NSNull null]]) {
            return;
        }
        
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in arr) {
            Status *sts = [Status statusWithJsonDictionary:item];
            [statuesArr addObject:sts];
        }
        
        if ([delegate respondsToSelector:@selector(didGetCommentList:)]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:statuesArr,@"repostArrary",count,@"count", nil];
            [delegate didGetRepostList:dic];
        }
    }
}

@end
