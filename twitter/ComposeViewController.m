//
//  ComposeViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/7/1.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScrennNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *postCounterLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onCancelButton)];
    [self.navBar pushNavigationItem:self.navigationItem animated:NO];
    UIColor *blueColor = [UIColor  colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.navBar.barTintColor = blueColor;
    self.navBar.tintColor = [UIColor whiteColor];
    
    if(!self.originalTweet){
        User *user = [User currentUser];
        NSLog(@"no origin tweet");
        [self.userProfileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl] ];
        self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", user.screen_name];
        self.userNameLabel.text = user.name;
        
        self.textView.delegate = self;
    } else {
        NSLog(@"have origin tweet");
        NSLog(@"%@",self.originalTweet.tweetPhotoUrl);
        [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.originalTweet.user.profileImageUrl] ];
        self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", self.originalTweet.user.screen_name];
        self.userNameLabel.text = self.originalTweet.user.name;
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.originalTweet.user.screen_name];
    }
    [self.textView becomeFirstResponder];
}

- (IBAction)onPost:(id)sender {
    if(self.textView.text.length > 0){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.textView.text forKey:@"status"];
        if(self.originalTweet){
            NSLog(@"tweeid = %@",self.originalTweet.tweetId);
            [params addEntriesFromDictionary:@{@"in_reply_to_status_id" : self.originalTweet.tweetId}];
        }
        [[TwitterClient sharedInstance] doTweet:params completion:nil];
        [self.textView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"%ld",self.textView.text.length);
    self.postCounterLabel.text = [NSString stringWithFormat:@"%ld",self.textView.text.length];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)onCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
    //  [self.delegate filtersViewController:self didChangeFilters:self.filters];
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
