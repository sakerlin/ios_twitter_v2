//
//  Tweet.h
//  twitter
//
//  Created by Saker Lin on 2015/6/26.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)dictionaries;
@end
