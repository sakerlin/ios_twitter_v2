//
//  ProfileViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/7/6.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@interface ProfileViewController : UIViewController
@property (nonatomic, strong) Tweet *originalTweet;
@property (nonatomic, strong) User *user;
@end
