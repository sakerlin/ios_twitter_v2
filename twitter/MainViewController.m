//
//  MainViewController.m
//  twitter
//
//  Created by Saker Lin on 2015/7/7.
//  Copyright (c) 2015年 Saker Lin. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "TweetsViewController.h"
#import "LeftMenuViewController.h"
#import "ComposeViewController.h"
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController ()<TweetsViewControllerDelegate, LeftMenuViewControllerDelegate,ComposeViewControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) TweetsViewController *centerViewController;
@property (nonatomic, strong) LeftMenuViewController *leftMenuViewController;
@property (nonatomic, strong) ComposeViewController *composeViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView {
    self.centerViewController = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    [_centerViewController didMoveToParentViewController:self];
    
    [self setupGestures];
}

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_centerViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        } else {
            if (!_showingLeftPanel) {
                childView = [self getRightView];
            }
        }
        
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
           NSLog(@"gesture went right");
        } else {
            NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition:nil];
        } else {
            if (_showingLeftPanel) {
                 [self movePanelRight];
            }  else if (_showingRightPanel) {
                [self movePanelLeft];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
      
        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
        
        
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
       if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)movePanelRight {
    NSLog(@"do movePanelRight");
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            _centerViewController.menuButton.tag = 0;
            }
        }];
}

-(void)movePanelLeft {
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width , 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                            _centerViewController.composeButton.tag = 0;
                         }
                     }];
}
-(UIView *)getLeftView {
   
    if (_leftMenuViewController == nil)
    {
        
        self.leftMenuViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
        self.leftMenuViewController.view.tag = LEFT_PANEL_TAG;
        self.leftMenuViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.leftMenuViewController.view];
        
        [self addChildViewController:_leftMenuViewController];
        [_leftMenuViewController didMoveToParentViewController:self];
        
        _leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftMenuViewController.view;
    return view;
}

-(UIView *)getRightView {
    // init view if it doesn't already exist
    if (_composeViewController == nil)
    {
        // this is where you define the view for the right panel
        self.composeViewController = [[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:nil];
        self.composeViewController.view.tag = RIGHT_PANEL_TAG;
        self.composeViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.composeViewController.view];
        
        [self addChildViewController:self.composeViewController];
        [_composeViewController didMoveToParentViewController:self];
        
        _composeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.showingRightPanel = YES;
    
    // setup view shadows
  //  [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.composeViewController.view;
    return view;
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(void)movePanelToOriginalPosition:(NSInteger *)row {
    NSLog(@"movePanelToOriginalPosition s" );
    NSLog(@"row=%ld", row);
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
        if (finished) {
            [self resetMainView];
            
            if(row >= 0 && row != nil){
                [_centerViewController goMenuPage:row];
            }
        }
    }];
}

-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
    if (_leftMenuViewController != nil) {
        [self.leftMenuViewController.view removeFromSuperview];
        self.leftMenuViewController = nil;
        _centerViewController.menuButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    if (_composeViewController != nil) {
        [self.composeViewController.view removeFromSuperview];
        self.composeViewController = nil;
        _centerViewController.composeButton.tag = 1;
        self.showingRightPanel = NO;
    }
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
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
