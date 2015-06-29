//
//  TwitterClient.m
//  twitter
//
//  Created by Saker Lin on 2015/6/25.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
NSString * const kTwitterConsumerKey = @"TJTIL8g3TMYTFCb3aYyIZH1Dm";
NSString * const kTwitterConsumerSecret = @"pYQ62WZO0Ox7bvcFCLiSGUIStHbT86vq51ZMGWLjjVcDUz1CfA";
//NSString * const kTwitterConsumerKey = @"NwlJvq274whdPxt2KNBw89ikO";
//NSString * const kTwitterConsumerSecret = @"iZw2uzjwcq7AIbHuaCY5VeIMDcI0YE52BRybFvBAFYR2g2qwAV";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";
@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    // Use dispatch_once to make sure the block inside is thread safe.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    // To clear your previous login state
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authUrl];
    } failure:^(NSError *error) {
        NSLog(@"Faile dot get request token with error %@", error);
        self.loginCompletion(nil, error);
    }];
}
- (void)openURL:(NSURL *)url {
    // third step to get the access token
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        
        // Get current user info
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            /*
            [self getProfileBanner:user.userId completion:^(NSDictionary *bannerData, NSError *error) {
                [user setBannerUrl:bannerData];
                [User setCurrentUser:user];
                self.loginCompletion(user, nil);
            }];
             */
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get user data %@", error);
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get access token %@", error);
        self.loginCompletion(nil, error);
    }];
}
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"%@", responseObject);
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get tweets with error %@", error);
        completion(nil, error);
    }];
}
@end
