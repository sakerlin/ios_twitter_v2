//
//  ProfileViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/7/6.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Expanded.h"
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScrennNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UIView *profileBannerView;
@property (weak, nonatomic) IBOutlet UILabel *statusCount;
@property (weak, nonatomic) IBOutlet UILabel *friendCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;

@end

@implementation ProfileViewController
- (IBAction)onBackTap:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"color=%@",self.originalTweet.user.profile_background_color);
    //NSString *colorhex = self.originalTweet.user.profile_background_color;
    UIColor *proFileColor = [UIColor colorWithHexString:@"89C9FA"];
    self.profileBannerView.backgroundColor = proFileColor;
    self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screen_name];
    self.userNameLabel.text = self.user.name;
    self.userDescription.text = [NSString stringWithFormat:@"%@", self.user.userDescription];
    [self.profileBanner setImageWithURL:[NSURL URLWithString:self.user.profileBannerImage]];
    NSLog(@"%@",self.user.statuses_count);
    self.statusCount.text = [NSString stringWithFormat:@"%@",self.user.statuses_count];
    self.friendCount.text = [NSString stringWithFormat:@"%@",self.user.friends_count];
    self.followerCount.text = [NSString stringWithFormat:@"%@",self.user.followers_count];
    //self.followerCount.text = self.user.friends_count;
    //self.followerCount.text = self.user.followers_count;
    
    self.profileBanner.clipsToBounds = YES;
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userProfileImage.layer.cornerRadius = 4;
    self.userProfileImage.clipsToBounds = YES;
    [self.userProfileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.userProfileImage.layer setBorderWidth: 3.0];
    //@property (nonatomic, assign) NSString *friends_count;
    //@property (nonatomic, assign) NSString *followers_count;
    //@property (nonatomic, assign) NSString *statuses_count;
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
