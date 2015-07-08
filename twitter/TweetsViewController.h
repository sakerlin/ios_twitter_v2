//
//  TweetsViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/6/28.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "MainViewController.h"
@protocol TweetsViewControllerDelegate <NSObject>
@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition:(NSInteger *)row;

@end

@interface TweetsViewController : UIViewController<LeftMenuViewControllerDelegate, MainViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@property (nonatomic, assign) id<TweetsViewControllerDelegate> delegate;
- (void)goMenuPage:(NSInteger *)row;
@end
