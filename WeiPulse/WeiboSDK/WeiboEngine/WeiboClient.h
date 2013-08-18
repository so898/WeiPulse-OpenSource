//
//  WeiboClient.h
//  WeiboFon
//
//  Created by kaz on 7/13/08.
//  Copyright naan studio 2008. All rights reserved.
//
//  Amended by Bill Cheng on 11/07/2012
//  Copyright (c) 2012 R3 Studio All rights reserved.
#import <UIKit/UIKit.h>
#import "URLConnection.h"
#import "Status.h"


typedef enum {
    WEIBO_REQUEST_TIMELINE,
    WEIBO_REQUEST_REPLIES,
    WEIBO_REQUEST_MESSAGES,
    WEIBO_REQUEST_SENT,
    WEIBO_REQUEST_FAVORITE,
    WEIBO_REQUEST_DESTROY_FAVORITE,
    WEIBO_REQUEST_CREATE_FRIENDSHIP,
    WEIBO_REQUEST_DESTROY_FRIENDSHIP,
    WEIBO_REQUEST_FRIENDSHIP_EXISTS,
} RequestType;

@interface WeiboClient : URLConnection
{
    RequestType request;
    id          __unsafe_unretained context;
    SEL         action;
    BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;
    
    BOOL _secureConnection;
}

@property(nonatomic, readonly) RequestType request;
@property(nonatomic, unsafe_unretained) id context;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;

- (id)initWithTarget:(id)aDelegate engine:(OAuthEngine *)__engine action:(SEL)anAction;

- (void)getPublicTimeline; // statuses/public_timeline

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline
- (void)getFollowedTimelineSinceID:(long long)sinceID withMaximumID:(long long)maxID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline

- (void)getMentionsMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getMentionsSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count;
- (void)getMentionsSinceID:(long long)sinceID 
			 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)favorite:(long long)statusId;
- (void)unfavorite:(long long)statusId;

- (void)getCommentCounts:(NSMutableArray *)statuses;

- (void)getComments:(long long)statusId 
	 startingAtPage:(int)page 
			  count:(int)count;

- (void)getFriends:(int)userId 
			cursor:(int)cursor 
			 count:(int)count;

- (void)getFollowers:(int)userId 
			  cursor:(int)cursor 
			   count:(int)count;

- (void)getUser:(int)userId;

- (void)getUserByScreenName:(NSString *)screenName;

- (void)getFriendship:(int)userId;

- (void)follow:(int)userId;

- (void)unfollow:(int)userId;

- (void)post:(NSString*)tweet;

- (void)postWithLocation:(NSString *)tweet:(float)latp:(float)longp;

- (void)upload:(NSData*)jpeg status:(NSString *)status;

- (void)uploadWithLocation:(NSData*)jpeg status:(NSString *)status:(float)latp:(float)longp;

- (void)repost:(long long)statusId
		 tweet:(NSString*)tweet;

- (void)comment:(long long)statusId
	  commentId:(long long)commentId
		comment:(NSString*)comment;

- (void)sendDirectMessage:(NSString*)text 
					   to:(int)recipientedId;

- (NSString *)getURL:(NSString *)path 
	 queryParameters:(NSMutableDictionary*)params;

- (void)alert;

@end
