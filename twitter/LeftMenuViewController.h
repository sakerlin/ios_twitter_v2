//
//  LeftMenuViewController.h
//  twitter
//
//  Created by Saker Lin on 2015/7/7.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional

- (void)selectMenuRow:(NSInteger *)row;
 
@end

@interface LeftMenuViewController : UIViewController
@property (nonatomic, assign) id<LeftMenuViewControllerDelegate> delegate;
@end
