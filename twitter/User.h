//
//  User.h
//  twitter
//
//  Created by Saker Lin on 2015/6/26.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)logout;
@end
