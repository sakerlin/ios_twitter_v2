//
//  tweetButton.m
//  twitter
//
//  Created by Saker Lin on 2015/7/2.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "tweetButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation tweetButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *blueColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    //round corner
    self.layer.cornerRadius = 5; // this value vary as per your desire
    self.clipsToBounds = YES;
    CGContextSetFillColorWithColor(context, blueColor.CGColor);
    CGContextFillRect(context, self.bounds);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}


@end
