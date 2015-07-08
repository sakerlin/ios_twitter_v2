//
//  User.m
//  twitter
//
//  Created by Saker Lin on 2015/6/26.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        //NSLog(@"%@",dictionary);
        self.name = dictionary[@"name"];
        self.screen_name = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        self.profileBannerImage = dictionary[@"profile_banner_url"];
        self.userDescription = dictionary[@"description"];
        self.profile_background_color = dictionary[@"profile_background_color"];
        self.friends_count =  dictionary[@"friends_count"];
        self.followers_count =  dictionary[@"followers_count"];
        self.statuses_count = dictionary[@"statuses_count"];
        [dictionary[@"friends_count"] class];
    }
    return self;
}
static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    if (_currentUser != nil) {
        NSLog(@"cereate user data ");
        NSData  *data = [NSJSONSerialization dataWithJSONObject:user.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        // clear the saved object
        NSLog(@"clear user data ");

        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    // Force to save to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    // Notify the logout event
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}
@end
