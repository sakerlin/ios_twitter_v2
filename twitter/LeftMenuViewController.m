//
//  LeftMenuViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/7/7.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "LeftMenuViewController.h"
 
@interface LeftMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationBar *tweetNav;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItem;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *blueColor = [UIColor  colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.tweetNav.barTintColor = blueColor;
    self.tweetNav.tintColor = [UIColor whiteColor];
    [self.tweetNav setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    
    self.menuItem = @[@"Profile", @"Home Timeline", @"Mentions"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItem.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
   // NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.menuItem[row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
        NSInteger *row = indexPath.row;
    
    switch ((long)row) {
        case 0:
            NSLog(@"Profile");
            
            break;
        case 1:
            NSLog(@"Home");
            break;
        case 2:
             NSLog(@"Mentions");
            break;
        default:
            break;
    }
    [_delegate selectMenuRow:row];
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
