//
//  TweetsCell.m
//  twitter
//
//  Created by Saker Lin on 2015/6/28.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
@interface TweetsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation TweetsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    
    [self.authorImageView setImageWithURL:[NSURL URLWithString:self.tweet.profile_image_url]];
    self.author.text = [NSString stringWithFormat:@"@%@", self.tweet.screen_name];
    self.nickName.text = self.tweet.name;
    self.text.text = self.tweet.text;
    self.timeStamp.text = self.tweet.createdAt.shortTimeAgoSinceNow;
         
}
-(void) layoutSubviews {
    [super layoutSubviews];
    self.nickName.preferredMaxLayoutWidth = self.nickName.frame.size.width;
    
}
@end