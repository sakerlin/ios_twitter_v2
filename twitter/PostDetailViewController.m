//
//  PostDetailViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/7/2.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "PostDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface PostDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScrennNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *tweetPhotoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetPhotoImageHeight;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@end

@implementation PostDetailViewController
- (IBAction)onFav:(id)sender {
    if(self.originalTweet.favorited){
        [self.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        self.originalTweet.favorited = NO;
        self.originalTweet.favCount --;
        [[TwitterClient sharedInstance] doUnFavorite:self.originalTweet.tweetId completion:nil];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"faved"] forState:UIControlStateNormal];
        self.originalTweet.favorited = YES;
        self.originalTweet.favCount ++;
        [[TwitterClient sharedInstance] doFavorite:self.originalTweet.tweetId completion:nil];
    }
   
}
- (IBAction)onBack:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onReply:(id)sender {
        ComposeViewController *Cvc = [[ComposeViewController alloc] init];
        Cvc.originalTweet = self.originalTweet;
        [self presentViewController:Cvc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.originalTweet.user.profileImageUrl] ];
    self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", self.originalTweet.user.screen_name];
    self.userNameLabel.text = self.originalTweet.user.name;
    self.contentText.text = self.originalTweet.text;
    //self.tweetPhotoImageHeight.constant = 0.0;
    NSLog(@"<==========================");
    NSLog( self.originalTweet.favorited ? @"favorited:YES" : @"favorited:No");
    NSLog( self.originalTweet.retweeted ? @"retweeted:YES" : @"retweeted:No");
    if (self.originalTweet.favorited) {
        [self.favButton setImage:[UIImage imageNamed: @"faved"] forState:UIControlStateNormal];
    }
    if (self.originalTweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed: @"retweeted"] forState:UIControlStateNormal];
    }
    
    if (self.originalTweet.tweetPhotoUrl != nil) {
        [self.tweetPhotoImage setImageWithURL:[NSURL URLWithString:self.originalTweet.tweetPhotoUrl] placeholderImage:[UIImage imageNamed:@"imagePlaceHolder"]];
        //UIImage *image = self.tweetPhotoImage.image;

    } else {
        [self.tweetPhotoImage setImage:nil];
        self.tweetPhotoImageHeight.constant = 0.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
