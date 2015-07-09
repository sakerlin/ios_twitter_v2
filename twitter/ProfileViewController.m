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
#import "TwitterClient.h"
#import "TweetsCell.h"
#import "UIImage+Blur.h"

@interface ProfileViewController () <UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScrennNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *statusCount;
@property (weak, nonatomic) IBOutlet UILabel *friendCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(atomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, assign) NSString *source;

@property (nonatomic, assign) CGRect cachedImageViewSize;
@property (strong, nonatomic) UIVisualEffectView *imageViewBlurred;
@property (strong, nonatomic) UIVisualEffectView *bannerEffectView;
@property (nonatomic, assign) BOOL isBlurViewOn;
@end

@implementation ProfileViewController
- (IBAction)onBackTap:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.source = @"user_timeline";
    [self getHomeTimeline:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:nil] forCellReuseIdentifier:@"TweetsCell"];
    self.tableView.estimatedRowHeight = 94;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //NSLog(@"color=%@",self.originalTweet.user.profile_background_color);
    //NSString *colorhex = self.originalTweet.user.profile_background_color;
    UIColor *proFileColor = [UIColor colorWithHexString:@"89C9FA"];
    self.profileBanner.backgroundColor = proFileColor;
    
    self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screen_name];
    self.userNameLabel.text = self.user.name;
    self.userDescription.text = [NSString stringWithFormat:@"%@", self.user.userDescription];
    if(self.user.profileBannerImage != nil) {
        [self.profileBanner setImageWithURL:[NSURL URLWithString:self.user.profileBannerImage]];
        self.profileBanner.contentMode = UIViewContentModeScaleAspectFill;
        self.cachedImageViewSize = self.profileBanner.frame;
    }
    if (self.imageViewBlurred == nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.imageViewBlurred = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        self.bannerEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        
    }

    
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
    
    self.scrollView.delegate = self;
    [self.view addGestureRecognizer:self.scrollView.panGestureRecognizer];
    self.tableView.scrollEnabled = NO;
  
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = screenSize.height;
    self.tableView.frame = tableFrame;
    self.isBlurViewOn = NO;
}
- (void)updateSegment{
    NSLog(@"%ld", (long)self.segmentControl.selectedSegmentIndex);
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0: {
            NSLog(@"tweets");
            [self getHomeTimeline:nil];
            break;
        }
            
        case 1: {
            NSLog(@"favorite");
            [self getFavorts:nil];
          break;
        }
            
        default:
            break;
    }
}
- (IBAction)segChange:(id)sender {
    [self updateSegment];
}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
   // NSLog(@"%f",y);
     
    if (y > 0) {
        self.isBlurViewOn = YES;
        self.tableView.scrollEnabled = NO;
        self.profileBanner.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
        [self.imageViewBlurred setFrame:self.profileBanner.bounds];
        [self.profileBanner addSubview:self.imageViewBlurred];
        self.profileBanner.center = CGPointMake(self.contentView.center.x, self.profileBanner.center.y);
    } else {
        if (self.isBlurViewOn) {
            [self.imageViewBlurred removeFromSuperview];
            self.isBlurViewOn = NO;
        }
    }
    
   /*
    else {
        
        self.tableView.scrollEnabled = YES;
        CGFloat newheight = self.cachedImageViewSize.size.height+y;
        if(newheight <= 65){
             newheight = 65.0;
            if (!self.isBlurViewOn) {
                NSLog(@"do blur");
                [self.imageViewBlurred setFrame:self.profileBanner.bounds];
                [self.profileBanner addSubview:self.imageViewBlurred];

                [self.bannerEffectView setFrame:self.profileBanner.bounds];
                [self.imageViewBlurred.contentView addSubview:self.bannerEffectView];
                self.isBlurViewOn = YES;
            }
           
             [self.topView bringSubviewToFront:self.profileBanner];
        }  else {
            if (self.isBlurViewOn) {
                [self.imageViewBlurred removeFromSuperview];
                self.isBlurViewOn = NO;
            }
            
        }
        self.profileBanner.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width, newheight);
        self.profileBanner.center = CGPointMake(self.contentView.center.x, self.profileBanner.center.y);
   }
     */
    
}


- (void)getFavorts:(NSMutableDictionary *)params{
    
    NSMutableDictionary *finalParams = params;
     if (finalParams == nil) {
        finalParams = [[NSMutableDictionary alloc] init];
        [finalParams setObject:self.user.screen_name forKey:(@"screen_name")];
        [finalParams setObject:@(20) forKey:@"count"];
    }
    NSLog(@"finalParams=%@", finalParams);
    
    [[TwitterClient sharedInstance] getFavorite:finalParams source:self.source completion:^(NSArray *tweets, NSError *error) {
        if (!error) {
            self.tweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
            CGRect tviewBound = [self.contentView bounds];
            CGSize tviewSize = tviewBound.size;
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            CGRect tableFrame = self.tableView.frame;
            tableFrame.size.height = 2000 + tviewSize.height;
            self.tableView.frame = tableFrame;
            screenSize.height =   2000  + tviewSize.height;
            self.scrollView.contentSize = screenSize;
        }
    }];
}

- (void)getHomeTimeline:(NSMutableDictionary *)params{
    
    NSMutableDictionary *finalParams = params;
    
    if (finalParams == nil) {
        finalParams = [[NSMutableDictionary alloc] init];
        [finalParams setObject:self.user.screen_name forKey:(@"screen_name")];
        [finalParams setObject:@(20) forKey:@"count"];
    }
    NSLog(@"finalParams=%@", finalParams);
    
    [[TwitterClient sharedInstance] timelineWithParams:finalParams source:self.source completion:^(NSArray *tweets, NSError *error) {
        if (!error) {
                self.tweets = [NSMutableArray arrayWithArray:tweets];
                [self.tableView reloadData];
            
            CGRect tviewBound = [self.contentView bounds];
            CGSize tviewSize = tviewBound.size;
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            CGRect tableFrame = self.tableView.frame;
            tableFrame.size.height = 2000 + tviewSize.height;
            self.tableView.frame = tableFrame;
            screenSize.height =   2000  + tviewSize.height;
            self.scrollView.contentSize = screenSize;
         }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    cell.tweet = self.tweets[(NSUInteger) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.delegate = self;
    // Infinite loading
    
    return cell;
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
