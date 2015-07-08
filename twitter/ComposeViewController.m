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
    
    if(!self.originalTweet){
        User *user = [User currentUser];
        [self.userProfileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl] ];
        self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", user.screen_name];
        self.userNameLabel.text = user.name;
    } else {
        
        [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.originalTweet.user.profileImageUrl] ];
        self.userScrennNameLabel.text = [NSString stringWithFormat:@"@%@", self.originalTweet.user.screen_name];
        self.userNameLabel.text = self.originalTweet.user.name;
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.originalTweet.user.screen_name];
    }
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

- (IBAction)onCancel:(id)sender {
    [self.view endEditing:YES];
    [_delegate cancelCompose];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPost:(id)sender {
    if(self.textView.text.length > 0){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.textView.text forKey:@"status"];
        if(self.originalTweet){
            [params addEntriesFromDictionary:@{@"in_reply_to_status_id" : self.originalTweet.tweetId}];
        }
        [[TwitterClient sharedInstance] doTweet:params completion:nil];
        [self.textView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) textViewDidChangeSelection:(UITextView *)textView{
    self.postCounterLabel.text = [NSString stringWithFormat:@"%ld",self.textView.text.length];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
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
