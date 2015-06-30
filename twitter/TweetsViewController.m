//
//  TweetsViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/6/28.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetsCell.h"
#import "SVProgressHUD.h"
@interface TweetsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(atomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreView;
@property (nonatomic, assign) NSInteger lastTweetsCount;
@property (nonatomic, assign) BOOL isInfiniteLoading;
@property (nonatomic, assign) BOOL isInitLoading;
@property (nonatomic, assign) BOOL isPullDownRefreshing;
@property (weak, nonatomic) IBOutlet UINavigationBar *tweetNav;

@property (nonatomic, assign) BOOL isLoadingOnTheFly;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
          
  
    [self getHomeTimeline:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:nil] forCellReuseIdentifier:@"TweetsCell"];
    self.tableView.estimatedRowHeight = 94;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     //pull to refesh
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onPulltofresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    self.loadMoreView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadMoreView.center = tableFooter.center;
    [tableFooter addSubview:self.loadMoreView];
    self.tableView.tableFooterView = tableFooter;
    
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor  colorWithRed:184.0f/255.0f green:11.0f/255.0f blue:4.0f/255.0f alpha:1.0f]];
    //[User logout];
    
    //init status
    self.lastTweetsCount = 0;
    self.isInitLoading = YES;
    self.isInfiniteLoading = NO;

}
// Pull down support
- (void)onLogoutButton {
   [User logout];
}
// Pull down support
- (void)onPulltofresh {
    self.isPullDownRefreshing = YES;
    [self getHomeTimeline:nil];
}
- (void)getHomeTimeline:(NSMutableDictionary *)params{
    self.isLoadingOnTheFly = YES;
    NSMutableDictionary *finalParams = params;
    
    if (finalParams == nil) {
        finalParams = [[NSMutableDictionary alloc] init];
        [finalParams setObject:@(20) forKey:@"count"];
    }
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [[TwitterClient sharedInstance] homeTimelineWithParams:finalParams completion:^(NSArray *tweets, NSError *error) {
        if (!error) {
            
            if (self.isInfiniteLoading) {
                [self.tweets addObjectsFromArray:tweets];
            } else {
                self.tweets = [NSMutableArray arrayWithArray:tweets];
            }
            
            self.lastTweetsCount = tweets.count;
            [self.tableRefreshControl endRefreshing];
            if (!self.isInitLoading) {
                //self.backgroundView.hidden = YES;
                self.tableView.hidden = NO;
                self.navigationController.navigationBarHidden = NO;
            } else {
                self.isInitLoading = NO;
                //[self loadCompletionAnimation];
            }
            
            [self.tableView reloadData];
        } else {
            
        }
        if (self.isPullDownRefreshing) {
            [self.tableRefreshControl endRefreshing];
        }
        if (self.isInfiniteLoading) {
            [self.loadMoreView stopAnimating];
        }
        
        self.isLoadingOnTheFly = NO;
        self.isPullDownRefreshing = NO;
        self.isInfiniteLoading = NO;
        
        [SVProgressHUD dismiss];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    cell.tweet = self.tweets[(NSUInteger) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Infinite loading
    if (indexPath.row == self.tweets.count - 1 && self.lastTweetsCount == 20 && !self.isLoadingOnTheFly) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSInteger max_id = [cell.tweet.tweetId integerValue] - 1;
        [params setObject:@(max_id) forKey:@"max_id"];
        self.isInfiniteLoading = YES;
        NSLog(@"%@",params);
        [self getHomeTimeline:params];
    }
    return cell;
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
