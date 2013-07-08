//
//  DinnerTableViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "DinnerTableViewController.h"
#import "UITools.h"

@interface DinnerTableViewController ()

@end

@implementation DinnerTableViewController

@synthesize dinnerPlan = _dinnerPlan;
@synthesize lb_menu = _lb_menu;
@synthesize lb_name = _lb_name;
@synthesize iv_msgBack = _iv_msgBack;

-(void) dealloc{
    [_dinnerPlan release];
    [_lb_name release];
    [_lb_menu release];
    [_iv_msgBack release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lb_name setText:_dinnerPlan.name];
    CGFloat oldheight = _lb_menu.frame.size.height;
    [_lb_menu setText:_dinnerPlan.menus];
    [_lb_menu reSizeMake];
    float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];  
    UIImage *contentLableBackImage = nil;
    if (iosVersion >= 5.0)  
    {  
        contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 33, 10, 10)];
    }else {
        contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]stretchableImageWithLeftCapWidth:33 topCapHeight:10];
    }
    [_iv_msgBack setImage:contentLableBackImage];
    [_iv_msgBack setFrame:CGRectMake(_iv_msgBack.frame.origin.x, _iv_msgBack.frame.origin.y, _iv_msgBack.frame.size.width, _iv_msgBack.frame.size.height + _lb_menu.frame.size.height - oldheight)];
    
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _lb_menu.frame.size.height - 20 + 116);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
