//
//  MainViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/7/7.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainViewControllerDelegate <NSObject>
@optional
 
- (void)movePanelRight;

 @end

@interface MainViewController : UIViewController
@property (nonatomic, assign) id<MainViewControllerDelegate> delegate;
@end
