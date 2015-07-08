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
#import "TwitterClient.h"
#import "ComposeViewController.h"
@interface TweetsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *tweetPhotoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetPhotoImageHeight;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritedLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;



@end

@implementation TweetsCell
- (IBAction)onReply:(id)sender {
    [self.delegate TweetsCell:self onReplyClick:self.tweet];
}
- (IBAction)onRetweet:(id)sender {
    if(self.tweet.retweeted){
       
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweeted"] forState:UIControlStateNormal];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount ++;
        [[TwitterClient sharedInstance] doRetweet:self.tweet.tweetId completion:nil];
    }
    self.favoritedLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];

}
- (IBAction)onFav:(id)sender {
    if(self.tweet.favorited){
        [self.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        self.tweet.favorited = NO;
        self.tweet.favCount --;
                 [[TwitterClient sharedInstance] doUnFavorite:self.tweet.tweetId completion:nil];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"faved"] forState:UIControlStateNormal];
        self.tweet.favorited = YES;
        self.tweet.favCount ++;
        [[TwitterClient sharedInstance] doFavorite:self.tweet.tweetId completion:nil];
    }
    self.favoritedLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favCount];

}

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void) onProfileTap{
    [self.delegate TweetsCell:self onProfileTap:self.tweet];
    NSLog(@"on profile tap");
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
    self.favoritedLabel.text = @"";
    self.retweetLabel.text = @"";
    
    self.timeStamp.text = self.tweet.createdAt.shortTimeAgoSinceNow;
    self.tweetPhotoImageHeight.constant = 0.0;
    self.authorImageView.layer.cornerRadius = 4;
    self.authorImageView.clipsToBounds = YES;
    
    if(self.tweet.favCount > 0){
        self.favoritedLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favCount];
    }
    
    if(self.tweet.retweetCount > 0){
        self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    }
    
    if (self.tweet.favorited) {
        [self.favButton setImage:[UIImage imageNamed: @"faved"] forState:UIControlStateNormal];
    }
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed: @"retweeted"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.tweetPhotoUrl != nil) {
        UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: self.tweet.tweetPhotoUrl]]];
        
        [self.tweetPhotoImage setImageWithURL:[NSURL URLWithString:self.tweet.tweetPhotoUrl] placeholderImage:[UIImage imageNamed:@"imagePlaceHolder"]];
        float ratio = (photo.size.width / photo.size.height);
        self.tweetPhotoImageHeight.constant = self.tweetPhotoImage.image.size.width / ratio;
        
    } else {
        [self.tweetPhotoImage setImage:nil];
        self.tweetPhotoImageHeight.constant = 0.0;
    }
    [self.authorImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [self.authorImageView addGestureRecognizer:tap];
    
    
}
-(void) layoutSubviews {
    [super layoutSubviews];
    self.nickName.preferredMaxLayoutWidth = self.nickName.frame.size.width;
}
@end
