//
//  ComposeViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/7/1.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@protocol ComposeViewControllerDelegate <NSObject>

@optional
- (void)cancelCompose;

@end
@interface ComposeViewController : UIViewController
@property (nonatomic, strong) Tweet *originalTweet;
@property (nonatomic, assign) id<ComposeViewControllerDelegate> delegate;
@end
