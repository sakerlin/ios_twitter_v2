//
//  LoginViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/6/25.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController


- (IBAction)onLogin:(id)sender {
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            NSLog(@"%@", user);
        if (user) {
           // [self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
            self.viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self presentViewController:self.viewController animated:YES completion:nil];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to login"
                                                                           message:[NSString stringWithFormat:@("%@"), error.localizedDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *blueColor = [UIColor  colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.view.backgroundColor =  blueColor;
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
