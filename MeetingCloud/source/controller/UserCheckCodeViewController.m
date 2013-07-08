//
//  UserCheckCodeViewController.m
//  MeetingCloud
//
//  Created by he songhang on 12-12-25.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "UserCheckCodeViewController.h"
#import "MBProgressHUD.h"
#import "HttpHelper.h"
#import "UITools.h"

@interface UserCheckCodeViewController ()

-(void) loadImageUrl;

-(void) loadTime;

@end

@implementation UserCheckCodeViewController


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
    [self loadImageUrl];
    [self performSelector:@selector(loadTime) withObject:nil afterDelay:1];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) loadTime{
    NSString *string = [UITools myDate:@"hh:mm:ss" dates:0];
    [lb_time setText:string];
    [self performSelector:@selector(loadTime) withObject:nil afterDelay:1];
}


-(void) loadImageUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        HttpHelper *helper = [[HttpHelper alloc]init];
        NSString *url = [helper loadCodeUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!helper.error) {
                [iv_img setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
            }else{
                [UITools easyAlert:[UITools getErrorMsg:helper.error] cancelButtonTitle:@"确定"];
            }
        });
    });
    
}
- (void)dealloc {
    [lb_time release];
    [super dealloc];
}
- (void)viewDidUnload {
    [lb_time release];
    lb_time = nil;
    [super viewDidUnload];
}
@end
