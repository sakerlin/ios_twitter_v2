//
//  PostDetailViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/7/2.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@interface PostDetailViewController : UIViewController
@property (nonatomic, strong) Tweet *originalTweet;
@end
